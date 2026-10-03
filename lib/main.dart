import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  // Flutter altyapısının hazır olmasını sağla
  WidgetsFlutterBinding.ensureInitialized();
  
  // Google AdMob SDK'sını başlat (Uygulamanın açılışta çökmesini önler)
  await MobileAds.instance.initialize();

  runApp(const AhirApp());
}

class AhirApp extends StatelessWidget {
  const AhirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AHIR AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
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
        title: const Text('AHIR AI'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'AHIR AI Uygulamasına Hoş Geldiniz!\n\nUygulamanız başarıyla çalışıyor.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
