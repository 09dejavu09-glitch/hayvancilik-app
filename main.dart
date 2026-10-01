import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const AhirApp());
}

class AhirApp extends StatelessWidget {
  const AhirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ağırlık Ve Rasyon Hesaplama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _seciliIndeks = 0;

  final List<Widget> _sayfalar = const [
    AgirlikHesaplamaSayfasi(),
    RasyonHesaplamaSayfasi(),
    GecmisSayfasi(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sayfalar[_seciliIndeks],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _seciliIndeks,
        onDestinationSelected: (int index) {
          setState(() {
            _seciliIndeks = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Canlı Ağırlık',
          ),
          NavigationDestination(
            icon: Icon(Icons.rice_bowl_outlined),
            selectedIcon: Icon(Icons.rice_bowl),
            label: 'Rasyon',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Geçmiş',
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. CANLI AĞIRLIK HESAPLAMA SAYFASI
// -----------------------------------------------------------------------------
class AgirlikHesaplamaSayfasi extends StatefulWidget {
  const AgirlikHesaplamaSayfasi({super.key});

  @override
  State<AgirlikHesaplamaSayfasi> createState() => _AgirlikHesaplamaSayfasiState();
}

class _AgirlikHesaplamaSayfasiState extends State<AgirlikHesaplamaSayfasi> {
  final _gogusCevresiController = TextEditingController();
  final _vucutUzunluguController = TextEditingController();
  final _kupeNoController = TextEditingController();

  String _hayvanTuru = 'Sığır';
  String? _sonucKg;

  void _hesaplaVeKaydet() async {
    final double? gogus = double.tryParse(_gogusCevresiController.text);
    final double? uzunluk = double.tryParse(_vucutUzunluguController.text);

    if (gogus == null || gogus <= 0) {
      _hataGoster('Lütfen geçerli bir göğüs çevresi giriniz.');
      return;
    }

    double hesaplananAgirlik = 0;

    if (_hayvanTuru == 'Sığır') {
      if (uzunluk == null || uzunluk <= 0) {
        _hataGoster('Sığır ağırlık hesabı için vücut uzunluğu gereklidir.');
        return;
      }
      hesaplananAgirlik = ((gogus * gogus) * uzunluk) / 10840;
    } else {
      hesaplananAgirlik = (gogus * gogus * 11) / 1000;
    }

    setState(() {
      _sonucKg = hesaplananAgirlik.toStringAsFixed(1);
    });

    final prefs = await SharedPreferences.getInstance();
    List<String> gecmis = prefs.getStringList('gecmis_kayitlar') ?? [];
    
    String kupe = _kupeNoController.text.trim().isEmpty 
        ? 'Tanımsız' 
        : _kupeNoController.text.trim();
        
    String yeniKayit = '[$_hayvanTuru] Küpe: $kupe | Ağırlık: $_sonucKg kg | Tarih: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
    
    gecmis.add(yeniKayit);
    await prefs.setStringList('gecmis_kayitlar', gecmis);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hesaplama geçmişe kaydedildi.')),
      );
    }
  }

  void _hataGoster(String mesaj) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mesaj), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Ağırlık Hesaplama'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: const Text('Sığır / Dana'),
                      selected: _hayvanTuru == 'Sığır',
                      onSelected: (selected) {
                        if (selected) setState(() => _hayvanTuru = 'Sığır');
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Koyun / Keçi'),
                      selected: _hayvanTuru == 'Koyun',
                      onSelected: (selected) {
                        if (selected) setState(() => _hayvanTuru = 'Koyun');
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _kupeNoController,
              decoration: const InputDecoration(
                labelText: 'Küpe Numarası / İsim (Opsiyonel)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _gogusCevresiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Göğüs Çevresi (cm)',
                hintText: 'Örn: 180',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.straighten),
              ),
            ),
            if (_hayvanTuru == 'Sığır') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _vucutUzunluguController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Vücut Uzunluğu (cm)',
                  hintText: 'Örn: 150',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.straighten),
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _hesaplaVeKaydet,
              icon: const Icon(Icons.calculate),
              label: const Text('HESAPLA VE KAYDET'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            if (_sonucKg != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Tahmini Canlı Ağırlık',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_sonucKg kg',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. RASYON HESAPLAMA SAYFASI
// -----------------------------------------------------------------------------
class RasyonHesaplamaSayfasi extends StatefulWidget {
  const RasyonHesaplamaSayfasi({super.key});

  @override
  State<RasyonHesaplamaSayfasi> createState() => _RasyonHesaplamaSayfasiState();
}

class _RasyonHesaplamaSayfasiState extends State<RasyonHesaplamaSayfasi> {
  final _canliAgirlikController = TextEditingController(text: '500');
  final _sutVerimiController = TextEditingController(text: '20');

  double _toplamKM = 0;
  double _hamProteinIhtiyaci = 0;

  void _rasyonHesapla() {
    final double ca = double.tryParse(_canliAgirlikController.text) ?? 0;
    final double sut = double.tryParse(_sutVerimiController.text) ?? 0;

    setState(() {
      _toplamKM = (ca * 0.025) + (sut * 0.1);
      _hamProteinIhtiyaci = (ca * 0.8) + (sut * 85);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rasyon İhtiyaç Hesaplayıcı'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _canliAgirlikController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Canlı Ağırlık (kg)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monitor_weight),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _sutVerimiController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Günlük Süt Verimi (Litre)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.water_drop),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _rasyonHesapla,
              child: const Text('İHTİYAÇLARI HESAPLA'),
            ),
            const SizedBox(height: 20),
            if (_toplamKM > 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Günlük Tahmini İhtiyaçlar:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.grass, color: Colors.green),
                        title: const Text('Kuru Madde Tüketimi (KM)'),
                        trailing: Text(
                          '${_toplamKM.toStringAsFixed(2)} kg/gün',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.fitness_center, color: Colors.orange),
                        title: const Text('Ham Protein İhtiyacı'),
                        trailing: Text(
                          '${_hamProteinIhtiyaci.toStringAsFixed(0)} gram/gün',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. GEÇMİŞ KAYITLAR SAYFASI
// -----------------------------------------------------------------------------
class GecmisSayfasi extends StatefulWidget {
  const GecmisSayfasi({super.key});

  @override
  State<GecmisSayfasi> createState() => _GecmisSayfasiState();
}

class _GecmisSayfasiState extends State<GecmisSayfasi> {
  List<String> _gecmis = [];

  @override
  void initState() {
    super.initState();
    _gecmisYukle();
  }

  void _gecmisYukle() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _gecmis = prefs.getStringList('gecmis_kayitlar') ?? [];
    });
  }

  void _gecmisiTemizle() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('gecmis_kayitlar');
    setState(() {
      _gecmis.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geçmiş Kayıtlar'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: _gecmis.isEmpty ? null : _gecmisiTemizle,
            tooltip: 'Geçmişi Temizle',
          ),
        ],
      ),
      body: _gecmis.isEmpty
          ? const Center(
              child: Text(
                'Henüz kaydedilmiş bir hesaplama yok.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _gecmis.length,
              itemBuilder: (context, index) {
                final kayit = _gecmis[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(kayit),
                  ),
                );
              },
            ),
    );
  }
}
