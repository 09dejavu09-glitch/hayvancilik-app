import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // AdMob eklendi

void main() async {
  // AdMob ve yerel depolama için motorların düzgün başlamasını sağlıyoruz
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

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
    'Simental', 'Holstein', 'Montofon', 'Jersey', 'Angus', 'Hereford',
    'Limuzin', 'Şarole', 'Belçika Mavisi', 'Yerli Kara', 'Boz Irk',
    'Güney Anadolu Kırmızısı', 'Doğu Anadolu Kırmızısı', 'Zavot',
    'Anadolu Mandası', 'Akkaraman', 'Kangal Akkaraman', 'Morkaraman',
    'Dağlıç', 'İvesi', 'Karagül', 'Norduz', 'Çine Çaparı', 'Hemşin',
    'Tuj', 'Kıvırcık', 'Karayaka', 'Sakız', 'Gökçeada', 'Merinos',
    'Pırlak', 'Ramlıç', 'Anadolu Merinosu', 'Orta Anadolu Merinosu',
    'Karacabey Merinosu', 'Malya', 'Acıpayam', 'Sönmez', 'Türkgeldi',
    'Tahirova', 'Menemen', 'Karya', 'Bafra', 'Güney Karaman',
    'Ankara Keçisi', 'Kıl Keçisi', 'Norduz Keçisi', 'Kilis Keçisi',
    'Honamlı Keçisi', 'Saanen', 'Toggenburg',
  ];

  List<String> _breedsForSpecies(String species) {
    switch (species) {
      case 'Büyükbaş':
        return [
          'Simental', 'Holstein', 'Montofon', 'Jersey', 'Angus', 'Hereford',
          'Limuzin', 'Şarole', 'Belçika Mavisi', 'Yerli Kara', 'Boz Irk',
          'Güney Anadolu Kırmızısı', 'Doğu Anadolu Kırmızısı', 'Zavot',
        ];
      case 'Manda':
        return ['Anadolu Mandası'];
      case 'Koyun':
        return [
          'Akkaraman', 'Kangal Akkaraman', 'Morkaraman', 'Dağlıç', 'İvesi',
          'Karagül', 'Norduz', 'Çine Çaparı', 'Hemşin', 'Tuj', 'Kıvırcık',
          'Karayaka', 'Sakız', 'Gökçeada', 'Merinos', 'Pırlak', 'Ramlıç',
          'Anadolu Merinosu', 'Orta Anadolu Merinosu', 'Karacabey Merinosu',
          'Malya', 'Acıpayam', 'Sönmez', 'Türkgeldi', 'Tahirova', 'Menemen',
          'Karya', 'Bafra', 'Güney Karaman',
        ];
      case 'Keçi':
        return [
          'Ankara Keçisi', 'Kıl Keçisi', 'Norduz Keçisi', 'Kilis Keçisi',
          'Honamlı Keçisi', 'Saanen', 'Toggenburg',
        ];
      default:
        return breeds;
    }
  }

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
                              final tag = a.tag;
                              setState(() {
                                animals.removeAt(i);
                                healthRecords.removeWhere((x) => x.animalTag == tag);
                                milkRecords.removeWhere((x) => x.animalTag == tag);
                                reminders.removeWhere((x) => x.animalTag == tag);
                              });
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
                    'Manda',
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
                  onChanged: (v) {
                    if (v == null) return;
                    setD(() {
                      species = v;
                      final list = _breedsForSpecies(species);
                      breed = list.first;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: breed,
                  decoration: const InputDecoration(
                    labelText: 'Irk',
                    helperText: 'Seçtiğin türe göre ırklar otomatik filtrelenir.',
                  ),
                  items: _breedsForSpecies(species)
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
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 30),
      children: [
        const Text(
          'Türkiye Hayvan Irkları',
          style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 6),
        const Text(
          'Irka dokun. Verim yönü, öne çıkan özelliği, bakım yaklaşımı ve '
          'Türkiye’deki kullanım alanı hakkında kısa ve pratik bilgi al.',
        ),
        const SizedBox(height: 12),
        _breedGroup(
          'Büyükbaş',
          CharacterType.cow,
          _breedsForSpecies('Büyükbaş'),
        ),
        _breedGroup(
          'Manda',
          CharacterType.cow,
          _breedsForSpecies('Manda'),
        ),
        _breedGroup(
          'Koyun',
          CharacterType.sheep,
          _breedsForSpecies('Koyun'),
        ),
        _breedGroup(
          'Keçi',
          CharacterType.goat,
          _breedsForSpecies('Keçi'),
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
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        initiallyExpanded: title == 'Büyükbaş',
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
                subtitle: Text(
                  _breedInfo[b]?['short'] ?? 'Kısa ırk bilgisi için dokun.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _breedDetail(b),
              ),
            )
            .toList(),
      ),
    );
  }

  final Map<String, Map<String, String>> _breedInfo = {
    'Simental': {
      'short': 'Et ve süt yönünü birlikte taşıyan güçlü kombine sığır.',
      'verim': 'Et + süt',
      'uyum': 'Farklı işletme koşullarına uyum sağlayabilen kombine yapı.',
      'bakim': 'Kaba yem kalitesi, enerji-protein dengesi ve ayak sağlığı izlenmeli.',
      'not': 'Çift amaçlı işletmelerde tercih edilir.',
    },
    'Holstein': {
      'short': 'Süt verimi yönü belirgin, yaygın kullanılan kültür ırkı.',
      'verim': 'Süt',
      'uyum': 'İyi bakım ve düzenli besleme ister.',
      'bakim': 'Enerji dengesi, meme sağlığı ve ayak-tırnak yakından takip edilmeli.',
      'not': 'Süt işletmelerinde genetik kapasitenin karşılanması önemlidir.',
    },
  };

  void _breedDetail(String breed) {
    final info = _breedInfo[breed];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.pets),
            const SizedBox(width: 8),
            Expanded(child: Text(breed)),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info?['short'] ?? 'Bu ırk için temel yetiştirme bilgisi.',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _breedInfoRow('Verim yönü', info?['verim'] ?? '-'),
                _breedInfoRow('Uyum', info?['uyum'] ?? '-'),
                _breedInfoRow('Bakım / besleme', info?['bakim'] ?? '-'),
                _breedInfoRow('AHIR notu', info?['not'] ?? '-'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  Widget _breedInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(value, style: const TextStyle(height: 1.35)),
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
                  child: Icon(Icons.medical_services, color: const Color(0xFF2E7D32)),
                ),
                title: Text(r.title, style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${r.type} • ${r.animalTag} • ${r.date}'),
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

  void _addHealthRecord({String? type, String? initialAnimal}) {
    final title = TextEditingController();
    final date = TextEditingController(text: _today());
    final note = TextEditingController();

    String selectedType = type ?? 'Aşı';
    String animalTag = initialAnimal ?? (animals.isNotEmpty ? animals.first.tag : '');

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
                  decoration: const InputDecoration(labelText: 'Hayvan'),
                  items: animals
                      .map((a) => DropdownMenuItem(value: a.tag, child: Text(a.tag)))
                      .toList(),
                  onChanged: (v) => setD(() => animalTag = v!),
                ),
                TextField(
                  controller: title,
                  decoration: const InputDecoration(labelText: 'Başlık'),
                ),
                TextField(
                  controller: date,
                  decoration: const InputDecoration(labelText: 'Tarih'),
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

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Yeni Hatırlatma'),
        content: TextField(
          controller: title,
          decoration: const InputDecoration(labelText: 'Başlık'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SÜT TAKİBİ
  // ==========================================================

  Widget _milk() {
    double total = milkRecords.fold(0, (sum, item) => sum + item.total);

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
                  child: Icon(Icons.local_drink, color: Color(0xFF2E7D32)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Toplam kayıtlı süt', style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('${total.toStringAsFixed(1)} L', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _actionCard('Süt Kaydı Ekle', Icons.add, 'Sabah ve akşam sütünü kaydet.', _addMilkRecord),
      ],
    );
  }

  void _addMilkRecord({String? initialAnimal}) {
    if (animals.isEmpty) {
      _snack('Önce hayvan eklemelisin.');
      return;
    }
    // Basit örnek ekleme mantığı
    setState(() {
      milkRecords.add(MilkRecord(
        animalTag: animals.first.tag,
        date: _today(),
        morning: 10.0,
        evening: 12.0,
      ));
    });
    _saveData();
    _snack('Örnek süt kaydı eklendi.');
  }

  // ==========================================================
  // RASYON & RAPORLAR & AYARLAR
  // ==========================================================

  Widget _ration() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _actionCard('Yem Stoku', Icons.inventory_2, 'Stokları yönet', () {}),
      ],
    );
  }

  Widget _reports() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _actionCard('Sürü Raporu', Icons.pets, '${animals.length} hayvan kayıtlı', () {}),
      ],
    );
  }

  Widget _settings() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        _actionCard('AHIR Hakkında', Icons.info_outline, 'Akıllı Hayvancılık', () {}),
      ],
    );
  }

  Widget _actionCard(String title, IconData icon, String subtitle, VoidCallback onTap) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE1F0E2),
          child: Icon(icon, color: const Color(0xFF2E7D32)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _emptyState(IconData icon, String title, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Icon(icon, size: 52, color: const Color(0xFF2E7D32)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 5),
            Text(subtitle, textAlign: TextAlign.center),
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

// ============================================================
// AHIR AI & ÇİZGİ KARAKTERLER (Eksiksiz)
// ============================================================

class AhirAI extends StatelessWidget {
  const AhirAI({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'AHIR AI Asistanı Aktif 🤖🐄\n\nSorularınızı ve rasyon taleplerinizi buradan yönetebilirsiniz.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

enum CharacterType { cow, sheep, goat }

class FarmCharacter extends StatelessWidget {
  final CharacterType type;
  final double size;

  const FarmCharacter({super.key, required this.type, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _AnimalPainter(type)),
    );
  }
}

class _AnimalPainter extends CustomPainter {
  final CharacterType type;
  _AnimalPainter(this.type);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = const Color(0xFF43A047);
    canvas.drawCircle(Offset(s.width / 2, s.height / 2), s.width / 2, p);
  }

  @override
  bool shouldRepaint(covariant _AnimalPainter oldDelegate) => oldDelegate.type != type;
}
