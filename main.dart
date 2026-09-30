import 'package:flutter/material.dart';

void main() {
  runApp(HayvancilikApp());
}

// =====================
// VERİ MODELLERİ
// =====================

class Animal {
  String tag;
  String name;
  String species;
  String breed;
  String gender;
  DateTime birthDate;
  double weight;

  Animal({
    required this.tag,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.birthDate,
    required this.weight,
  });
}

class RationRecord {
  String animal;
  String feed;
  double amount;
  String unit;
  DateTime date;

  RationRecord({
    required this.animal,
    required this.feed,
    required this.amount,
    required this.unit,
    required this.date,
  });
}

class MilkRecord {
  String animal;
  double morning;
  double evening;
  DateTime date;

  MilkRecord({
    required this.animal,
    required this.morning,
    required this.evening,
    required this.date,
  });

  double get total => morning + evening;
}

class HealthRecord {
  String animal;
  String treatment;
  DateTime date;
  String note;

  HealthRecord({
    required this.animal,
    required this.treatment,
    required this.date,
    required this.note,
  });
}

// =====================
// UYGULAMA VERİSİ
// =====================

class AppData extends ChangeNotifier {
  final List<Animal> animals = [];
  final List<RationRecord> rations = [];
  final List<MilkRecord> milkRecords = [];
  final List<HealthRecord> healthRecords = [];

  bool darkMode = false;

  void addAnimal(Animal item) {
    animals.add(item);
    notifyListeners();
  }

  void removeAnimal(int index) {
    animals.removeAt(index);
    notifyListeners();
  }

  void addRation(RationRecord item) {
    rations.insert(0, item);
    notifyListeners();
  }

  void removeRation(int index) {
    rations.removeAt(index);
    notifyListeners();
  }

  void addMilk(MilkRecord item) {
    milkRecords.insert(0, item);
    notifyListeners();
  }

  void removeMilk(int index) {
    milkRecords.removeAt(index);
    notifyListeners();
  }

  void addHealth(HealthRecord item) {
    healthRecords.insert(0, item);
    notifyListeners();
  }

  void removeHealth(int index) {
    healthRecords.removeAt(index);
    notifyListeners();
  }

  void toggleTheme() {
    darkMode = !darkMode;
    notifyListeners();
  }

  void clearAll() {
    animals.clear();
    rations.clear();
    milkRecords.clear();
    healthRecords.clear();
    notifyListeners();
  }
}

// =====================
// IRK VERİTABANI
// =====================

class BreedInfo {
  final String category;
  final String name;
  final String origin;
  final String purpose;
  final String description;
  final String suitableFor;
  final String emoji;

  const BreedInfo({
    required this.category,
    required this.name,
    required this.origin,
    required this.purpose,
    required this.description,
    required this.suitableFor,
    required this.emoji,
  });
}

