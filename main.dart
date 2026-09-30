import 'package:flutter/material.dart';

void main() {
  runApp(const HayvancilikApp());
}

class HayvancilikApp extends StatelessWidget {
  const HayvancilikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hayvancılık Asistanı',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: const AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatelessWidget {
  const AnaSayfa({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hayvancılık Asistanı',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // Hoş geldin kartı
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.pets,
                      size: 50,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hoş Geldiniz 👋',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Hayvanlarınızı kolayca takip edin.',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Menü
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [

                  _MenuKutusu(
                    ikon: Icons.pets,
                    baslik: 'Hayvanlar',
                    renk: Colors.green,
                  ),

                  _MenuKutusu(
                    ikon: Icons.restaurant,
                    baslik: 'Rasyon',
                    renk: Colors.orange,
                  ),

                  _MenuKutusu(
                    ikon: Icons.local_drink,
                    baslik: 'Süt Takibi',
                    renk: Colors.blue,
                  ),

                  _MenuKutusu(
                    ikon: Icons.medical_services,
                    baslik: 'Sağlık',
                    renk: Colors.red,
                  ),

                  _MenuKutusu(
                    ikon: Icons.pets_outlined,
                    baslik: 'Irklar',
                    renk: Colors.purple,
                  ),

                  _MenuKutusu(
                    ikon: Icons.bar_chart,
                    baslik: 'Raporlar',
                    renk: Colors.teal,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Hayvanlar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}

class _MenuKutusu extends StatelessWidget {
  final IconData ikon;
  final String baslik;
  final Color renk;

  const _MenuKutusu({
    required this.ikon,
    required this.baslik,
    required this.renk,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ikon,
              size: 45,
              color: renk,
            ),
            const SizedBox(height: 10),
            Text(
              baslik,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
