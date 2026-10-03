import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const SigirTakipApp());
}

class SigirTakipApp extends StatelessWidget {
  const SigirTakipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SığırTakip - Sürü Yönetimi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20), // Çiftlik temasına uygun yeşil
          brightness: Brightness.light,
        ),
      ),
      home: const AnaSayfa(),
    );
  }
}

// Hayvan Modeli
class Hayvan {
  final String kupeNo;
  final String irk;
  final String cinsiyet;
  final DateTime dogumTarihi;
  final String durum; // Sağmal, Kuru, Gebe, Besi
  final double sonSutLitre;

  Hayvan({
    required this.kupeNo,
    required this.irk,
    required this.cinsiyet,
    required this.dogumTarihi,
    required this.durum,
    this.sonSutLitre = 0.0,
  });

  int get yasAy => (DateTime.now().difference(dogumTarihi).inDays / 30).floor();
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _seciliSayfa = 0;

  // Örnek Sürü Verileri
  final List<Hayvan> _suru = [
    Hayvan(
      kupeNo: 'TR360001234567',
      irk: 'Simental',
      cinsiyet: 'Dişi',
      dogumTarihi: DateTime(2022, 03, 15),
      durum: 'Sağmal',
      sonSutLitre: 24.5,
    ),
    Hayvan(
      kupeNo: 'TR360001234568',
      irk: 'Holstein',
      cinsiyet: 'Dişi',
      dogumTarihi: DateTime(2021, 08, 10),
      durum: 'Gebe',
      sonSutLitre: 18.0,
    ),
    Hayvan(
      kupeNo: 'TR360001234569',
      irk: 'Montofon',
      cinsiyet: 'Erkek',
      dogumTarihi: DateTime(2023, 11, 01),
      durum: 'Besi',
      sonSutLitre: 0.0,
    ),
  ];

  void _yeniHayvanEkle(Hayvan hayvan) {
    setState(() {
      _suru.add(hayvan);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> sayfalar = [
      _buildOzetSekmesi(),
      _buildHayvanListesiSekmesi(),
      _buildSaglikTakvimSekmesi(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.pets, color: Colors.white),
            SizedBox(width: 8),
            Text('SığırTakip', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF1B5E20),
        elevation: 2,
      ),
      body: sayfalar[_seciliSayfa],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _hayvanEkleDiyaloguGoster(context),
        backgroundColor: const Color(0xFF1B5E20),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Hayvan Ekle', style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seciliSayfa,
        onDestinationSelected: (index) {
          setState(() {
            _seciliSayfa = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Özet'),
          NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'Sürü Listesi'),
          NavigationDestination(icon: Icon(Icons.medical_services_outlined), selectedIcon: Icon(Icons.medical_services), label: 'Sağlık & Aşı'),
        ],
      ),
    );
  }

  // Özet ve İstatistikler Sayfası
  Widget _buildOzetSekmesi() {
    final toplamHayvan = _suru.length;
    final sagmalSayisi = _suru.where((h) => h.durum == 'Sağmal').length;
    final gebeSayisi = _suru.where((h) => h.durum == 'Gebe').length;
    final toplamSut = _suru.fold(0.0, (sum, item) => sum + item.sonSutLitre);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sürü Genel Durumu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildKart('Toplam Hayvan', '$toplamHayvan Adet', Icons.groups, Colors.blue),
              _buildKart('Günlük Süt', '${toplamSut.toStringAsFixed(1)} Litre', Icons.water_drop, Colors.cyan),
              _buildKart('Sağmal Sığır', '$sagmalSayisi Adet', Icons.agriculture, Colors.green),
              _buildKart('Gebe Hayvan', '$gebeSayisi Adet', Icons.child_care, Colors.orange),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Aşı & Kontrol Uyarıları', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            color: Colors.amber.shade50,
            child: const ListTile(
              leading: Icon(Icons.warning_amber_rounded, color: Colors.orange),
              title: Text('Şap Aşısı Zamanı Yaklaşıyor'),
              subtitle: Text('Sürüdeki 3 hayvanın son aşı tarihi üzerinden 6 ay geçti.'),
            ),
          ),
        ],
      ),
    );
  }

  // Hayvan Listesi Sayfası
  Widget _buildHayvanListesiSekmesi() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _suru.length,
      itemBuilder: (context, index) {
        final hayvan = _suru[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF1B5E20),
              child: Text(hayvan.cinsiyet == 'Dişi' ? '♀' : '♂', style: const TextStyle(color: Colors.white, fontSize: 18)),
            ),
            title: Text(hayvan.kupeNo, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${hayvan.irk} • ${hayvan.durum} • ${hayvan.yasAy} Aylık'),
            trailing: hayvan.sonSutLitre > 0
                ? Chip(
                    label: Text('${hayvan.sonSutLitre} L'),
                    avatar: const Icon(Icons.local_drink, size: 16),
                    backgroundColor: Colors.blue.shade50,
                  )
                : null,
          ),
        );
      },
    );
  }

  // Sağlık Takvim Sayfası
  Widget _buildSaglikTakvimSekmesi() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        Text('Planlanan Sağlık İşlemleri', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        ListTile(
          leading: Icon(Icons.vaccines, color: Colors.red),
          title: Text('Brucella Aşı Taraması'),
          subtitle: Text('Tarih: 12 Ekim 2026 - Tüm Buzağılar'),
          trailing: Icon(Icons.chevron_right),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.health_and_safety, color: Colors.blue),
          title: Text('Periyodik Tırnak Bakımı'),
          subtitle: Text('Tarih: 20 Ekim 2026 - Sağmal Grubu'),
          trailing: Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildKart(String baslik, String deger, IconData ikon, Color renk) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(ikon, color: renk, size: 28),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            Text(baslik, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            const SizedBox(height: 2),
            Text(deger, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // Yeni Hayvan Ekleme Form Modalı
  void _hayvanEkleDiyaloguGoster(BuildContext context) {
    final kupeController = TextEditingController();
    final irkController = TextEditingController();
    String seciliDurum = 'Sağmal';
    String seciliCinsiyet = 'Dişi';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                top: 16,
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Yeni Hayvan Kaydı', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: kupeController,
                    decoration: const InputDecoration(labelText: 'Küpe Numarası (Örn: TR36...)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: irkController,
                    decoration: const InputDecoration(labelText: 'Irkı (Simental, Holstein vb.)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: seciliCinsiyet,
                          decoration: const InputDecoration(labelText: 'Cinsiyet', border: OutlineInputBorder()),
                          items: ['Dişi', 'Erkek'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setModalState(() => seciliCinsiyet = val!),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: seciliDurum,
                          decoration: const InputDecoration(labelText: 'Durum', border: OutlineInputBorder()),
                          items: ['Sağmal', 'Gebe', 'Kuru', 'Besi', 'Buzağı'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setModalState(() => seciliDurum = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
                      onPressed: () {
                        if (kupeController.text.isNotEmpty) {
                          _yeniHayvanEkle(
                            Hayvan(
                              kupeNo: kupeController.text,
                              irk: irkController.text.isEmpty ? 'Yerli / Melez' : irkController.text,
                              cinsiyet: seciliCinsiyet,
                              dogumTarihi: DateTime.now(),
                              durum: seciliDurum,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Kaydet', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
