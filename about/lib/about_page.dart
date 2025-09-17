import 'package:core/core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();
    _logScreenView();
    _logCustomEvent('risto-event-aboutPage');
  }

  Future<void> _logScreenView() async {
    await analytics.logScreenView(
      screenName: 'AboutPage-Risto',
      screenClass: 'AboutPageClass-Risto',
    );
  }

  Future<void> _logCustomEvent(String eventName) async {
    await analytics.logEvent(name: eventName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: kPrussianBlue,
                  child: Center(
                    child: Image.asset('assets/circle-g.png', width: 128),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  color: Colors.white,
                  child: Text(
                    'Risto merupakan sebuah aplikasi katalog film yang dikembangkan oleh CodeSynesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}
