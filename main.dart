
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.init();
  runApp(const LivestockApp());
}

class DatabaseService {
  DatabaseService._();
  static final instance = DatabaseService._();
  late Database db;

  Future<void> init() async {
    final dir = await getDatabasesPath();
    db = await openDatabase(
      path.join(dir, 'livestock.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE animals (id INTEGER PRIMARY KEY AUTOINCREMENT, tag TEXT UNIQUE, breed TEXT, gender TEXT, birthDate TEXT)',
        );
        await database.execute(
          'CREATE TABLE health (id INTEGER PRIMARY KEY AUTOINCREMENT, animalId INTEGER, type TEXT, name TEXT, date TEXT, note TEXT)',
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> animals() =>
      db.query('animals', orderBy: 'id DESC');

  Future<void> addAnimal(String tag, String breed, String gender, String birthDate) async {
    await db.insert('animals', {
      'tag': tag,
      'breed': breed,
      'gender': gender,
      'birthDate': birthDate,
    });
  }

  Future<List<Map<String, dynamic>>> health(int animalId) =>
      db.query('health', where: 'animalId = ?', whereArgs: [animalId], orderBy: 'id DESC');

  Future<void> addHealth(int animalId, String type, String name, String date, String note) async {
    await db.insert('health', {
      'animalId': animalId,
      'type': type,
      'name': name,
      'date': date,
      'note': note,
    });
  }
}

class LivestockApp extends StatelessWidget {
  const LivestockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hayvancılık',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tab = 0;
  List<Map<String, dynamic>> animals = [];

  @override
  void initState() {
    super.initState();
    loadAnimals();
  }

  Future<void> loadAnimals() async {
    animals = await DatabaseService.instance.animals();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final pages = [_home(), _animalList(), _healthMenu(), _more()];
    return Scaffold(
      appBar: AppBar(title: const Text('Hayvancılık')),
      body: pages[tab],
      floatingActionButton: tab == 1
          ? FloatingActionButton.extended(
              onPressed: addAnimal,
              icon: const Icon(Icons.add),
              label: const Text('Hayvan Ekle'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.pets_outlined), label: 'Hayvanlar'),
          NavigationDestination(icon: Icon(Icons.vaccines_outlined), label: 'Sağlık'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Diğer'),
        ],
      ),
    );
  }

  Widget _home() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('İşletme Özeti',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text('${animals.length} hayvan kayıtlı'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _tile('Hayvan Ekle', Icons.add_circle, addAnimal),
          _tile('Aşı / Sağlık', Icons.vaccines,
              () => setState(() => tab = 2)),
          _tile('Süt Takibi', Icons.local_drink,
              () => message('Süt modülü sonraki sürümde.')),
          _tile('Rasyon', Icons.grass,
              () => message('Rasyon modülü sonraki sürümde.')),
        ],
      );

  Widget _animalList() {
    if (animals.isEmpty) {
      return const Center(child: Text('Henüz hayvan yok. Hayvan Ekle ile başlayın.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: animals.length,
      itemBuilder: (_, i) {
        final a = animals[i];
        return Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.pets)),
            title: Text(a['tag']),
            subtitle: Text('${a['breed']} • ${a['gender']}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => animalDetails(a),
          ),
        );
      },
    );
  }

  Widget _healthMenu() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tile('Aşı Kaydı Ekle', Icons.vaccines, chooseAnimalForHealth),
          _tile('Sağlık Geçmişi', Icons.medical_information,
              chooseAnimalForHistory),
          _tile('Gebelik / Doğum', Icons.child_friendly,
              () => message('Üreme modülü sonraki sürümde.')),
        ],
      );

  Widget _more() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tile('Süt Takibi', Icons.local_drink,
              () => message('Yakında.')),
          _tile('Rasyon', Icons.grass,
              () => message('Yakında.')),
          _tile('Irklar', Icons.menu_book,
              () => message('Yakında.')),
          _tile('Eğitim', Icons.school,
              () => message('Yakında.')),
          _tile('Alım-Satım', Icons.storefront,
              () => message('Yakında.')),
        ],
      );

  Widget _tile(String title, IconData icon, VoidCallback onTap) => Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );

  Future<void> addAnimal() async {
    final tag = TextEditingController();
    final breed = TextEditingController();
    final birth = TextEditingController();
    String gender = 'Dişi';

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Hayvan Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                    controller: tag,
                    decoration:
                        const InputDecoration(labelText: 'Küpe numarası *')),
                TextField(
                    controller: breed,
                    decoration: const InputDecoration(labelText: 'Irk')),
                TextField(
                    controller: birth,
                    decoration:
                        const InputDecoration(labelText: 'Doğum tarihi')),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(labelText: 'Cinsiyet'),
                  items: const [
                    DropdownMenuItem(value: 'Dişi', child: Text('Dişi')),
                    DropdownMenuItem(value: 'Erkek', child: Text('Erkek')),
                  ],
                  onChanged: (v) =>
                      setDialogState(() => gender = v ?? 'Dişi'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('İptal')),
            FilledButton(
              onPressed: () async {
                if (tag.text.trim().isEmpty) return;
                try {
                  await DatabaseService.instance.addAnimal(
                    tag.text.trim(),
                    breed.text.trim().isEmpty ? 'Belirtilmedi' : breed.text.trim(),
                    gender,
                    birth.text.trim().isEmpty ? 'Belirtilmedi' : birth.text.trim(),
                  );
                  if (context.mounted) Navigator.pop(context, true);
                } catch (_) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Bu küpe numarası zaten kayıtlı.')),
                    );
                  }
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    if (saved == true) await loadAnimals();
  }

  void animalDetails(Map<String, dynamic> animal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AnimalPage(animal: animal)),
    );
  }

  Future<void> chooseAnimalForHealth() async {
    if (animals.isEmpty) {
      message('Önce hayvan ekleyin.');
      return;
    }
    final animal = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Hayvan seç'),
        children: animals
            .map((a) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, a),
                  child: Text(a['tag']),
                ))
            .toList(),
      ),
    );
    if (animal != null) addHealth(animal);
  }

  Future<void> chooseAnimalForHistory() async {
    if (animals.isEmpty) {
      message('Önce hayvan ekleyin.');
      return;
    }
    final animal = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Hayvan seç'),
        children: animals
            .map((a) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, a),
                  child: Text(a['tag']),
                ))
            .toList(),
      ),
    );
    if (animal != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HealthPage(animal: animal)),
      );
    }
  }

  Future<void> addHealth(Map<String, dynamic> animal) async {
    final name = TextEditingController();
    final date = TextEditingController();
    final note = TextEditingController();
    String type = 'Aşı';

    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('${animal['tag']} - Sağlık Kaydı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(labelText: 'Kayıt türü'),
                items: const [
                  DropdownMenuItem(value: 'Aşı', child: Text('Aşı')),
                  DropdownMenuItem(value: 'Tedavi', child: Text('Tedavi')),
                ],
                onChanged: (v) =>
                    setDialogState(() => type = v ?? 'Aşı'),
              ),
              TextField(
                  controller: name,
                  decoration:
                      const InputDecoration(labelText: 'Aşı / ilaç adı *')),
              TextField(
                  controller: date,
                  decoration: const InputDecoration(labelText: 'Tarih')),
              TextField(
                  controller: note,
                  decoration: const InputDecoration(labelText: 'Not')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('İptal')),
            FilledButton(
              onPressed: () async {
                if (name.text.trim().isEmpty) return;
                await DatabaseService.instance.addHealth(
                  animal['id'],
                  type,
                  name.text.trim(),
                  date.text.trim(),
                  note.text.trim(),
                );
                if (context.mounted) Navigator.pop(context, true);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
    if (saved == true) message('Sağlık kaydı kaydedildi.');
  }

  void message(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}

class AnimalPage extends StatelessWidget {
  final Map<String, dynamic> animal;
  const AnimalPage({super.key, required this.animal});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(animal['tag'])),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const CircleAvatar(
                radius: 45, child: Icon(Icons.pets, size: 48)),
            const SizedBox(height: 16),
            ListTile(
                title: const Text('Küpe numarası'),
                subtitle: Text(animal['tag'])),
            ListTile(
                title: const Text('Irk'),
                subtitle: Text(animal['breed'])),
            ListTile(
                title: const Text('Cinsiyet'),
                subtitle: Text(animal['gender'])),
            ListTile(
                title: const Text('Doğum tarihi'),
                subtitle: Text(animal['birthDate'])),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.vaccines),
              title: const Text('Sağlık / Aşı Geçmişi'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => HealthPage(animal: animal)),
              ),
            ),
          ],
        ),
      );
}

class HealthPage extends StatefulWidget {
  final Map<String, dynamic> animal;
  const HealthPage({super.key, required this.animal});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  List<Map<String, dynamic>> rows = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    rows = await DatabaseService.instance.health(widget.animal['id']);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('${widget.animal['tag']} - Sağlık')),
        body: rows.isEmpty
            ? const Center(child: Text('Henüz sağlık kaydı yok.'))
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: rows.length,
                itemBuilder: (_, i) {
                  final r = rows[i];
                  return Card(
                    child: ListTile(
                      leading: Icon(r['type'] == 'Aşı'
                          ? Icons.vaccines
                          : Icons.medical_services),
                      title: Text(r['name']),
                      subtitle: Text(
                          '${r['date'] ?? '-'}  ${r['note'] ?? ''}'),
                    ),
                  );
                },
              ),
      );
}
