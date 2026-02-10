import 'package:flutter/material.dart';
// import 'package:mini_app/screens/home.dart';
import 'package:mini_app/screens/login_page.dart';
// import 'package:mini_app/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://xgipsqbocibabxvklwke.supabase.co', 
    anonKey: 'sb_publishable_2vitqpvQze_cG119DhKmkg_wFkPxHh4',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

