
import 'package:flutter/material.dart';

void main() => runApp(const AhirApp());

class Animal {
  String tag, name, species, breed, gender, birth;
  Animal({
    required this.tag,
    required this.name,
    required this.species,
    required this.breed,
    required this.gender,
    required this.birth,
  });
}

class AhirApp extends StatelessWidget {
  const AhirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AHIR',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF2E7D32),
        scaffoldBackgroundColor: const Color(0xFFF6F8F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F8F5),
          elevation: 0,
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

  final animals = <Animal>[
    Animal(
      tag: 'TR 01 123456',
      name: 'Boncuk',
      species: 'Büyükbaş',
      breed: 'Simental',
      gender: 'Dişi',
      birth: '12.04.2024',
    ),
  ];

  final breeds = <String>[
    'Simental', 'Holstein', 'Montofon', 'Jersey', 'Angus',
    'Hereford', 'Limuzin', 'Şarole', 'Belçika Mavisi',
    'Yerli Kara', 'Boz Irk', 'Güney Anadolu Kırmızısı',
    'Akkaraman', 'Merinos', 'İvesi', 'Kıvırcık',
    'Karayaka', 'Sakız', 'Romanov', 'Ankara Keçisi',
  ];

  final titles = [
    'AHIR',
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
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFE4F2E5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.pets, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(width: 10),
            Text(
              titles[page],
              style: const TextStyle(fontWeight: FontWeight.w800),
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
      body: IndexedStack(
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
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: [0, 1, 2, 3].contains(page) ? page : 0,
        onDestinationSelected: (i) => setState(() => page = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.pets_outlined), selectedIcon: Icon(Icons.pets), label: 'Hayvanlar'),
          NavigationDestination(icon: Icon(Icons.category_outlined), selectedIcon: Icon(Icons.category), label: 'Irklar'),
          NavigationDestination(icon: Icon(Icons.medical_services_outlined), selectedIcon: Icon(Icons.medical_services), label: 'Sağlık'),
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

  Widget _dashboard() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
      children: [
        _hero(),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _miniStat('${animals.length}', 'Hayvan', Icons.pets)),
            const SizedBox(width: 10),
            Expanded(child: _miniStat('${breeds.length}', 'Irk', Icons.category)),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Hayvancılığını kolaylaştır',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
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
        _notice(Icons.vaccines, 'Aşı Takibi', 'Yaklaşan aşılar burada görünecek.'),
        _notice(Icons.event, 'Doğum / Gebelik', 'Yaklaşan doğum ve kontroller.'),
        _notice(Icons.notifications_active, 'Hatırlatmalar', 'Önemli işlemleri kaçırma.'),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('AHIR',
                    style: TextStyle(
                      color: Colors.white, fontSize: 30,
                      fontWeight: FontWeight.w900,
                    )),
                SizedBox(height: 4),
                Text('Akıllı Hayvancılık Yönetimi',
                    style: TextStyle(color: Colors.white70, fontSize: 15)),
                SizedBox(height: 16),
                Text('Çiftliğin cebindeki yardımcısı.',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const FarmCharacter(type: CharacterType.cow, size: 108),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label, IconData icon) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE4F2E5),
              child: Icon(icon, color: const Color(0xFF2E7D32)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                Text(label, style: TextStyle(color: Colors.grey.shade700)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _tile(String title, IconData icon, int target) {
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => setState(() => page = target),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color(0xFFE4F2E5),
              child: Icon(icon, color: const Color(0xFF2E7D32), size: 28),
            ),
            const SizedBox(height: 9),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  Widget _notice(IconData icon, String title, String subtitle) {
    return Card(
      elevation: 0,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE4F2E5),
          child: Icon(icon, color: const Color(0xFF2E7D32)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _sectionTitle(String s) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(s, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
  );

  Widget _animals() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: FilledButton.icon(
            style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
            onPressed: _addAnimal,
            icon: const Icon(Icons.add),
            label: const Text('Yeni Hayvan Ekle'),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: animals.length,
            itemBuilder: (_, i) {
              final a = animals[i];
              return Card(
                elevation: 0,
                child: ListTile(
                  leading: const FarmCharacter(type: CharacterType.cow, size: 54),
                  title: Text(a.tag, style: const TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: Text('${a.breed} • ${a.gender} • ${a.birth}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) {
                      if (v == 'detail') _animalDetail(a);
                      if (v == 'delete') setState(() => animals.removeAt(i));
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'detail', child: Text('Detay')),
                      PopupMenuItem(value: 'delete', child: Text('Sil')),
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
                TextField(controller: tag, decoration: const InputDecoration(labelText: 'Küpe No')),
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Adı')),
                TextField(controller: birth, decoration: const InputDecoration(labelText: 'Doğum tarihi')),
                DropdownButtonFormField<String>(
                  value: species,
                  decoration: const InputDecoration(labelText: 'Tür'),
                  items: const ['Büyükbaş', 'Koyun', 'Keçi'].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
                  onChanged: (v) => setD(() => species = v!),
                ),
                DropdownButtonFormField<String>(
                  value: breed,
                  decoration: const InputDecoration(labelText: 'Irk'),
                  items: breeds.map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
                  onChanged: (v) => setD(() => breed = v!),
                ),
                DropdownButtonFormField<String>(
                  value: gender,
                  decoration: const InputDecoration(labelText: 'Cinsiyet'),
                  items: const ['Dişi', 'Erkek'].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
                  onChanged: (v) => setD(() => gender = v!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('İptal')),
            FilledButton(
              onPressed: () {
                if (tag.text.trim().isEmpty) return;
                setState(() => animals.add(Animal(
                  tag: tag.text.trim(),
                  name: name.text.trim(),
                  species: species,
                  breed: breed,
                  gender: gender,
                  birth: birth.text.trim(),
                )));
                Navigator.pop(ctx);
              },
              child: const Text('Kaydet'),
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
      builder: (_) => ListView(
        padding: const EdgeInsets.all(22),
        shrinkWrap: true,
        children: [
          Row(
            children: [
              const FarmCharacter(type: CharacterType.cow, size: 76),
              const SizedBox(width: 14),
              Text(a.tag, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Adı: ${a.name.isEmpty ? "-" : a.name}'),
          Text('Tür: ${a.species}'),
          Text('Irk: ${a.breed}'),
          Text('Cinsiyet: ${a.gender}'),
          Text('Doğum: ${a.birth.isEmpty ? "-" : a.birth}'),
          const Divider(height: 30),
          const ListTile(leading: Icon(Icons.vaccines), title: Text('Aşı geçmişi'), subtitle: Text('Kayıt eklenmedi')),
          const ListTile(leading: Icon(Icons.healing), title: Text('Tedavi geçmişi'), subtitle: Text('Kayıt eklenmedi')),
          const ListTile(leading: Icon(Icons.local_drink), title: Text('Süt kayıtları'), subtitle: Text('Kayıt eklenmedi')),
        ],
      ),
    );
  }

  Widget _breeds() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Irk Kataloğu', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
        ),
        const Card(
          elevation: 0,
          child: ListTile(
            leading: FarmCharacter(type: CharacterType.sheep, size: 58),
            title: Text('Koyun ırkları'),
            subtitle: Text('Akkaraman, Merinos, İvesi, Kıvırcık ve daha fazlası'),
          ),
        ),
        const Card(
          elevation: 0,
          child: ListTile(
            leading: FarmCharacter(type: CharacterType.goat, size: 58),
            title: Text('Keçi ırkları'),
            subtitle: Text('Süt ve et yönlü keçi ırkları'),
          ),
        ),
        ...breeds.map((b) => Card(
          elevation: 0,
          child: ListTile(
            leading: const Icon(Icons.pets),
            title: Text(b),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _breedDetail(b),
          ),
        )),
      ],
    );
  }

  void _breedDetail(String b) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(b),
        content: const Text(
          'Irk bilgi kartı.\n\n'
          'İlerleyen sürümde bu alana ırk özellikleri, verim yönü, '
          'ortalama canlı ağırlık, yetiştirme notları ve görsel bilgiler eklenecek.',
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Kapat'))],
      ),
    );
  }

  Widget _health() => _modulePage([
    _module('Aşı Kayıtları', Icons.vaccines, 'Aşı, tarih ve tekrar zamanı ekle.'),
    _module('Hastalık / Tedavi', Icons.healing, 'Hastalık ve tedavi geçmişini tut.'),
    _module('İlaçlar', Icons.medication, 'İlaç ve uygulama kayıtlarını yönet.'),
    _module('Hatırlatmalar', Icons.notifications_active, 'Yaklaşan işlemleri kaçırma.'),
  ]);

  Widget _milk() => _modulePage([
    _module('Süt Kaydı Ekle', Icons.add, 'Hayvan bazında günlük süt kaydı.'),
    _module('Süt Verimi', Icons.show_chart, 'Günlük ve aylık verimleri incele.'),
    _module('Sağım Takvimi', Icons.calendar_month, 'Sağım planını takip et.'),
  ]);

  Widget _ration() => _modulePage([
    _module('Yemler', Icons.grass, 'Yem ve stoklarını yönet.'),
    _module('Rasyon Oluştur', Icons.calculate, 'Hayvan grupları için rasyon planla.'),
    _module('Yem Stoku', Icons.inventory_2, 'Giriş, tüketim ve kalan stok.'),
  ]);

  Widget _reports() => _modulePage([
    _module('Sürü Raporu', Icons.pets, 'Hayvan ve sürü özeti.'),
    _module('Sağlık Raporu', Icons.medical_services, 'Aşı ve tedavi kayıtları.'),
    _module('Süt Raporu', Icons.local_drink, 'Süt verim raporları.'),
    _module('Excel / PDF', Icons.file_download, 'Dışa aktarma altyapısı.'),
  ]);

  Widget _settings() => _modulePage([
    _module('İşletme Bilgileri', Icons.business, 'İşletme ayarlarını düzenle.'),
    _module('Bildirimler', Icons.notifications, 'Hatırlatma ayarları.'),
    _module('Yedekleme', Icons.backup, 'Veri yedekleme altyapısı.'),
    _module('AHIR Hakkında', Icons.info_outline, 'AHIR Akıllı Hayvancılık Yönetimi.'),
  ]);

  Widget _modulePage(List<Widget> items) => ListView(
    padding: const EdgeInsets.all(16),
    children: items,
  );

  Widget _module(String title, IconData icon, String subtitle) => Card(
    elevation: 0,
    child: ListTile(
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE4F2E5),
        child: Icon(icon, color: const Color(0xFF2E7D32)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _coming(title),
    ),
  );

  void _coming(String title) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: const Text('Bu modülün veri kayıt ekranı bir sonraki geliştirme adımında aktif edilecek.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Tamam'))],
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
      width: size, height: size,
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
      canvas.drawOval(Rect.fromCenter(center: Offset(head.dx, head.dy + s.height*.06), width: s.width*.24, height: s.height*.13), p);
      p.color = const Color(0xFF795548);
      canvas.drawCircle(Offset(head.dx - s.width*.10, head.dy - s.height*.08), s.width*.055, p);
      canvas.drawCircle(Offset(head.dx + s.width*.10, head.dy - s.height*.02), s.width*.045, p);
    } else if (type == CharacterType.goat) {
      p.color = const Color(0xFF6D4C41);
      final horn = Path()
        ..moveTo(head.dx - s.width*.16, head.dy - s.height*.18)
        ..quadraticBezierTo(head.dx - s.width*.28, head.dy - s.height*.34, head.dx - s.width*.12, head.dy - s.height*.29)
        ..close();
      canvas.drawPath(horn, p);
      final horn2 = Path()
        ..moveTo(head.dx + s.width*.16, head.dy - s.height*.18)
        ..quadraticBezierTo(head.dx + s.width*.28, head.dy - s.height*.34, head.dx + s.width*.12, head.dy - s.height*.29)
        ..close();
      canvas.drawPath(horn2, p);
    }

    p.color = Colors.black;
    canvas.drawCircle(Offset(head.dx - s.width*.09, head.dy - s.height*.04), s.width*.025, p);
    canvas.drawCircle(Offset(head.dx + s.width*.09, head.dy - s.height*.04), s.width*.025, p);

    p.color = const Color(0xFFF5B5B5);
    canvas.drawCircle(Offset(head.dx, head.dy + s.height*.09), s.width*.08, p);

    p.color = const Color(0xFF4E342E);
    final smile = Path()
      ..moveTo(head.dx - s.width*.06, head.dy + s.height*.09)
      ..quadraticBezierTo(head.dx, head.dy + s.height*.14, head.dx + s.width*.06, head.dy + s.height*.09);
    canvas.drawPath(smile, outline);

    p.color = type == CharacterType.sheep ? const Color(0xFF795548) : const Color(0xFF5D4037);
    for (int i = -1; i <= 1; i++) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(c.dx + i*s.width*.18 - s.width*.035, c.dy+s.height*.20, s.width*.07, s.height*.16),
          Radius.circular(s.width*.03),
        ), p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _AnimalPainter oldDelegate) => oldDelegate.type != type;
}

class AhirAI extends StatefulWidget {
  const AhirAI({super.key});

  @override
  State<AhirAI> createState() => _AhirAIState();
}

class _AhirAIState extends State<AhirAI> {
  final input = TextEditingController();
  final messages = <Map<String, String>>[
    {
      'role': 'ai',
      'text': 'Merhaba! Ben AHIR AI 🤖🐄\nHayvan kayıtları, yem, süt, bakım ve çiftlik yönetimi konusunda sana yardımcı olabilirim.'
    }
  ];

  void ask() {
    final q = input.text.trim();
    if (q.isEmpty) return;

    String answer;
    final l = q.toLowerCase();

    if (l.contains('yem') || l.contains('rasyon')) {
      answer = 'Rasyon konusunda yardımcı olabilirim. Hayvan türü, yaşı, canlı ağırlığı ve üretim durumunu yazarsan daha uygun bir plan oluşturabiliriz.';
    } else if (l.contains('aşı') || l.contains('sağlık')) {
      answer = 'Sağlık kayıtlarını AHIR içinde hayvan bazında tutabiliriz. Aşı veya tedavi tarihlerini ekleyerek yaklaşan işlemler için hatırlatma oluşturabiliriz.';
    } else if (l.contains('süt')) {
      answer = 'Süt verimini günlük kaydedip aylık değişimi grafik olarak takip edebiliriz. Düşüşleri yorumlamak için hayvanın diğer kayıtlarını da birlikte değerlendirebiliriz.';
    } else if (l.contains('koyun') || l.contains('keçi')) {
      answer = 'Koyun ve keçiler de AHIR içinde ayrı tür olarak yönetilecek. Küpe, ırk, doğum, sağlık, üreme ve verim kayıtları eklenebilir.';
    } else {
      answer = 'Bunu AHIR AI ile birlikte değerlendirebiliriz. Sorunu biraz daha ayrıntılı yaz; hayvanın türü, yaşı ve mevcut kayıtları varsa ekle.';
    }

    setState(() {
      messages.add({'role': 'user', 'text': q});
      messages.add({'role': 'ai', 'text': answer});
      input.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF263238), Color(0xFF455A64)]),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            children: [
              Icon(Icons.auto_awesome, color: Colors.white, size: 34),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AHIR AI\nÇiftliğin akıllı yardımcısı',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (_, i) {
              final m = messages[i];
              final ai = m['role'] == 'ai';
              return Align(
                alignment: ai ? Alignment.centerLeft : Alignment.centerRight,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 330),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: ai ? Colors.white : const Color(0xFFE4F2E5),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(m['text']!),
                ),
              );
            },
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
                  onPressed: ask,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