const List<BreedInfo> breedDatabase = [
  // SIĞIR
  BreedInfo(
    category: 'Sığır',
    name: 'Yerli Kara',
    origin: 'Türkiye yerli gen kaynağı',
    purpose: 'Et + süt',
    emoji: '🐄',
    description:
        'Orta Anadolu şartlarına uyumuyla öne çıkan yerli bir sığırdır. Daha mütevazı bakım ve besleme koşullarında yetiştirilebilmesi ve sakin yapısı önemli özelliklerindendir.',
    suitableFor:
        'Orta Anadolu ve benzer çevre şartlarında, dayanıklılık ve düşük girdiyle yetiştiricilik arayan işletmeler.',
  ),
  BreedInfo(
    category: 'Sığır',
    name: 'Güney Anadolu Kırmızısı (GAK)',
    origin: 'Türkiye yerli gen kaynağı',
    purpose: 'Et + süt',
    emoji: '🐄',
    description:
        'Güney Anadolu iklimine uyum sağlamış yerli bir ırktır. Düşük kaliteli yemleri değerlendirebilmesi ve sıcaklık ile çevre streslerine dayanıklılığıyla dikkat çeker.',
    suitableFor:
        'Sıcak ve zorlu çevre koşullarının görüldüğü bölgelerde, uyum kabiliyeti öncelikli yetiştiricilik.',
  ),
  BreedInfo(
    category: 'Sığır',
    name: 'Siyah Alaca (Holstein)',
    origin: 'Kültür ırkı; Türkiye’de yaygın yetiştirilir',
    purpose: 'Süt',
    emoji: '🐄',
    description:
        'Süt yönü güçlü bir kültür ırkıdır. Türkiye’de süt sığırcılığı işletmelerinde önemli bir yere sahiptir. Yüksek verim hedefinde kaliteli bakım, besleme ve sürü yönetimi önem kazanır.',
    suitableFor:
        'Süt üretimini merkeze alan, yemleme ve barınak yönetimi güçlü işletmeler.',
  ),
  BreedInfo(
    category: 'Sığır',
    name: 'Simental',
    origin: 'Kültür ırkı; Türkiye’de yetiştirilir',
    purpose: 'Et + süt',
    emoji: '🐄',
    description:
        'Kombine verim yönüyle bilinen bir sığırdır. Et ve süt özelliklerini birlikte değerlendirmek isteyen işletmelerde tercih edilen ırklardandır.',
    suitableFor:
        'Tek bir verim yerine et ve sütü birlikte değerlendiren işletmeler.',
  ),
  BreedInfo(
    category: 'Sığır',
    name: 'Esmer (Brown Swiss)',
    origin: 'Kültür ırkı; Türkiye’de yetiştirilir',
    purpose: 'Et + süt',
    emoji: '🐄',
    description:
        'Kombine verim yönlü bir kültür ırkıdır. Türkiye’de araştırma ve yetiştirme çalışmalarında da kullanılan önemli sığır genotiplerinden biridir.',
    suitableFor:
        'Kombine üretim hedefleyen ve düzenli sürü yönetimi yapabilen işletmeler.',
  ),
  BreedInfo(
    category: 'Sığır',
    name: 'Jersey',
    origin: 'Kültür ırkı; Türkiye’de yetiştirilir',
    purpose: 'Süt',
    emoji: '🐄',
    description:
        'Süt yönlü bir ırktır. Özellikle süt üretimi odaklı sürülerde değerlendirilir. Irk seçimi yapılırken işletmenin yem kaynağı ve hedef pazarı birlikte düşünülmelidir.',
    suitableFor:
        'Süt üretimine odaklanan ve sürü bazında verim takibi yapan işletmeler.',
  ),

  // KOYUN
  BreedInfo(
    category: 'Koyun',
    name: 'Akkaraman',
    origin: 'Türkiye yerli koyun ırkı',
    purpose: 'Et + süt',
    emoji: '🐑',
    description:
        'Türkiye’nin önemli yerli koyun ırklarındandır. Kombine verim yönüyle değerlendirilir ve çevreye uyum konusunda yerli ırkların avantajlarını taşır.',
    suitableFor:
        'Geniş mera kullanımı ve farklı iklim koşullarında dayanıklı sürü yönetimi.',
  ),
  BreedInfo(
    category: 'Koyun',
    name: 'Morkaraman',
    origin: 'Türkiye yerli koyun ırkı',
    purpose: 'Et ağırlıklı kombine',
    emoji: '🐑',
    description:
        'Özellikle Doğu Anadolu şartlarıyla özdeşleşmiş yerli koyunlardan biridir. Yürüme, sürüye uyum ve soğuk koşullara dayanıklılık gibi özellikleriyle bilinir.',
    suitableFor:
        'Soğuk iklim, mera ağırlıklı yetiştiricilik ve zorlu çevre şartları.',
  ),
  BreedInfo(
    category: 'Koyun',
    name: 'İvesi',
    origin: 'Türkiye’de yaygın yerli koyun ırkı',
    purpose: 'Süt ağırlıklı',
    emoji: '🐑',
    description:
        'Süt yönü belirgin küçükbaş ırklarındandır. Sıcak ve kurak şartlara uyumu, uzun mesafe yürüyebilmesi ve güçlü analık özellikleriyle tanınır.',
    suitableFor:
        'Sıcak-kurak bölgelerde süt üretimini önceliklendiren sürüler.',
  ),
  BreedInfo(
    category: 'Koyun',
    name: 'Kıvırcık',
    origin: 'Türkiye yerli koyun ırkı',
    purpose: 'Et + süt',
    emoji: '🐑',
    description:
        'İnce ve uzun kuyruklu yerli koyun grubu içinde yer alır. Özellikle Trakya ve Marmara çevresiyle ilişkilendirilen önemli gen kaynaklarımızdandır.',
    suitableFor:
        'Marmara ve benzeri çevrelerde mera ve et üretimini birlikte değerlendiren işletmeler.',
  ),
  BreedInfo(
    category: 'Koyun',
    name: 'Karayaka',
    origin: 'Türkiye yerli koyun ırkı',
    purpose: 'Et ağırlıklı',
    emoji: '🐑',
    description:
        'Karadeniz Bölgesi ile güçlü şekilde ilişkilendirilen yerli koyun ırkıdır. Türkiye’nin korunması ve yetiştirilmesi gereken gen kaynakları arasında yer alır.',
    suitableFor:
        'Karadeniz şartlarına uyumlu mera temelli koyunculuk yapan işletmeler.',
  ),
  BreedInfo(
    category: 'Koyun',
    name: 'Sakız',
    origin: 'Türkiye’de yetiştirilen yerli koyun ırkı',
    purpose: 'Süt + döl verimi',
    emoji: '🐑',
    description:
        'Süt yönü belirgin koyunlardan biridir. Türkiye’de özellikle Ege ve kıyı bölgeleriyle anılır. Süt ve döl özellikleri nedeniyle özel yetiştiricilikte dikkat çeker.',
    suitableFor:
        'Süt ve döl verimini birlikte takip eden, kontrollü yetiştiricilik yapan işletmeler.',
  ),
  BreedInfo(
    category: 'Koyun',
    name: 'Orta Anadolu Merinosu',
    origin: 'Türkiye’de geliştirilmiş merinos tipi',
    purpose: 'Et + yapağı',
    emoji: '🐑',
    description:
        'Merinos tipi genetik yapı ile Akkaraman’ın uyum özelliklerinin bir araya getirilmesiyle geliştirilen bir koyundur. Orta Anadolu koşullarına yönelik yetiştiricilikte değerlendirilir.',
    suitableFor:
        'Orta Anadolu’da et ve yapağı verimini birlikte değerlendirmek isteyen işletmeler.',
  ),

  // KEÇİ
  BreedInfo(
    category: 'Keçi',
    name: 'Kıl Keçisi',
    origin: 'Türkiye yerli keçi ırkı',
    purpose: 'Et + süt + kıl',
    emoji: '🐐',
    description:
        'Türkiye’nin en yaygın yerli keçi kaynaklarından biridir. Özellikle makilik ve dağlık alanlarda hareket kabiliyeti ve çevreye uyumu ile öne çıkar.',
    suitableFor:
        'Dağlık, taşlık ve makilik alanlarda mera ağırlıklı keçicilik.',
  ),
  BreedInfo(
    category: 'Keçi',
    name: 'Ankara (Tiftik) Keçisi',
    origin: 'Türkiye yerli keçi ırkı',
    purpose: 'Tiftik',
    emoji: '🐐',
    description:
        'İnce ve kıvırcık tiftik elyafıyla tanınır. Türkiye’nin önemli yerli gen kaynaklarından biridir ve özellikle tiftik üretimi amacıyla değerlendirilir.',
    suitableFor:
        'Tiftik üretimini merkeze alan ve uygun iklim-barınak şartlarına sahip işletmeler.',
  ),
  BreedInfo(
    category: 'Keçi',
    name: 'Honamlı',
    origin: 'Türkiye yerli keçi ırkı',
    purpose: 'Et + süt',
    emoji: '🐐',
    description:
        'Türkiye’nin yerli keçi gen kaynakları arasında yer alan Honamlı, kombine verim yönüyle değerlendirilir. Sürü yönetimi ve bölgesel uyum, verimin önemli belirleyicileridir.',
    suitableFor:
        'Akdeniz ve benzeri bölgelerde et-süt yönünü birlikte değerlendiren işletmeler.',
  ),
  BreedInfo(
    category: 'Keçi',
    name: 'Kilis Keçisi',
    origin: 'Türkiye yerli keçi ırkı',
    purpose: 'Süt',
    emoji: '🐐',
    description:
        'Güneydoğu Anadolu ile ilişkilendirilen yerli keçi ırklarındandır. Süt yönüyle öne çıkar ve sıcak bölge yetiştiriciliğinde değerlendirilir.',
    suitableFor:
        'Süt keçiciliği yapan ve sıcak iklim koşullarında çalışan işletmeler.',
  ),
  BreedInfo(
    category: 'Keçi',
    name: 'Türk Saaneni',
    origin: 'Türkiye’de geliştirilmiş süt tipi',
    purpose: 'Süt',
    emoji: '🐐',
    description:
        'Süt verimini geliştirmeye yönelik yetiştiricilik çalışmalarında kullanılan bir genotiptir. İşletme başarısında düzenli besleme ve sürü kayıtları önemlidir.',
    suitableFor:
        'Süt üretimi ve düzenli kayıt sistemi bulunan modern keçi işletmeleri.',
  ),
];

