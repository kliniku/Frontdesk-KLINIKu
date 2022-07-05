import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frontdesk_kliniku/color.dart';
import 'package:frontdesk_kliniku/components/InputJadwalDokter.dart';
import 'package:frontdesk_kliniku/components/home.dart';
import 'package:frontdesk_kliniku/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Frontdesk KLINIKu',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor),
      ),
      home: const Home(),
    );
  }
}
