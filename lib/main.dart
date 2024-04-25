import 'dart:io';

import 'package:dalvi/features/admin/screens/admin_screen.dart';
import 'package:dalvi/features/auth/services/auth_service.dart';
import 'package:dalvi/features/home/screens/home_screen.dart';
import 'package:dalvi/firebase_options.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:dalvi/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Custom HTTP client that bypasses SSL certificate validation errors
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dalvi Farm',
      theme: ThemeData(
        // scaffoldBackgroundColor:Theme.of(context).scaffoldBackgroundColor,
        colorScheme: ColorScheme.light(
          primary: Colors.amber.shade300,
        ),
        scaffoldBackgroundColor: Colors.white,
        // primaryColor: Colors.amber.shade300,

        primaryTextTheme: const TextTheme(
          headline1: TextStyle(color: Colors.black),
        ),

        // highlightColor: Colors.red,
        // hintColor: Colors.red,
        primaryColorDark: Colors.white,
        primaryColorLight: Colors.black,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.amber[300],
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings, context),
      home: Scaffold(
          body: userProvider.user.type == "admin"
              ? const AdminScreen()
              : const HomeScreen()),
    );
  }
}