// =====================
// ANA UYGULAMA
// =====================

class HayvancilikApp extends StatelessWidget {
  HayvancilikApp({super.key});

  final AppData data = AppData();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: data,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hayvancılık Asistanı',
          themeMode: data.darkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.green,
            scaffoldBackgroundColor: const Color(0xFFF7F5EF),
            cardTheme: const CardThemeData(
              elevation: 1,
              margin: EdgeInsets.zero,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.green,
            brightness: Brightness.dark,
          ),
          home: HomeShell(data: data),
        );
      },
    );
  }
}

// =====================
// ANA MENÜ
// =====================

class HomeShell extends StatefulWidget {
  final AppData data;

  const HomeShell({super.key, required this.data});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(data: widget.data),
      AnimalsPage(data: widget.data),
      SettingsPage(data: widget.data),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() => currentIndex = index);
        },
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
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final AppData data;

  const HomePage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _HomeCard(
        title: 'Hayvanlar',
        subtitle: 'Hayvan ekle ve takip et',
        icon: Icons.pets,
        color: Colors.green,
        page: AnimalsPage(data: data),
      ),
      _HomeCard(
        title: 'Rasyon',
        subtitle: 'Yem kayıtlarını yönet',
        icon: Icons.grass,
        color: Colors.orange,
        page: RationPage(data: data),
      ),
      _HomeCard(
        title: 'Süt Takibi',
        subtitle: 'Günlük süt kayıtları',
        icon: Icons.water_drop,
        color: Colors.blue,
        page: MilkPage(data: data),
      ),
      _HomeCard(
        title: 'Sağlık',
        subtitle: 'Aşı ve tedavi kayıtları',
        icon: Icons.health_and_safety,
        color: Colors.red,
        page: HealthPage(data: data),
      ),
      _HomeCard(
        title: 'Irklar',
        subtitle: 'Türkiye’deki ırk rehberi',
        icon: Icons.menu_book,
        color: Colors.purple,
        page: BreedsPage(),
      ),
      _HomeCard(
        title: 'Raporlar',
        subtitle: 'İşletme özetini gör',
        icon: Icons.bar_chart,
        color: Colors.teal,
        page: ReportsPage(data: data),
      ),
    ];

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hayvancılık Asistanı',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'İşletmenizi tek yerden kolayca takip edin.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.agriculture,
                              size: 30,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hoş Geldiniz 👋',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${data.animals.length} hayvan • ${data.healthRecords.length} sağlık kaydı',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = cards[index];
                  return item;
                },
                childCount: cards.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.95,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final MaterialColor color;
  final Widget page;

  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: color.shade100,
                child: Icon(icon, color: color.shade700),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================
