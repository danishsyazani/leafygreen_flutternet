import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:leafygreen_flutternet/providers/auth_provider.dart';
import 'package:leafygreen_flutternet/providers/post_provider.dart';
import 'package:leafygreen_flutternet/providers/user_provider.dart';
import 'package:leafygreen_flutternet/screens/home/splash_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (context) => GroupTileState()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: MaterialApp(
        title: 'Login with Shared Preferences',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
      ),
    );
  }
}
