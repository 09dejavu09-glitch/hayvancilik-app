import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const AhirAiApp());
}

class AhirAiApp extends StatelessWidget {
  const AhirAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AHIR AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const AnaMenuSayfasi(),
    );
  }
}

class Hayvan {
  final String kupeNo;
  final String irk;
  final double gunlukSut;

  Hayvan({required this.kupeNo, required this.irk, required this.gunlukSut});
}

class AnaMenuSayfasi extends StatefulWidget {
  const AnaMenuSayfasi({super.key});

  @override
  State<AnaMenuSayfasi> createState() => _AnaMenuSayfasiState();
}

class _AnaMenuSayfasiState extends State<AnaMenuSayfasi> {
  int _seciliSayfa = 0;

  // Sürü Listesi
  final List<Hayvan> _hayvanlar = [
    Hayvan(kupeNo: 'TR-0123456789', irk: 'Holstein', gunlukSut: 28.5),
    Hayvan(kupeNo: 'TR-9876543210', irk: 'Simental', gunlukSut: 22.0),
  ];

  // Banner Reklam Alanı
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  final String _adUnitId = 'ca-app-pub-5164021814623973/3845061952';

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  // Yeni Hayvan Ekleme Penceresi (Dialog)
  void _yeniHayvanEkleDialogGoster() {
    final kupeController = TextEditingController();
    String secilenIrk = 'Holstein';
    final sutController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Büyükbaş Hayvan Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: kupeController,
                  decoration: const InputDecoration(labelText: 'Küpe No (Örn: TR-...)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: secilenIrk,
                  decoration: const InputDecoration(labelText: 'Irk Seçimi'),
                  items: ['Holstein', 'Simental', 'Montofon', 'Yerli Kara']
                      .map((irk) => DropdownMenuItem(value: irk, child: Text(irk)))
                      .toList(),
                  onChanged: (deger) {
                    if (deger != null) secilenIrk = deger;
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: sutController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Günlük Süt Miktarı (Litre)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              onPressed: () {
                if (kupeController.text.isNotEmpty) {
                  setState(() {
                    _hayvanlar.add(
                      Hayvan(
                        kupeNo: kupeController.text,
                        irk: secilenIrk,
                        gunlukSut: double.tryParse(sutController.text) ?? 0.0,
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> sayfalar = [
      _buildSuruSekmesi(),
      _buildSutTakipSekmesi(),
      _buildIrkRehberiSekmesi(),
      _buildAiAsistanSekmesi(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('AHIR AI - Akıllı Sürü Yönetimi', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: sayfalar[_seciliSayfa]),
          // Uygulama altındaki Banner Reklam Alanı
          if (_isAdLoaded && _bannerAd != null)
            Container(
              alignment: Alignment.center,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _seciliSayfa,
        onTap: (index) => setState(() => _seciliSayfa = index),
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Sürü'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Süt Takip'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Irk Rehberi'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI Asistan'),
        ],
      ),
    );
  }

  // 1. SÜRÜ YÖNETİMİ SEKMESİ
  Widget _buildSuruSekmesi() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Toplam Hayvan: ${_hayvanlar.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: _yeniHayvanEkleDialogGoster,
                icon: const Icon(Icons.add),
                label: const Text('Hayvan Ekle'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _hayvanlar.length,
              itemBuilder: (context, index) {
                final hayvan = _hayvanlar[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: const Icon(Icons.pets, color: Colors.green),
                    ),
                    title: Text('Küpe No: ${hayvan.kupeNo}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Irk: ${hayvan.irk} | Günlük Süt: ${hayvan.gunlukSut} Litre'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        setState(() {
                          _hayvanlar.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 2. SÜT TAKİP SEKMESİ
  Widget _buildSutTakipSekmesi() {
    double toplamGunlukSut = _hayvanlar.fold(0.0, (toplam, h) => toplam + h.gunlukSut);
    double toplamAylikSut = toplamGunlukSut * 30;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Süt Verimi Özeti', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Günlük Toplam Süt:', style: TextStyle(fontSize: 16)),
                      Text('${toplamGunlukSut.toStringAsFixed(1)} Litre', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Aylık Tahmini Süt:', style: TextStyle(fontSize: 16)),
                      Text('${toplamAylikSut.toStringAsFixed(1)} Litre', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. TÜRKİYE IRKLARI REHBERİ
  Widget _buildIrkRehberiSekmesi() {
    final List<Map<String, String>> irklar = [
      {'isim': 'Holstein', 'ozellik': 'Yüksek süt verimi ile tanınır, siyah-beyaz alacadır.'},
      {'isim': 'Simental', 'ozellik': 'Hem et hem süt verimi yüksek (kombine), adaptasyon yeteneği güçlüdür.'},
      {'isim': 'Montofon (Brown Swiss)', 'ozellik': 'Sütünün yağ ve protein oranı yüksek, dağlık koşullara dayanıklıdır.'},
      {'isim': 'Yerli Kara / Doğu Anadolu Kırmızısı', 'ozellik': 'Türkiye yerli ırkları, zorlu iklim ve bakım şartlarına son derece dayanıklıdır.'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: irklar.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(irklar[index]['isim']!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
            subtitle: Text(irklar[index]['ozellik']!),
            leading: const Icon(Icons.info_outline, color: Colors.green),
          ),
        );
      },
    );
  }

  // 4. AI ASİSTAN SEKMESİ
  Widget _buildAiAsistanSekmesi() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Merhaba! Ben AHIR AI Asistanınız.\nSürü sağlığı, rasyon besleme ve süt verimi artırma konularında sorularınızı bekliyorum.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Veterinerlik veya bakım ile ilgili bir şeyler sorun...',
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.green),
                onPressed: () {},
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}