// HAYVANLAR
// =====================

class AnimalsPage extends StatelessWidget {
  final AppData data;

  const AnimalsPage({super.key, required this.data});

  Future<void> _addAnimal(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnimalFormPage(data: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hayvanlar')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addAnimal(context),
        icon: const Icon(Icons.add),
        label: const Text('Hayvan Ekle'),
      ),
      body: AnimatedBuilder(
        animation: data,
        builder: (context, _) {
          if (data.animals.isEmpty) {
            return EmptyState(
              icon: Icons.pets,
              title: 'Henüz hayvan eklenmedi',
              text: 'İlk hayvanınızı ekleyerek başlayın.',
              buttonText: 'Hayvan Ekle',
              onPressed: () => _addAnimal(context),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.animals.length,
            itemBuilder: (context, index) {
              final animal = data.animals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      animal.species == 'Sığır'
                          ? '🐄'
                          : animal.species == 'Koyun'
                              ? '🐑'
                              : animal.species == 'Keçi'
                                  ? '🐐'
                                  : '🐾',
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  title: Text(
                    animal.name.isEmpty ? animal.tag : animal.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${animal.tag} • ${animal.species} • ${animal.breed}\n'
                    '${animal.gender} • ${animal.weight.toStringAsFixed(1)} kg',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Hayvan silinsin mi?'),
                          content: Text(
                            '${animal.name.isEmpty ? animal.tag : animal.name} kaydı silinecek.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Vazgeç'),
                            ),
                            FilledButton(
                              onPressed: () {
                                data.removeAnimal(index);
                                Navigator.pop(context);
                              },
                              child: const Text('Sil'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AnimalFormPage extends StatefulWidget {
  final AppData data;

  const AnimalFormPage({super.key, required this.data});

  @override
  State<AnimalFormPage> createState() => _AnimalFormPageState();
}

class _AnimalFormPageState extends State<AnimalFormPage> {
  final formKey = GlobalKey<FormState>();
  final tagController = TextEditingController();
  final nameController = TextEditingController();
  final breedController = TextEditingController();
  final weightController = TextEditingController();

  String species = 'Sığır';
  String gender = 'Dişi';
  DateTime birthDate = DateTime.now();

  @override
  void dispose() {
    tagController.dispose();
    nameController.dispose();
    breedController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (result != null) {
      setState(() => birthDate = result);
    }
  }

  void save() {
    if (!formKey.currentState!.validate()) return;

    widget.data.addAnimal(
      Animal(
        tag: tagController.text.trim(),
        name: nameController.text.trim(),
        species: species,
        breed: breedController.text.trim(),
        gender: gender,
        birthDate: birthDate,
        weight: double.tryParse(
              weightController.text.replaceAll(',', '.'),
            ) ??
            0,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hayvan başarıyla eklendi.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hayvan Ekle')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            AppTextField(
              controller: tagController,
              label: 'Küpe / Hayvan No',
              icon: Icons.confirmation_number,
              validator: requiredValidator,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: nameController,
              label: 'Hayvan Adı',
              icon: Icons.pets,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: species,
              decoration: const InputDecoration(
                labelText: 'Tür',
                prefixIcon: Icon(Icons.category),
              ),
              items: const [
                DropdownMenuItem(value: 'Sığır', child: Text('Sığır')),
                DropdownMenuItem(value: 'Koyun', child: Text('Koyun')),
                DropdownMenuItem(value: 'Keçi', child: Text('Keçi')),
                DropdownMenuItem(value: 'Manda', child: Text('Manda')),
                DropdownMenuItem(value: 'Tavuk', child: Text('Tavuk')),
              ],
              onChanged: (value) => setState(() => species = value!),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: breedController,
              label: 'Irk',
              icon: Icons.menu_book,
              validator: requiredValidator,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: gender,
              decoration: const InputDecoration(
                labelText: 'Cinsiyet',
                prefixIcon: Icon(Icons.wc),
              ),
              items: const [
                DropdownMenuItem(value: 'Dişi', child: Text('Dişi')),
                DropdownMenuItem(value: 'Erkek', child: Text('Erkek')),
              ],
              onChanged: (value) => setState(() => gender = value!),
            ),
            const SizedBox(height: 12),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              leading: const Icon(Icons.calendar_month),
              title: const Text('Doğum Tarihi'),
              subtitle: Text(formatDate(birthDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: chooseDate,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: weightController,
              label: 'Canlı Ağırlık (kg)',
              icon: Icons.monitor_weight,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: requiredValidator,
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: save,
              icon: const Icon(Icons.save),
              label: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// RASYON
// =====================

class RationPage extends StatefulWidget {
  final AppData data;

  const RationPage({super.key, required this.data});

  @override
  State<RationPage> createState() => _RationPageState();
}

class _RationPageState extends State<RationPage> {
  final animalController = TextEditingController();
  final feedController = TextEditingController();
  final amountController = TextEditingController();
  String unit = 'kg';

  @override
  void dispose() {
    animalController.dispose();
    feedController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void add() {
    final amount =
        double.tryParse(amountController.text.replaceAll(',', '.'));
    if (animalController.text.trim().isEmpty ||
        feedController.text.trim().isEmpty ||
        amount == null) {
      showMessage(context, 'Hayvan, yem ve miktarı doldurun.');
      return;
    }

    widget.data.addRation(
      RationRecord(
        animal: animalController.text.trim(),
        feed: feedController.text.trim(),
        amount: amount,
        unit: unit,
        date: DateTime.now(),
      ),
    );

    animalController.clear();
    feedController.clear();
    amountController.clear();
    setState(() {});
    showMessage(context, 'Rasyon kaydı eklendi.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rasyon Takibi')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppTextField(
                    controller: animalController,
                    label: 'Hayvan / Grup',
                    icon: Icons.pets,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: feedController,
                    label: 'Yem',
                    icon: Icons.grass,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: amountController,
                          label: 'Miktar',
                          icon: Icons.scale,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 105,
                        child: DropdownButtonFormField<String>(
                          value: unit,
                          decoration:
                              const InputDecoration(labelText: 'Birim'),
                          items: const [
                            DropdownMenuItem(
                              value: 'kg',
                              child: Text('kg'),
                            ),
                            DropdownMenuItem(
                              value: 'g',
                              child: Text('g'),
                            ),
                            DropdownMenuItem(
                              value: 'L',
                              child: Text('L'),
                            ),
                          ],
                          onChanged: (v) => setState(() => unit = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: add,
                      icon: const Icon(Icons.add),
                      label: const Text('Rasyon Kaydı Ekle'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: widget.data,
            builder: (context, _) {
              if (widget.data.rations.isEmpty) {
                return const EmptyInline(text: 'Henüz rasyon kaydı yok.');
              }

              return Column(
                children: List.generate(
                  widget.data.rations.length,
                  (index) {
                    final item = widget.data.rations[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.grass),
                        ),
                        title: Text('${item.animal} • ${item.feed}'),
                        subtitle: Text(
                          '${item.amount.toStringAsFixed(2)} ${item.unit} • ${formatDate(item.date)}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => widget.data.removeRation(index),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================
// SÜT TAKİBİ
// =====================

class MilkPage extends StatefulWidget {
  final AppData data;

  const MilkPage({super.key, required this.data});

  @override
  State<MilkPage> createState() => _MilkPageState();
}

class _MilkPageState extends State<MilkPage> {
  final animalController = TextEditingController();
  final morningController = TextEditingController();
  final eveningController = TextEditingController();

  @override
  void dispose() {
    animalController.dispose();
    morningController.dispose();
    eveningController.dispose();
    super.dispose();
  }

  void add() {
    final morning =
        double.tryParse(morningController.text.replaceAll(',', '.')) ?? 0;
    final evening =
        double.tryParse(eveningController.text.replaceAll(',', '.')) ?? 0;

    if (animalController.text.trim().isEmpty) {
      showMessage(context, 'Hayvan adını veya numarasını girin.');
      return;
    }

    widget.data.addMilk(
      MilkRecord(
        animal: animalController.text.trim(),
        morning: morning,
        evening: evening,
        date: DateTime.now(),
      ),
    );

    animalController.clear();
    morningController.clear();
    eveningController.clear();
    showMessage(context, 'Süt kaydı eklendi.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Süt Takibi')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppTextField(
                    controller: animalController,
                    label: 'Hayvan / Grup',
                    icon: Icons.pets,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: morningController,
                          label: 'Sabah (L)',
                          icon: Icons.wb_sunny,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppTextField(
                          controller: eveningController,
                          label: 'Akşam (L)',
                          icon: Icons.nightlight,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: add,
                      icon: const Icon(Icons.add),
                      label: const Text('Süt Kaydı Ekle'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: widget.data,
            builder: (context, _) {
              final total = widget.data.milkRecords.fold<double>(
                0,
                (sum, item) => sum + item.total,
              );

              return Column(
                children: [
                  Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.water_drop),
                      ),
                      title: const Text('Toplam Kayıtlı Süt'),
                      subtitle: Text(
                        '${total.toStringAsFixed(2)} litre',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.data.milkRecords.isEmpty)
                    const EmptyInline(text: 'Henüz süt kaydı yok.'),
                  ...List.generate(
                    widget.data.milkRecords.length,
                    (index) {
                      final item = widget.data.milkRecords[index];
                      return Card(
                        child: ListTile(
                          title: Text(item.animal),
                          subtitle: Text(
                            'Sabah: ${item.morning.toStringAsFixed(2)} L  •  '
                            'Akşam: ${item.evening.toStringAsFixed(2)} L\n'
                            'Toplam: ${item.total.toStringAsFixed(2)} L • '
                            '${formatDate(item.date)}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () =>
                                widget.data.removeMilk(index),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================
// SAĞLIK
// =====================

class HealthPage extends StatefulWidget {
  final AppData data;

  const HealthPage({super.key, required this.data});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final animalController = TextEditingController();
  final treatmentController = TextEditingController();
  final noteController = TextEditingController();

  DateTime date = DateTime.now();

  @override
  void dispose() {
    animalController.dispose();
    treatmentController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> chooseDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (result != null) setState(() => date = result);
  }

  void add() {
    if (animalController.text.trim().isEmpty ||
        treatmentController.text.trim().isEmpty) {
      showMessage(context, 'Hayvan ve işlem bilgisini doldurun.');
      return;
    }

    widget.data.addHealth(
      HealthRecord(
        animal: animalController.text.trim(),
        treatment: treatmentController.text.trim(),
        date: date,
        note: noteController.text.trim(),
      ),
    );

    animalController.clear();
    treatmentController.clear();
    noteController.clear();
    setState(() => date = DateTime.now());
    showMessage(context, 'Sağlık kaydı eklendi.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sağlık Takibi')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppTextField(
                    controller: animalController,
                    label: 'Hayvan / Grup',
                    icon: Icons.pets,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: treatmentController,
                    label: 'Aşı / Tedavi / İşlem',
                    icon: Icons.vaccines,
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    leading: const Icon(Icons.calendar_month),
                    title: const Text('İşlem Tarihi'),
                    subtitle: Text(formatDate(date)),
                    onTap: chooseDate,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: noteController,
                    label: 'Not',
                    icon: Icons.notes,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: add,
                      icon: const Icon(Icons.save),
                      label: const Text('Sağlık Kaydı Ekle'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          AnimatedBuilder(
            animation: widget.data,
            builder: (context, _) {
              if (widget.data.healthRecords.isEmpty) {
                return const EmptyInline(text: 'Henüz sağlık kaydı yok.');
              }

              return Column(
                children: List.generate(
                  widget.data.healthRecords.length,
                  (index) {
                    final item = widget.data.healthRecords[index];
                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.health_and_safety),
                        ),
                        title: Text(item.treatment),
                        subtitle: Text(
                          '${item.animal} • ${formatDate(item.date)}\n'
                          '${item.note.isEmpty ? "Not yok" : item.note}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              widget.data.removeHealth(index),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================
// IRKLAR
// =====================

class BreedsPage extends StatefulWidget {
  const BreedsPage({super.key});

  @override
  State<BreedsPage> createState() => _BreedsPageState();
}

class _BreedsPageState extends State<BreedsPage> {
  String category = 'Tümü';
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = breedDatabase.where((breed) {
      final categoryOk =
          category == 'Tümü' || breed.category == category;
      final searchOk = search.isEmpty ||
          breed.name.toLowerCase().contains(search.toLowerCase()) ||
          breed.purpose.toLowerCase().contains(search.toLowerCase());
      return categoryOk && searchOk;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Türkiye Irk Rehberi'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Irk ara...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                        onPressed: () => setState(() => search = ''),
                        icon: const Icon(Icons.clear),
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => search = value),
            ),
          ),
          SizedBox(
            height: 54,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 7,
              ),
              children: [
                'Tümü',
                'Sığır',
                'Koyun',
                'Keçi',
              ].map((item) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(item),
                    selected: category == item,
                    onSelected: (_) => setState(() => category = item),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.search_off,
                    title: 'Irk bulunamadı',
                    text: 'Arama kelimesini veya kategoriyi değiştirin.',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final breed = filtered[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            radius: 27,
                            child: Text(
                              breed.emoji,
                              style: const TextStyle(fontSize: 25),
                            ),
                          ),
                          title: Text(
                            breed.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${breed.category} • ${breed.purpose}',
                          ),
                          trailing:
                              const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BreedDetailPage(breed: breed),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class BreedDetailPage extends StatelessWidget {
  final BreedInfo breed;

  const BreedDetailPage({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(breed.name)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    breed.emoji,
                    style: const TextStyle(fontSize: 70),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    breed.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Chip(label: Text(breed.category)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Köken / Durum',
            icon: Icons.public,
            text: breed.origin,
          ),
          InfoCard(
            title: 'Verim yönü',
            icon: Icons.trending_up,
            text: breed.purpose,
          ),
          InfoCard(
            title: 'Özgün ırk notu',
            icon: Icons.lightbulb_outline,
            text: breed.description,
          ),
          InfoCard(
            title: 'Hangi işletmeler için düşünülebilir?',
            icon: Icons.agriculture,
            text: breed.suitableFor,
          ),
          const SizedBox(height: 8),
          const Text(
            'Not: Irk seçimi; bölge, yem kaynağı, barınak, sürü yönetimi, '
            'hedeflenen verim ve işletme ekonomisi birlikte değerlendirilerek yapılmalıdır.',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

// =====================
// RAPORLAR
// =====================

class ReportsPage extends StatelessWidget {
  final AppData data;

  const ReportsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Raporlar')),
      body: AnimatedBuilder(
        animation: data,
        builder: (context, _) {
          final milk = data.milkRecords.fold<double>(
            0,
            (sum, item) => sum + item.total,
          );

          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Text(
                'İşletme Özeti',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Hayvan',
                      value: '${data.animals.length}',
                      icon: Icons.pets,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: 'Sağlık',
                      value: '${data.healthRecords.length}',
                      icon: Icons.health_and_safety,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Rasyon',
                      value: '${data.rations.length}',
                      icon: Icons.grass,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: 'Süt',
                      value: '${milk.toStringAsFixed(1)} L',
                      icon: Icons.water_drop,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hızlı Durum',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ReportLine(
                        icon: Icons.pets,
                        label: 'Kayıtlı hayvan',
                        value: '${data.animals.length}',
                      ),
                      ReportLine(
                        icon: Icons.water_drop,
                        label: 'Kayıtlı süt',
                        value: '${milk.toStringAsFixed(2)} L',
                      ),
                      ReportLine(
                        icon: Icons.health_and_safety,
                        label: 'Sağlık işlemi',
                        value: '${data.healthRecords.length}',
                      ),
                      ReportLine(
                        icon: Icons.grass,
                        label: 'Rasyon kaydı',
                        value: '${data.rations.length}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// =====================
// AYARLAR
// =====================

class SettingsPage extends StatelessWidget {
  final AppData data;

  const SettingsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: SwitchListTile(
              title: const Text('Koyu Tema'),
              subtitle: const Text('Uygulamanın görünümünü değiştirir.'),
              secondary: const Icon(Icons.dark_mode),
              value: data.darkMode,
              onChanged: (_) => data.toggleTheme(),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Uygulama Hakkında'),
              subtitle: const Text(
                'Hayvancılık Asistanı • İşletme takip uygulaması',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Hayvancılık Asistanı',
                  applicationVersion: '1.0.0',
                  applicationIcon: const Icon(Icons.agriculture),
                  children: const [
                    Text(
                      'Hayvan, rasyon, süt, sağlık ve ırk bilgilerini '
                      'tek yerde takip etmek için hazırlanmıştır.',
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_sweep),
              title: const Text('Tüm Kayıtları Sil'),
              subtitle: const Text(
                'Hayvan, rasyon, süt ve sağlık kayıtlarını temizler.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Emin misiniz?'),
                    content: const Text(
                      'Bu işlem tüm kayıtları siler ve geri alınamaz.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Vazgeç'),
                      ),
                      FilledButton(
                        onPressed: () {
                          data.clearAll();
                          Navigator.pop(context);
                          showMessage(
                            context,
                            'Tüm kayıtlar temizlendi.',
                          );
                        },
                        child: const Text('Tümünü Sil'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Hayvancılık Asistanı\nİlk sürüm',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================
// YARDIMCI WIDGETLAR
// =====================

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final String? buttonText;
  final VoidCallback? onPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.text,
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 70,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center),
            if (buttonText != null) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.add),
                label: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyInline extends StatelessWidget {
  final String text;

  const EmptyInline({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(child: Text(text)),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;

  const InfoCard({
    super.key,
    required this.title,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class ReportLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ReportLine({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Icon(icon, size: 21),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// =====================
// YARDIMCI FONKSİYONLAR
// =====================

String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}

String? requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Bu alan zorunlu';
  }
  return null;
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}
