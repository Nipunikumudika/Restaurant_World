import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Configs/languageConfig.dart';
import 'Screens/logInScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    debugPrint("fb connection is completed");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale currentLang = Locale('en', 'US');
    return GetMaterialApp(
      title: 'Flutter Demo',
      translations: LanguageConfig(),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      locale: currentLang,
      fallbackLocale: Locale('en', 'US'),
      darkTheme: ThemeData.dark(),

      themeMode: ThemeMode.light,
      home: const LogInScreen(), //Screen widget //Screen widget
    );
  }
}
