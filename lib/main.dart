import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/Chapter/Chapter1/chapter1.dart';
import 'screens/Chapter/Chapter1/game/game1_1.dart';
import 'screens/Chapter/Chapter1/game/game1_2.dart';
import 'screens/Chapter/Chapter1/game/game1_3.dart';
import 'screens/Chapter/Chapter1/game/game1_4.dart';
import 'screens/Chapter/Chapter1/game/game1_5.dart';
import 'screens/Chapter/Chapter1/game/success1.dart';
import 'screens/assessment_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Dyscalculia Learning App',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => FutureBuilder<bool>(
          future: checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else if (snapshot.data == true) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/assessment': (context) => AssessmentScreen(),
        '/settings': (context) => SettingsScreen(),
        '/chapter1': (context) => Chapter1(),
        '/game1_1': (context) => Game1_1(),
        '/game1_2': (context) => Game1_2(),
        '/game1_3': (context) => Game1_3(),
        '/game1_4': (context) => Game1_4(),
        '/game1_5': (context) => Game1_5(),
        '/success1': (context) => Success1(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('Page not found: ${settings.name}'),
            ),
          ),
        );
      },
    );
  }

  Future<bool> checkLoginStatus() async {
    final token = await AuthService().getToken();
    return token != null;
  }
}
