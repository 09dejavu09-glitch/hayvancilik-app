
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const AhirApp());
}

// ============================================================
// MODELLER
// ============================================================

class Animal {
  String tag;
  String name;
  String species;
  String breed;
  String gender;
  String birth;
  String weight;
  String status;

  Animal({
    required this.tag,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.birth,
    this.weight = '',
    this.status = 'Aktif',
  });
}

class HealthRecord {
  String animalTag;
  String type;
  String title;
  String date;
  String note;

  HealthRecord({
    required this.animalTag,
    required this.type,
    required this.title,
    required this.date,
    this.note = '',
  });
}

class MilkRecord {
  String animalTag;
  String date;
  double morning;
  double evening;
  String note;

  MilkRecord({
    required this.animalTag,
    required this.date,
    required this.morning,
    required this.evening,
    this.note = '',
  });

  double get total => morning + evening;
}

class FeedItem {
  String name;
  double quantity;
  String unit;

  FeedItem({
    required this.name,
    required this.quantity,
    required this.unit,
  });
}

class ReminderItem {
  String title;
  String animalTag;
  String date;
  String note;

  ReminderItem({
    required this.title,
    required this.animalTag,
    required this.date,
    this.note = '',
  });
}

// ============================================================
// UYGULAMA
// ============================================================

class AhirApp extends StatelessWidget {
  const AhirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AHIR AI',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: const Color(0xFFF5F8F4),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF5F8F4),
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 5),
        ),
      ),
      home: const AhirHome(),
    );
  }
}

class AhirHome extends StatefulWidget {
  const AhirHome({super.key});

  @override
  State<AhirHome> createState() => _AhirHomeState();
}

class _AhirHomeState extends State<AhirHome> {
  int page = 0;

  final List<Animal> animals = [
    Animal(
      tag: 'TR 01 123456',
      name: 'Boncuk',
      species: 'Büyükbaş',
      breed: 'Simental',
      gender: 'Dişi',
      birth: '12.04.2024',
      weight: '520',
    ),
  ];

  final List<HealthRecord> healthRecords = [];
  final List<MilkRecord> milkRecords = [];
  final List<FeedItem> feeds = [
    FeedItem(name: 'Arpa', quantity: 500, unit: 'kg'),
    FeedItem(name: 'Mısır Silajı', quantity: 1200, unit: 'kg'),
    FeedItem(name: 'Yonca', quantity: 350, unit: 'kg'),
  ];
  final List<ReminderItem> reminders = [];
  bool _loaded = false;

  // Telefon kapatılıp açılsa bile kayıtların korunması için yerel depolama.
  static const _animalsKey = 'ahir_animals_v1';
  static const _healthKey = 'ahir_health_v1';
  static const _milkKey = 'ahir_milk_v1';
  static const _feedsKey = 'ahir_feeds_v1';
  static const _remindersKey = 'ahir_reminders_v1';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final savedAnimals = prefs.getString(_animalsKey);
      if (savedAnimals != null) {
        final list = jsonDecode(savedAnimals) as List;
        animals
          ..clear()
          ..addAll(
            list.map(
              (e) => Animal(
                tag: e['tag'] ?? '',
                name: e['name'] ?? '',
                species: e['species'] ?? 'Büyükbaş',
                breed: e['breed'] ?? 'Simental',
                gender: e['gender'] ?? 'Dişi',
                birth: e['birth'] ?? '',
                weight: e['weight'] ?? '',
                status: e['status'] ?? 'Aktif',
              ),
            ),
          );
      }

      final savedHealth = prefs.getString(_healthKey);
      if (savedHealth != null) {
        final list = jsonDecode(savedHealth) as List;
        healthRecords
          ..clear()
          ..addAll(
            list.map(
              (e) => HealthRecord(
                animalTag: e['animalTag'] ?? '',
                type: e['type'] ?? 'Aşı',
                title: e['title'] ?? '',
                date: e['date'] ?? '',
                note: e['note'] ?? '',
              ),
            ),
          );
      }

      final savedMilk = prefs.getString(_milkKey);
      if (savedMilk != null) {
        final list = jsonDecode(savedMilk) as List;
        milkRecords
          ..clear()
          ..addAll(
            list.map(
              (e) => MilkRecord(
                animalTag: e['animalTag'] ?? '',
                date: e['date'] ?? '',
                morning: (e['morning'] ?? 0).toDouble(),
                evening: (e['evening'] ?? 0).toDouble(),
                note: e['note'] ?? '',
              ),
            ),
          );
      }

      final savedFeeds = prefs.getString(_feedsKey);
      if (savedFeeds != null) {
        final list = jsonDecode(savedFeeds) as List;
        feeds
          ..clear()
          ..addAll(
            list.map(
              (e) => FeedItem(
                name: e['name'] ?? '',
                quantity: (e['quantity'] ?? 0).toDouble(),
                unit: e['unit'] ?? 'kg',
              ),
            ),
          );
      }

