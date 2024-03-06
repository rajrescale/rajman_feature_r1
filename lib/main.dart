import 'package:dalvi/common/widgets/bottom_bar.dart';
import 'package:dalvi/constants/global_variables.dart';
import 'package:dalvi/features/admin/screens/admin_screen.dart';
import 'package:dalvi/features/auth/screens/auth_screen.dart';
import 'package:dalvi/features/auth/services/auth_service.dart';
import 'package:dalvi/providers/user_provider.dart';
import 'package:dalvi/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Dalvi Farm',
        theme: ThemeData(
            scaffoldBackgroundColor: GlobalVariables.backgroundColor,
            colorScheme: const ColorScheme.light(
              primary: GlobalVariables.secondaryColor,
            ),
            appBarTheme: const AppBarTheme(
                elevation: 0,
                backgroundColor: GlobalVariables.secondaryColor,
                iconTheme: IconThemeData(
                  color: Colors.black,
                ))),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: Scaffold(
          body: Provider.of<UserProvider>(context).user.token.isNotEmpty
              ? Provider.of<UserProvider>(context).user.type == "user"
                  ? const BottomBar()
                  : const AdminScreen()
              : const AuthScreen()),
    );
  }
}
