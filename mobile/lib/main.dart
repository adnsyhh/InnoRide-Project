import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/promo_screen.dart';

void main() {
  runApp(const InnoRideApp());
}

class InnoRideApp extends StatelessWidget {
  const InnoRideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InnoRide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/analytics': (context) => const AnalyticsScreen(),
        '/promo': (context) => PromoScreen(),
        // '/register': (context) => const RegisterScreen(),
      },
    );
  }
}