      final savedReminders = prefs.getString(_remindersKey);
      if (savedReminders != null) {
        final list = jsonDecode(savedReminders) as List;
        reminders
          ..clear()
          ..addAll(
            list.map(
              (e) => ReminderItem(
                title: e['title'] ?? '',
                animalTag: e['animalTag'] ?? '',
                date: e['date'] ?? '',
                note: e['note'] ?? '',
              ),
            ),
          );
      }
    } catch (_) {
      // Bozuk kayıt varsa uygulamanın açılmasını engelleme.
    }

    if (mounted) {
      setState(() => _loaded = true);
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _animalsKey,
      jsonEncode(
        animals
            .map(
              (a) => {
                'tag': a.tag,
                'name': a.name,
                'species': a.species,
                'breed': a.breed,
                'gender': a.gender,
                'birth': a.birth,
                'weight': a.weight,
                'status': a.status,
              },
            )
            .toList(),
      ),
    );

    await prefs.setString(
      _healthKey,
      jsonEncode(
        healthRecords
            .map(
              (r) => {
                'animalTag': r.animalTag,
                'type': r.type,
                'title': r.title,
                'date': r.date,
                'note': r.note,
              },
            )
            .toList(),
      ),
    );

    await prefs.setString(
      _milkKey,
      jsonEncode(
        milkRecords
            .map(
              (r) => {
                'animalTag': r.animalTag,
                'date': r.date,
                'morning': r.morning,
                'evening': r.evening,
                'note': r.note,
              },
            )
            .toList(),
      ),
    );

    await prefs.setString(
      _feedsKey,
      jsonEncode(
        feeds
            .map(
              (f) => {
                'name': f.name,
                'quantity': f.quantity,
                'unit': f.unit,
              },
            )
            .toList(),
      ),
    );

    await prefs.setString(
      _remindersKey,
      jsonEncode(
        reminders
            .map(
              (r) => {
                'title': r.title,
                'animalTag': r.animalTag,
                'date': r.date,
                'note': r.note,
              },
            )
            .toList(),
      ),
    );
  }


  final List<String> breeds = [
    'Simental',
    'Holstein',
    'Montofon',
    'Jersey',
    'Angus',
    'Hereford',
    'Limuzin',
    'Şarole',
    'Belçika Mavisi',
    'Yerli Kara',
    'Boz Irk',
    'Güney Anadolu Kırmızısı',
    'Akkaraman',
    'Merinos',
    'İvesi',
    'Kıvırcık',
    'Karayaka',
    'Sakız',
    'Romanov',
    'Ankara Keçisi',
  ];

  final titles = [
    'AHIR AI',
    'Hayvanlar',
    'Irklar',
    'Sağlık',
    'Süt Takibi',
    'Rasyon',
    'Raporlar',
    'Ayarlar',
    'AHIR AI',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFE1F0E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.pets, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(width: 10),
            Text(
              titles[page],
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'AHIR AI',
            onPressed: () => setState(() => page = 8),
            icon: const Icon(Icons.auto_awesome),
          ),
        ],
      ),
      body: _loaded
          ? IndexedStack(
              index: page,
        children: [
          _dashboard(),
          _animals(),
          _breeds(),
          _health(),
          _milk(),
          _ration(),
          _reports(),
          _settings(),
          const AhirAI(),
        ],
      )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: page <= 3 ? page : 0,
        onDestinationSelected: (i) => setState(() => page = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.pets_outlined),
            selectedIcon: Icon(Icons.pets),
            label: 'Hayvanlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: 'Irklar',
          ),
          NavigationDestination(
            icon: Icon(Icons.medical_services_outlined),
            selectedIcon: Icon(Icons.medical_services),
            label: 'Sağlık',
          ),
        ],
      ),
      floatingActionButton: page == 0
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => page = 8),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('AHIR AI'),
            )
          : null,
    );
  }

  // ==========================================================
  // ANA SAYFA
  // ==========================================================

  Widget _dashboard() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      children: [
        _hero(),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _miniStat(
                '${animals.length}',
                'Hayvan',
                Icons.pets,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _miniStat(
                '${healthRecords.length}',
                'Sağlık Kaydı',
                Icons.medical_services,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Çiftliğini yönet',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.28,
          children: [
            _tile('Hayvanlar', Icons.pets, 1),
            _tile('Sağlık', Icons.medical_services, 3),
            _tile('Süt', Icons.local_drink, 4),
            _tile('Rasyon', Icons.grass, 5),
            _tile('Raporlar', Icons.bar_chart, 6),
            _tile('AHIR AI', Icons.auto_awesome, 8),
          ],
        ),
        const SizedBox(height: 18),
        _sectionTitle('Bugünün özeti'),
        _summaryTile(
          Icons.vaccines,
          'Aşı / Sağlık',
          healthRecords.isEmpty
              ? 'Henüz sağlık kaydı yok'
              : '${healthRecords.length} sağlık kaydı bulunuyor',
          3,
        ),
        _summaryTile(
          Icons.local_drink,
          'Süt Takibi',
          milkRecords.isEmpty
              ? 'Henüz süt kaydı yok'
              : '${milkRecords.length} süt kaydı bulunuyor',
          4,
        ),
        _summaryTile(
          Icons.notifications_active,
          'Hatırlatmalar',
          reminders.isEmpty
              ? 'Henüz hatırlatma yok'
              : '${reminders.length} hatırlatma bulunuyor',
          6,
        ),
      ],
    );
  }

  Widget _hero() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AHIR AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Akıllı Hayvancılık Yönetimi',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                SizedBox(height: 15),
                Text(
                  'Çiftliğin cebindeki yardımcısı.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          const FarmCharacter(type: CharacterType.cow, size: 95),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE1F0E2),
              child: Icon(icon, color: const Color(0xFF2E7D32)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(label),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile(String title, IconData icon, int target) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => setState(() => page = target),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFE1F0E2),
              child: Icon(icon, color: const Color(0xFF2E7D32)),
            ),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile(
    IconData icon,
    String title,
    String subtitle,
    int target,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE1F0E2),
          child: Icon(icon, color: const Color(0xFF2E7D32)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => setState(() => page = target),
      ),
    );
  }

  Widget _sectionTitle(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          s,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      );

  // ==========================================================
  // HAYVANLAR
  // ==========================================================

  Widget _animals() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
            ),
            onPressed: _addAnimal,
            icon: const Icon(Icons.add),
            label: const Text('Yeni Hayvan Ekle'),
          ),
        ),
        Expanded(
          child: animals.isEmpty
              ? _emptyState(
                  Icons.pets,
                  'Henüz hayvan yok',
                  'Yeni Hayvan Ekle butonundan ilk hayvanını kaydet.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: animals.length,
                  itemBuilder: (_, i) {
                    final a = animals[i];
                    return Card(
                      child: ListTile(
                        leading: FarmCharacter(
                          type: _characterFor(a.species),
                          size: 54,
                        ),
                        title: Text(
                          a.tag,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        subtitle: Text(
                          '${a.name.isEmpty ? 'İsimsiz' : a.name} • ${a.breed} • ${a.gender}'
                          '${a.weight.isEmpty ? '' : ' • ${a.weight} kg'}',
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (v) {
                            if (v == 'detail') _animalDetail(a);
                            if (v == 'health') {
                              setState(() => page = 3);
                              _addHealthRecord(initialAnimal: a.tag);
                            }
                            if (v == 'milk') {
                              setState(() => page = 4);
                              _addMilkRecord(initialAnimal: a.tag);
                            }
                            if (v == 'delete') {
                              setState(() => animals.removeAt(i));
                              _saveData();
                            }
                          },
                          itemBuilder: (_) => const [
                            PopupMenuItem(
                              value: 'detail',
                              child: Text('Detay'),
                            ),
                            PopupMenuItem(
                              value: 'health',
                              child: Text('Sağlık Kaydı'),
                            ),
                            PopupMenuItem(
                              value: 'milk',
                              child: Text('Süt Kaydı'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Sil'),
                            ),
                          ],
                        ),
                        onTap: () => _animalDetail(a),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _addAnimal() {
    final tag = TextEditingController();
    final name = TextEditingController();
    final birth = TextEditingController();
    final weight = TextEditingController();

    String species = 'Büyükbaş';
    String gender = 'Dişi';
    String breed = breeds.first;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Yeni Hayvan'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: tag,
                  decoration: const InputDecoration(
                    labelText: 'Küpe No *',
                    prefixIcon: Icon(Icons.confirmation_number),
                  ),
                ),
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Hayvan Adı',
                    prefixIcon: Icon(Icons.pets),
                  ),
                ),
                TextField(
                  controller: birth,
                  decoration: const InputDecoration(
                    labelText: 'Doğum tarihi',
                    hintText: 'GG.AA.YYYY',
                  ),
                ),
                TextField(
                  controller: weight,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Canlı ağırlık (kg)',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: species,
                  decoration: const InputDecoration(labelText: 'Tür'),
                  items: const [
                    'Büyükbaş',
                    'Koyun',
                    'Keçi',
                  ]
                      .map(
                        (x) => DropdownMenuItem(
                          value: x,
                          child: Text(x),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setD(() => species = v!),
                ),
                DropdownButtonFormField<String>(
                  value: breed,
                  decoration: const InputDecoration(labelText: 'Irk'),
                  items: breeds
                      .map(
                        (x) => DropdownMenuItem(
                          value: x,
                          child: Text(x),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setD(() => breed = v!),
                ),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(labelText: 'Cinsiyet'),
                  items: const [
                    'Dişi',
                    'Erkek',
                  ]
                      .map(
                        (x) => DropdownMenuItem(
                          value: x,
                          child: Text(x),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setD(() => gender = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            FilledButton.icon(
              onPressed: () {
                if (tag.text.trim().isEmpty) {
                  _snack('Küpe numarası boş bırakılamaz.');
                  return;
                }

                setState(
                  () => animals.add(
                    Animal(
                      tag: tag.text.trim(),
                      name: name.text.trim(),
                      species: species,
                      breed: breed,
                      gender: gender,
                      birth: birth.text.trim(),
                      weight: weight.text.trim(),
                    ),
                  ),
                );
                _saveData();

                Navigator.pop(ctx);
                _snack('Hayvan başarıyla eklendi.');
              },
              icon: const Icon(Icons.save),
              label: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _animalDetail(Animal a) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                FarmCharacter(
                  type: _characterFor(a.species),
                  size: 76,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    a.tag,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _infoRow('Adı', a.name.isEmpty ? '-' : a.name),
            _infoRow('Tür', a.species),
            _infoRow('Irk', a.breed),
            _infoRow('Cinsiyet', a.gender),
            _infoRow('Doğum', a.birth.isEmpty ? '-' : a.birth),
            _infoRow('Ağırlık', a.weight.isEmpty ? '-' : '${a.weight} kg'),
            const Divider(height: 30),
            ListTile(
              leading: const Icon(Icons.vaccines),
              title: const Text('Sağlık geçmişi'),
              subtitle: Text(
                '${healthRecords.where((x) => x.animalTag == a.tag).length} kayıt',
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() => page = 3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_drink),
              title: const Text('Süt kayıtları'),
              subtitle: Text(
                '${milkRecords.where((x) => x.animalTag == a.tag).length} kayıt',
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() => page = 4);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  CharacterType _characterFor(String species) {
    if (species == 'Koyun') return CharacterType.sheep;
    if (species == 'Keçi') return CharacterType.goat;
    return CharacterType.cow;
  }

  // ==========================================================
  // IRKLAR
  // ==========================================================

  Widget _breeds() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const Text(
          'Irk Kataloğu',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Bir ırka dokunarak kısa bilgi kartını açabilirsin.',
        ),
        const SizedBox(height: 10),
        _breedGroup(
          'Büyükbaş',
          CharacterType.cow,
          [
            'Simental',
            'Holstein',
            'Montofon',
            'Jersey',
            'Angus',
            'Hereford',
            'Limuzin',
            'Şarole',
            'Belçika Mavisi',
            'Yerli Kara',
            'Boz Irk',
          ],
        ),
        _breedGroup(
          'Koyun',
          CharacterType.sheep,
          [
            'Akkaraman',
            'Merinos',
            'İvesi',
            'Kıvırcık',
            'Karayaka',
            'Sakız',
            'Romanov',
          ],
        ),
        _breedGroup(
          'Keçi',
          CharacterType.goat,
          ['Ankara Keçisi'],
        ),
      ],
    );
  }

  Widget _breedGroup(
    String title,
    CharacterType type,
    List<String> names,
  ) {
    return Card(
      child: ExpansionTile(
        leading: FarmCharacter(type: type, size: 52),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text('${names.length} ırk'),
        children: names
            .map(
              (b) => ListTile(
                leading: const Icon(Icons.pets),
                title: Text(b),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _breedDetail(b),
              ),
            )
            .toList(),
      ),
    );
  }

  void _breedDetail(String breed) {
    final info = <String, String>{
      'Simental':
          'Et ve süt yönlü kombine bir sığır ırkıdır. Yetiştirme ve besleme koşulları performansı önemli ölçüde etkiler.',
      'Holstein':
          'Süt yönü güçlü bir sığır ırkıdır. Dengeli besleme ve uygun kaba yem yönetimi önemlidir.',
      'Jersey':
          'Küçük yapılı bir sütçü sığır ırkıdır. Süt yağ oranı ile öne çıkabilir.',
      'Akkaraman':
          'Türkiye’de yaygın koyun ırklarındandır. Dayanıklılığı ve mera koşullarına uyumu ile bilinir.',
      'Merinos':
          'Yapağı ve yetiştirme yönüyle bilinen koyun grubudur.',
      'İvesi':
          'Süt yönü öne çıkan koyun ırklarındandır.',
      'Kıvırcık':
          'Et kalitesi ile öne çıkan yerli koyun ırklarındandır.',
      'Ankara Keçisi':
          'Tiftik üretimiyle tanınan keçi ırkıdır.',
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(breed),
        content: Text(
          '${info[breed] ?? 'Bu ırk için temel yetiştirme bilgileri AHIR AI ile ayrıca değerlendirilebilir.'}\n\n'
          'Daha ayrıntılı bilgi için AHIR AI bölümüne “$breed özellikleri” yazabilirsin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => page = 8);
            },
            child: const Text('AHIR AI\'ya Sor'),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SAĞLIK
  // ==========================================================

  Widget _health() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
      children: [
        _actionCard(
          'Aşı Kayıtları',
          Icons.vaccines,
          'Aşı adı, hayvan ve tarihi kaydet.',
          () => _addHealthRecord(type: 'Aşı'),
        ),
        _actionCard(
          'Hastalık / Tedavi',
          Icons.healing,
          'Hastalık ve tedavi geçmişini tut.',
          () => _addHealthRecord(type: 'Tedavi'),
        ),
        _actionCard(
          'İlaçlar',
          Icons.medication,
          'Kullanılan ilaçları kayıt altına al.',
          () => _addHealthRecord(type: 'İlaç'),
        ),
        _actionCard(
          'Hatırlatmalar',
          Icons.notifications_active,
          'Aşı, kontrol ve diğer işlemler için tarih oluştur.',
          _addReminder,
        ),
        const SizedBox(height: 12),
        _sectionTitle('Kayıtlar'),
        if (healthRecords.isEmpty)
          _emptyState(
            Icons.medical_services,
            'Sağlık kaydı yok',
            'Yukarıdaki butonlardan kayıt ekleyebilirsin.',
          )
        else
          ...healthRecords.reversed.map(
            (r) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE1F0E2),
                  child: Icon(
                    r.type == 'Aşı'
                        ? Icons.vaccines
                        : r.type == 'İlaç'
                            ? Icons.medication
                            : Icons.healing,
                    color: const Color(0xFF2E7D32),
                  ),
                ),
                title: Text(
                  r.title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  '${r.type} • ${r.animalTag} • ${r.date}'
                  '${r.note.isEmpty ? '' : '\n${r.note}'}',
                ),
                isThreeLine: r.note.isNotEmpty,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() => healthRecords.remove(r));
                    _saveData();
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _addHealthRecord({
    String? type,
    String? initialAnimal,
  }) {
    final title = TextEditingController();
    final date = TextEditingController(text: _today());
    final note = TextEditingController();

    String selectedType = type ?? 'Aşı';
    String animalTag =
        initialAnimal ?? (animals.isNotEmpty ? animals.first.tag : '');

    if (animals.isEmpty) {
      _snack('Önce en az bir hayvan eklemelisin.');
      return;
    }

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: Text('$selectedType Kaydı'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: animalTag,
                  decoration: const InputDecoration(
                    labelText: 'Hayvan',
                  ),
                  items: animals
                      .map(
                        (a) => DropdownMenuItem(
                          value: a.tag,
                          child: Text(a.tag),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setD(() => animalTag = v!),
                ),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Kayıt türü'),
                  items: const [
                    'Aşı',
                    'Tedavi',
                    'İlaç',
                  ]
                      .map(
                        (x) => DropdownMenuItem(
                          value: x,
                          child: Text(x),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setD(() => selectedType = v!),
                ),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Başlık / Aşı veya ilaç adı',
                  ),
                ),
                TextField(
                  controller: date,
                  decoration: const InputDecoration(
                    labelText: 'Tarih',
                    hintText: 'GG.AA.YYYY',
                  ),
                ),
                TextField(
                  controller: note,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Not',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () {
                if (title.text.trim().isEmpty) {
                  _snack('Başlık boş bırakılamaz.');
                  return;
                }

                setState(
                  () => healthRecords.add(
                    HealthRecord(
                      animalTag: animalTag,
                      type: selectedType,
                      title: title.text.trim(),
                      date: date.text.trim(),
                      note: note.text.trim(),
                    ),
                  ),
                );
                _saveData();
                Navigator.pop(ctx);
                _snack('Sağlık kaydı eklendi.');
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _addReminder() {
    final title = TextEditingController();
    final date = TextEditingController(text: _today());
    final note = TextEditingController();

    String animalTag =
        animals.isEmpty ? '' : animals.first.tag;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Yeni Hatırlatma'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Hatırlatma başlığı',
                  ),
                ),
                if (animals.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: animalTag,
                    decoration: const InputDecoration(
                      labelText: 'Hayvan',
                    ),
                    items: animals
                        .map(
                          (a) => DropdownMenuItem(
                            value: a.tag,
                            child: Text(a.tag),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setD(() => animalTag = v!),
                  ),
                TextField(
                  controller: date,
                  decoration: const InputDecoration(
                    labelText: 'Tarih',
                  ),
                ),
                TextField(
                  controller: note,
                  decoration: const InputDecoration(
                    labelText: 'Not',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () {
                if (title.text.trim().isEmpty) {
                  _snack('Başlık yazmalısın.');
                  return;
                }
                setState(
                  () => reminders.add(
                    ReminderItem(
                      title: title.text.trim(),
                      animalTag: animalTag,
                      date: date.text.trim(),
                      note: note.text.trim(),
                    ),
                  ),
                );
                _saveData();
                Navigator.pop(ctx);
                _snack('Hatırlatma eklendi.');
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SÜT TAKİBİ
  // ==========================================================

  Widget _milk() {
    double total = 0;
    for (final r in milkRecords) {
      total += r.total;
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Color(0xFFE1F0E2),
                  child: Icon(
                    Icons.local_drink,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Toplam kayıtlı süt',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${total.toStringAsFixed(1)} L',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _actionCard(
          'Süt Kaydı Ekle',
          Icons.add,
          'Hayvan bazında sabah ve akşam sütünü kaydet.',
          _addMilkRecord,
        ),
        _actionCard(
          'Sağım Takvimi',
          Icons.calendar_month,
          'Sağım düzenini ve hatırlatmalarını yönet.',
          () => _showSimpleInfo(
            'Sağım Takvimi',
            'Sağım saatlerini hatırlatma olarak eklemek için Sağlık > Hatırlatmalar bölümünü de kullanabilirsin.',
          ),
        ),
        const SizedBox(height: 12),
        _sectionTitle('Süt Kayıtları'),
        if (milkRecords.isEmpty)
          _emptyState(
            Icons.local_drink,
            'Süt kaydı yok',
            'İlk süt kaydını ekleyerek takibe başla.',
          )
        else
          ...milkRecords.reversed.map(
            (r) => Card(
              child: ListTile(
                leading: const Icon(Icons.local_drink),
                title: Text(
                  '${r.total.toStringAsFixed(1)} L',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                subtitle: Text(
                  '${r.animalTag} • ${r.date}\n'
                  'Sabah: ${r.morning.toStringAsFixed(1)} L  '
                  'Akşam: ${r.evening.toStringAsFixed(1)} L'
                  '${r.note.isEmpty ? '' : '\n${r.note}'}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() => milkRecords.remove(r));
                    _saveData();
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _addMilkRecord({String? initialAnimal}) {
    if (animals.isEmpty) {
      _snack('Önce hayvan eklemelisin.');
      return;
    }

    final morning = TextEditingController();
    final evening = TextEditingController();
    final date = TextEditingController(text: _today());
    final note = TextEditingController();

    String animalTag =
        initialAnimal ?? animals.first.tag;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Süt Kaydı Ekle'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: animalTag,
                  decoration: const InputDecoration(
                    labelText: 'Hayvan',
                  ),
                  items: animals
                      .map(
                        (a) => DropdownMenuItem(
                          value: a.tag,
                          child: Text(a.tag),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setD(() => animalTag = v!),
                ),
                TextField(
                  controller: morning,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Sabah (L)',
                  ),
                ),
                TextField(
                  controller: evening,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Akşam (L)',
                  ),
                ),
                TextField(
                  controller: date,
                  decoration: const InputDecoration(
                    labelText: 'Tarih',
                  ),
                ),
                TextField(
                  controller: note,
                  decoration: const InputDecoration(
                    labelText: 'Not',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () {
                final m = double.tryParse(
                  morning.text.replaceAll(',', '.'),
                );
                final e = double.tryParse(
                  evening.text.replaceAll(',', '.'),
                );

                if (m == null || e == null) {
                  _snack('Sabah ve akşam süt miktarını sayı olarak gir.');
                  return;
                }

                setState(
                  () => milkRecords.add(
                    MilkRecord(
                      animalTag: animalTag,
                      date: date.text.trim(),
                      morning: m,
                      evening: e,
                      note: note.text.trim(),
                    ),
                  ),
                );
                _saveData();
                Navigator.pop(ctx);
                _snack('Süt kaydı eklendi.');
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // RASYON
  // ==========================================================

  Widget _ration() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFFE1F0E2),
                      child: Icon(
                        Icons.calculate,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Rasyon Hesaplama',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Hayvan bilgilerini girerek yaklaşık kuru madde ihtiyacını ve örnek yem dağılımını inceleyebilirsin.',
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _calculateRation,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Rasyon Hesapla'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        _actionCard(
          'Yemler',
          Icons.grass,
          'Yem türlerini ve mevcut stokları yönet.',
          _addFeed,
        ),
        _actionCard(
          'Yem Stoku',
          Icons.inventory_2,
          'Giriş, tüketim ve kalan miktarları gör.',
          _feedStock,
        ),
      ],
    );
  }

  void _calculateRation() {
    final weight = TextEditingController();
    final milk = TextEditingController();
    String purpose = 'Besi';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Rasyon Hesapla'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: weight,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Canlı ağırlık (kg)',
                    hintText: 'Örn. 600',
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: purpose,
                  decoration: const InputDecoration(
                    labelText: 'Üretim durumu',
                  ),
                  items: const [
                    'Besi',
                    'Süt',
                    'Kuru dönem',
                    'Büyüme',
                  ]
                      .map(
                        (x) => DropdownMenuItem(
                          value: x,
                          child: Text(x),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setD(() => purpose = v!),
                ),
                if (purpose == 'Süt')
                  TextField(
                    controller: milk,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Günlük süt (L)',
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () {
                final kg = double.tryParse(
                  weight.text.replaceAll(',', '.'),
                );

                if (kg == null || kg <= 0) {
                  _snack('Geçerli bir canlı ağırlık gir.');
                  return;
                }

                final low = kg * 0.02;
                final high = kg * 0.03;

                Navigator.pop(ctx);

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Ön Rasyon Sonucu'),
                    content: Text(
                      'Canlı ağırlık: ${kg.toStringAsFixed(0)} kg\n'
                      'Amaç: $purpose\n\n'
                      'Tahmini toplam kuru madde ihtiyacı: '
                      '${low.toStringAsFixed(1)}–${high.toStringAsFixed(1)} kg/gün.\n\n'
                      'Bu sonuç ön hesaplamadır. Yemlerin kuru madde oranı, '
                      'hayvanın kondisyonu, kaba yem kalitesi, yaş, üretim '
                      'seviyesi ve diğer bilgiler bilinmeden kesin yem reçetesi '
                      'olarak kullanılmamalıdır.\n\n'
                      'Kullandığın yemleri yazarsan AHIR AI bölümünde örnek '
                      'bir karışım üzerinden değerlendirebilirsin.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tamam'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Hesapla'),
            ),
          ],
        ),
      ),
    );
  }

  void _addFeed() {
    final name = TextEditingController();
    final quantity = TextEditingController();
    String unit = 'kg';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('Yem Stok Kaydı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(
                  labelText: 'Yem adı',
                ),
              ),
              TextField(
                controller: quantity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Miktar',
                ),
              ),
              DropdownButtonFormField<String>(
                value: unit,
                decoration: const InputDecoration(labelText: 'Birim'),
                items: const ['kg', 'ton', 'çuval', 'adet']
                    .map(
                      (x) => DropdownMenuItem(
                        value: x,
                        child: Text(x),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setD(() => unit = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () {
                final q = double.tryParse(
                  quantity.text.replaceAll(',', '.'),
                );
                if (name.text.trim().isEmpty || q == null) {
                  _snack('Yem adı ve geçerli miktar gir.');
                  return;
                }
                setState(
                  () => feeds.add(
                    FeedItem(
                      name: name.text.trim(),
                      quantity: q,
                      unit: unit,
                    ),
                  ),
                );
                _saveData();
                Navigator.pop(ctx);
                _snack('Yem stoğu eklendi.');
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }

  void _feedStock() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => ListView(
        padding: const EdgeInsets.all(18),
        shrinkWrap: true,
        children: [
          const Text(
            'Yem Stoku',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ...feeds.map(
            (f) => Card(
              child: ListTile(
                leading: const Icon(Icons.grass),
                title: Text(
                  f.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  '${f.quantity.toStringAsFixed(1)} ${f.unit}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() => feeds.remove(f));
                    _saveData();
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // RAPORLAR
  // ==========================================================

  Widget _reports() {
    final totalMilk =
        milkRecords.fold<double>(0, (sum, item) => sum + item.total);

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
      children: [
        _reportCard(
          'Sürü Raporu',
          Icons.pets,
          '${animals.length} hayvan kayıtlı',
          () => _showReport(
            'Sürü Raporu',
            'Toplam hayvan: ${animals.length}\n\n'
            '${_countSpecies('Büyükbaş')} büyükbaş\n'
            '${_countSpecies('Koyun')} koyun\n'
            '${_countSpecies('Keçi')} keçi',
          ),
        ),
        _reportCard(
          'Sağlık Raporu',
          Icons.medical_services,
          '${healthRecords.length} sağlık kaydı',
          () => _showReport(
            'Sağlık Raporu',
            'Toplam sağlık kaydı: ${healthRecords.length}\n'
            'Aşı: ${healthRecords.where((x) => x.type == 'Aşı').length}\n'
            'Tedavi: ${healthRecords.where((x) => x.type == 'Tedavi').length}\n'
            'İlaç: ${healthRecords.where((x) => x.type == 'İlaç').length}',
          ),
        ),
        _reportCard(
          'Süt Raporu',
          Icons.local_drink,
          '${totalMilk.toStringAsFixed(1)} L kayıtlı',
          () => _showReport(
            'Süt Raporu',
            'Toplam kayıtlı süt: ${totalMilk.toStringAsFixed(1)} L\n'
            'Kayıt sayısı: ${milkRecords.length}\n\n'
            'Süt takibini düzenli yaptıkça dönemsel değişimleri '
            'daha sağlıklı değerlendirebilirsin.',
          ),
        ),
        _reportCard(
          'Hatırlatmalar',
          Icons.notifications_active,
          '${reminders.length} kayıt',
          () => _showReport(
            'Hatırlatmalar',
            reminders.isEmpty
                ? 'Henüz hatırlatma bulunmuyor.'
                : reminders
                    .map(
                      (r) =>
                          '• ${r.title} — ${r.date} — ${r.animalTag}',
                    )
                    .join('\n'),
          ),
        ),
      ],
    );
  }

  int _countSpecies(String species) =>
      animals.where((a) => a.species == species).length;

  Widget _reportCard(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE1F0E2),
          child: Icon(icon, color: const Color(0xFF2E7D32)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _showReport(String title, String text) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // AYARLAR
  // ==========================================================

  Widget _settings() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 30),
      children: [
        _actionCard(
          'İşletme Bilgileri',
          Icons.business,
          'İşletme adı ve temel bilgileri düzenle.',
          _businessInfo,
        ),
        _actionCard(
          'Bildirimler',
          Icons.notifications,
          'Hatırlatma kayıtlarını görüntüle.',
          () => setState(() => page = 3),
        ),
        _actionCard(
          'Yedekleme',
          Icons.backup,
          'Verileri yedekleme özelliği sonraki teknik aşamada cihaz depolamasına bağlanacak.',
          () => _showSimpleInfo(
            'Yedekleme',
            'Şu anda kayıtlar uygulama oturumu boyunca tutuluyor. '
            'Kalıcı cihaz depolaması için sonraki aşamada yerel veritabanı ekleyebiliriz.',
          ),
        ),
        _actionCard(
          'AHIR Hakkında',
          Icons.info_outline,
          'AHIR Akıllı Hayvancılık Yönetimi',
          () => _showSimpleInfo(
            'AHIR AI',
            'Hayvan, sağlık, süt, yem, rasyon ve çiftlik yönetimini tek uygulamada toplamayı amaçlayan AHIR AI.',
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: ListTile(
            leading: const Icon(Icons.auto_awesome),
            title: const Text(
              'AHIR AI',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            subtitle: const Text('Akıllı hayvancılık yardımcısını aç'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => setState(() => page = 8),
          ),
        ),
      ],
    );
  }

  void _businessInfo() {
    final controller = TextEditingController(text: 'AHIR İşletmem');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('İşletme Bilgileri'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'İşletme adı',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _snack('İşletme bilgisi kaydedildi.');
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ORTAK WIDGETLAR
  // ==========================================================

  Widget _actionCard(
    String title,
    IconData icon,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE1F0E2),
          child: Icon(icon, color: const Color(0xFF2E7D32)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _emptyState(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(
              icon,
              size: 52,
              color: const Color(0xFF2E7D32),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _today() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(now.day)}.${two(now.month)}.${now.year}';
  }

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _showSimpleInfo(String title, String text) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// AHIR AI
// ============================================================

class AhirAI extends StatefulWidget {
  const AhirAI({super.key});

  @override
  State<AhirAI> createState() => _AhirAIState();
}

class _AhirAIState extends State<AhirAI> {
  final input = TextEditingController();
  final scroll = ScrollController();
  bool sending = false;

  final messages = <Map<String, String>>[
    {
      'role': 'ai',
      'text':
          'Merhaba! Ben AHIR AI 🤖🐄\n\n'
          'Bana hayvanın türünü, ırkını, yaşını, kilosunu ve '
          'üretim durumunu yaz. Rasyon, sağlık, süt, aşı ve bakım '
          'konularında daha hedefli yardımcı olayım.\n\n'
          'Örnek: “600 kg, 3 yaşında erkek Simental için rasyon.”'
    }
  ];

  @override
  void dispose() {
    input.dispose();
    scroll.dispose();
    super.dispose();
  }

  void ask() {
    final q = input.text.trim();
    if (q.isEmpty || sending) return;

    setState(() {
      sending = true;
      messages.add({'role': 'user', 'text': q});
      input.clear();
    });

    Future.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;

      setState(() {
        messages.add({
          'role': 'ai',
          'text': _answer(q),
        });
        sending = false;
      });

      Future.delayed(const Duration(milliseconds: 60), () {
        if (scroll.hasClients) {
          scroll.animateTo(
            scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  String _answer(String q) {
    final l = q.toLowerCase();

    final weight = _numberBeforeUnit(l, ['kg', 'kilo']);
    final age = _numberBeforeUnit(l, ['yaş', 'yas']);
    final milk = _numberBeforeUnit(l, ['litre', 'lt']);

    String species = 'Bilinmiyor';
    if (_hasAny(l, [
      'simental',
      'simmental',
      'holstein',
      'inek',
      'sığır',
      'dana',
      'buzağı',
      'tosun'
    ])) {
      species = 'Büyükbaş';
    } else if (_hasAny(l, [
      'koyun',
      'kuzu',
      'koç',
      'akkaraman',
      'merinos',
      'ivesi'
    ])) {
      species = 'Koyun';
    } else if (_hasAny(l, [
      'keçi',
      'oğlak',
      'teke',
      'ankara keçisi'
    ])) {
      species = 'Keçi';
    }

    final breed = _findBreed(l);

    if (_hasAny(l, [
      'rasyon',
      'yem',
      'besleme',
      'yemleme',
      'silaj',
      'kuru madde'
    ])) {
      if (weight == null) {
        return '🌾 Rasyon hazırlayabiliriz.\n\n'
            'Şu an hayvanın canlı ağırlığı eksik.\n'
            'Örneğin: “3 yaşında erkek Simental, 600 kg, besi” yaz.\n\n'
            'Kilo bilgisi olmadan sadece genel öneri verebilirim; '
            'kesin yem miktarı söylemek doğru olmaz.';
      }

      final low = weight * .02;
      final high = weight * .03;

      return '🌾 Ön rasyon değerlendirmesi\n\n'
          'Tür: $species\n'
          'Irk: ${breed == 'Bilinmiyor' ? 'Belirtilmedi' : breed}\n'
          '${age == null ? '' : 'Yaş: ${age.toStringAsFixed(1)} yıl\n'}'
          'Canlı ağırlık: ${weight.toStringAsFixed(0)} kg\n\n'
          'Tahmini toplam kuru madde aralığı: '
          '${low.toStringAsFixed(1)}–${high.toStringAsFixed(1)} kg/gün.\n\n'
          'Bu bir ön hesaplamadır. Hayvanın amacı, kondisyonu, '
          'kaba yem kalitesi, yemlerin kuru madde oranı ve üretim '
          'durumu bilinmeden kesin rasyon reçetesi oluşturulamaz.\n\n'
          'Kullandığın yemleri yazarsan (arpa, mısır silajı, yonca, '
          'saman, fabrika yemi vb.) örnek bir karışım üzerinden '
          'daha ayrıntılı değerlendirebiliriz.';
    }

    if (_hasAny(l, [
      'hasta',
      'hastalık',
      'tedavi',
      'ishal',
      'öksür',
      'ateş',
      'topall',
      'yem yemiyor',
      'iştah',
      'şişkin'
    ])) {
      return '🩺 Sağlık değerlendirmesi\n\n'
          '${species == 'Bilinmiyor' ? 'Hayvanın' : '$species hayvanın'} '
          'belirtisini değerlendirebilmem için şu bilgileri yaz:\n\n'
          '• Yaş ve yaklaşık kilo\n'
          '• Belirti ne zamandır var?\n'
          '• Ateş ölçüldü mü?\n'
          '• Su ve yem tüketimi nasıl?\n'
          '• Dışkı/idrarda değişiklik var mı?\n'
          '• Son aşı veya ilaç ne zaman yapıldı?\n\n'
          'Şiddetli nefes darlığı, ciddi kanama, bayılma veya ani '
          'kötüleşme varsa veteriner hekim değerlendirmesi geciktirilmemeli.';
    }

    if (_hasAny(l, ['aşı', 'aşılama', 'rapel', 'kuduz', 'şap', 'brusella'])) {
      return '💉 Aşı takibi\n\n'
          'Aşı programı hayvanın türüne, yaşına, yetiştirme şekline, '
          'bölgeye ve güncel resmi/veteriner hekim programına göre '
          'değişebilir.\n\n'
          'AHIR içinde aşı adı + hayvan/küpe + uygulama tarihi + '
          'sonraki tarih şeklinde kayıt tutabiliriz.\n\n'
          'İstersen “6 aylık buzağı için aşı takibi” gibi daha '
          'spesifik sor.';
    }

    if (_hasAny(l, ['süt', 'sağım', 'litre'])) {
      if (milk != null) {
        return '🥛 Günlük süt miktarını ${milk.toStringAsFixed(1)} L '
            'olarak belirttin.\n\n'
            'Tek günlük değer yerine birkaç haftalık trendi izlemek '
            'daha anlamlıdır. Yem değişikliği, sağlık durumu, laktasyon '
            'dönemi ve sağım düzeni de birlikte değerlendirilmelidir.\n\n'
            'İstersen hayvanın ırkı, kilosu ve günlük yemini de yaz.';
      }

      return '🥛 Süt takibi için günlük sabah + akşam miktarını '
          'kaydetmek en pratik yöntemlerden biri.\n\n'
          'Örnek: “Simental, 650 kg, günde 24 litre.”\n\n'
          'Böylece zaman içindeki düşüş veya yükselişleri takip '
          'edebilirsin.';
    }

    if (breed != 'Bilinmiyor') {
      return '🐾 $breed\n\n'
          '${_breedText(breed)}\n\n'
          'İstersen “$breed için rasyon”, “$breed süt verimi” '
          'veya “$breed sağlık” şeklinde devam edebilirsin.';
    }

    if (_hasAny(l, ['merhaba', 'selam', 'ne yapabilirsin'])) {
      return 'Merhaba! 🤖🐄\n\n'
          'Ben AHIR AI. Şunlarda yardımcı olabilirim:\n\n'
          '🌾 Rasyon ve yemleme\n'
          '🩺 Sağlık konusunda ilk değerlendirme\n'
          '💉 Aşı takibi\n'
          '🥛 Süt takibi\n'
          '🐄 Irk bilgileri\n'
          '📋 Çiftlik kayıtları\n\n'
          'Sorunu doğrudan yazabilirsin.';
    }

    return 'Sorunu daha iyi anlayabilmem için hayvanın türü, '
        'yaşı, kilosu ve ne yapmak istediğini yaz.\n\n'
        'Örnek:\n'
        '“3 yaşında 600 kg erkek Simental, besi döneminde. '
        'Günlük yemini nasıl planlayabilirim?”';
  }

  String _findBreed(String l) {
    final map = {
      'simental': 'Simental',
      'simmental': 'Simental',
      'holstein': 'Holstein',
      'montofon': 'Montofon',
      'jersey': 'Jersey',
      'angus': 'Angus',
      'hereford': 'Hereford',
      'limuzin': 'Limuzin',
      'şarole': 'Şarole',
      'akkaraman': 'Akkaraman',
      'merinos': 'Merinos',
      'ivesi': 'İvesi',
      'kıvırcık': 'Kıvırcık',
      'karayaka': 'Karayaka',
      'sakız': 'Sakız',
      'romanov': 'Romanov',
      'ankara keçisi': 'Ankara Keçisi',
    };

    for (final e in map.entries) {
      if (l.contains(e.key)) return e.value;
    }

    return 'Bilinmiyor';
  }

  String _breedText(String breed) {
    const map = {
      'Simental':
          'Et ve süt yönlü kombine bir sığır ırkıdır. Performans; genetik, yemleme, bakım ve işletme koşullarına göre değişir.',
      'Holstein':
          'Süt yönü güçlü bir sığır ırkıdır. Enerji, protein, mineral ve kaba yem dengesi önemlidir.',
      'Jersey':
          'Küçük yapılı sütçü bir sığır ırkıdır ve süt yağ oranıyla öne çıkabilir.',
      'Akkaraman':
          'Türkiye’de yaygın koyun ırklarındandır ve farklı mera koşullarına uyumuyla bilinir.',
      'Merinos':
          'Yapağı ve yetiştirme yönleriyle bilinen koyun grubudur.',
      'İvesi':
          'Süt yönü öne çıkan koyun ırklarındandır.',
      'Kıvırcık':
          'Et kalitesi ile öne çıkan yerli koyun ırklarındandır.',
      'Ankara Keçisi':
          'Tiftik üretimiyle tanınan bir keçi ırkıdır.',
    };

    return map[breed] ??
        'Bu ırk hakkında temel yetiştirme ve verim bilgilerini inceleyebiliriz.';
  }

  double? _numberBeforeUnit(String text, List<String> units) {
    for (final unit in units) {
      final m = RegExp(
        r'(\d+(?:[.,]\d+)?)\s*' + RegExp.escape(unit),
      ).firstMatch(text);

      if (m != null) {
        return double.tryParse(
          m.group(1)!.replaceAll(',', '.'),
        );
      }
    }
    return null;
  }

  bool _hasAny(String text, List<String> values) =>
      values.any(text.contains);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF263238), Color(0xFF455A64)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 34,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AHIR AI\nÇiftliğin akıllı yardımcısı',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 46,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            children: [
              _chip(
                '🌾 Rasyon',
                '600 kg Simental erkek için rasyon',
              ),
              _chip(
                '🐄 Simental',
                'Simental özellikleri',
              ),
              _chip(
                '💉 Aşı',
                'Büyükbaş aşı takibi',
              ),
              _chip(
                '🥛 Süt',
                'Süt verimi nasıl takip edilir?',
              ),
              _chip(
                '🩺 Sağlık',
                'Hayvanım yem yemiyor, ne yapmalıyım?',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            itemCount: messages.length,
            itemBuilder: (_, i) {
              final m = messages[i];
              final ai = m['role'] == 'ai';

              return Align(
                alignment:
                    ai ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 355),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ai
                        ? Colors.white
                        : const Color(0xFFE1F0E2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    m['text']!,
                    style: const TextStyle(
                      fontSize: 15.5,
                      height: 1.35,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (sending)
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 8),
                Text('AHIR AI düşünüyor...'),
              ],
            ),
          ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: input,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => ask(),
                    decoration: InputDecoration(
                      hintText: 'AHIR AI\'a sor...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  mini: true,
                  onPressed: sending ? null : ask,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(String label, String prompt) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(label),
        onPressed: sending
            ? null
            : () {
                input.text = prompt;
                ask();
              },
      ),
    );
  }
}

// ============================================================
// ÇİZGİ HAYVANLAR
// ============================================================

enum CharacterType { cow, sheep, goat }

class FarmCharacter extends StatelessWidget {
  final CharacterType type;
  final double size;

  const FarmCharacter({
    super.key,
    required this.type,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _AnimalPainter(type),
      ),
    );
  }
}

class _AnimalPainter extends CustomPainter {
  final CharacterType type;

  _AnimalPainter(this.type);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..style = PaintingStyle.fill;

    final outline = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s.width * .035
      ..color = const Color(0xFF4E342E);

    final c = Offset(s.width * .5, s.height * .5);

    final body = Rect.fromCenter(
      center: Offset(c.dx, c.dy + s.height * .08),
      width: s.width * .62,
      height: s.height * .40,
    );

    p.color = type == CharacterType.cow
        ? Colors.white
        : type == CharacterType.sheep
            ? const Color(0xFFF3F0E8)
            : const Color(0xFFE8D1B0);

    canvas.drawOval(body, p);
    canvas.drawOval(body, outline);

    p.color = type == CharacterType.cow
        ? const Color(0xFF795548)
        : type == CharacterType.sheep
            ? const Color(0xFFE0D9CC)
            : const Color(0xFF8D6E63);

    final head = Offset(c.dx, c.dy - s.height * .16);
    canvas.drawCircle(head, s.width * .25, p);
    canvas.drawCircle(head, s.width * .25, outline);

    if (type == CharacterType.cow) {
      p.color = Colors.white;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
            head.dx,
            head.dy + s.height * .06,
          ),
          width: s.width * .24,
          height: s.height * .13,
        ),
        p,
      );

      p.color = const Color(0xFF795548);
      canvas.drawCircle(
        Offset(
          head.dx - s.width * .10,
          head.dy - s.height * .08,
        ),
        s.width * .055,
        p,
      );
      canvas.drawCircle(
        Offset(
          head.dx + s.width * .10,
          head.dy - s.height * .02,
        ),
        s.width * .045,
        p,
      );
    } else if (type == CharacterType.goat) {
      p.color = const Color(0xFF6D4C41);

      final horn = Path()
        ..moveTo(
          head.dx - s.width * .16,
          head.dy - s.height * .18,
        )
        ..quadraticBezierTo(
          head.dx - s.width * .28,
          head.dy - s.height * .34,
          head.dx - s.width * .12,
          head.dy - s.height * .29,
        )
        ..close();

      canvas.drawPath(horn, p);

      final horn2 = Path()
        ..moveTo(
          head.dx + s.width * .16,
          head.dy - s.height * .18,
        )
        ..quadraticBezierTo(
          head.dx + s.width * .28,
          head.dy - s.height * .34,
          head.dx + s.width * .12,
          head.dy - s.height * .29,
        )
        ..close();

      canvas.drawPath(horn2, p);
    }

    p.color = Colors.black;

    canvas.drawCircle(
      Offset(
        head.dx - s.width * .09,
        head.dy - s.height * .04,
      ),
      s.width * .025,
      p,
    );

    canvas.drawCircle(
      Offset(
        head.dx + s.width * .09,
        head.dy - s.height * .04,
      ),
      s.width * .025,
      p,
    );

    p.color = const Color(0xFFF5B5B5);

    canvas.drawCircle(
      Offset(
        head.dx,
        head.dy + s.height * .09,
      ),
      s.width * .08,
      p,
    );

    p.color = const Color(0xFF4E342E);

    final smile = Path()
      ..moveTo(
        head.dx - s.width * .06,
        head.dy + s.height * .09,
      )
      ..quadraticBezierTo(
        head.dx,
        head.dy + s.height * .14,
        head.dx + s.width * .06,
        head.dy + s.height * .09,
      );

    canvas.drawPath(smile, outline);

    p.color = type == CharacterType.sheep
        ? const Color(0xFF795548)
        : const Color(0xFF5D4037);

    for (int i = -1; i <= 1; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            c.dx + i * s.width * .18 - s.width * .035,
            c.dy + s.height * .20,
            s.width * .07,
            s.height * .16,
          ),
          Radius.circular(s.width * .03),
        ),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnimalPainter oldDelegate) =>
      oldDelegate.type != type;
}
