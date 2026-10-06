import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'services/wardrobe_provider.dart';
import 'screens/login_screen.dart';
import 'screens/main_navigation_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WardrobeApp());
}

class WardrobeApp extends StatelessWidget {
  const WardrobeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WardrobeProvider()),
      ],
      child: Consumer<WardrobeProvider>(
        builder: (context, wardrobe, child) {
          return MaterialApp(
            title: 'WardrobeAI',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFFFDFBF7),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF1A1A1A),
                primary: const Color(0xFF1A1A1A),
                surface: const Color(0xFFFDFBF7),
              ),
              textTheme: GoogleFonts.interTextTheme(),
            ),
            home: wardrobe.isLoggedIn
                ? const MainNavigationScreen()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
