import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/wardrobe_provider.dart';
import 'dashboard_screen.dart';
import 'wardrobe_screen.dart';
import 'outfit_builder_screen.dart';
import 'saved_outfits_screen.dart';
import 'add_piece_dialog.dart';
import 'login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WardrobeProvider>(context);

    final List<Widget> screens = [
      const DashboardScreen(),
      const WardrobeScreen(),
      const OutfitBuilderScreen(),
      SavedOutfitsScreen(
        onGoToBuilder: () {
          setState(() {
            _currentIndex = 2; // Navigate to "Montar Outfit" tab
          });
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.diamond, color: Color(0xFFFDFBF7), size: 16),
            ),
            const SizedBox(width: 8),
            Text(
              'WardrobeAI',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1A1A1A)),
            tooltip: 'Adicionar Peça',
            onPressed: () => AddPieceDialog.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Color(0xFF757575)),
            tooltip: 'Sair',
            onPressed: () {
              provider.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(top: BorderSide(color: Color(0xFFEEEAE2))),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF1A1A1A),
          unselectedItemColor: const Color(0xFF888888),
          selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_outlined),
              activeIcon: Icon(Icons.folder),
              label: 'Guarda-Roupa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dry_cleaning_outlined),
              activeIcon: Icon(Icons.dry_cleaning),
              label: 'Montar Outfit',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline_rounded),
              activeIcon: Icon(Icons.star_rounded),
              label: 'Salvos',
            ),
          ],
        ),
      ),
    );
  }
}
