import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/wardrobe_provider.dart';
import '../models/clothing_item.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WardrobeProvider>(context);
    final weather = provider.weather;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header
              Text(
                'Dashboard',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Visão geral do seu guarda-roupa',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 20),

              // User Greeting Banner
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          'Bom dia, ',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          provider.userName,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        InkWell(
                          onTap: () => _showChangeCityDialog(context, provider),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(Icons.edit_outlined, size: 16, color: Color(0xFF757575)),
                          ),
                        ),
                        Text(
                          '• ${weather.tempC.round()}°C ${weather.city}, ${weather.condition}',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF666666),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFECE6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'HOJE',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF555555),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // AI Suggestion Text
              Text(
                weather.textSuggestion,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: const Color(0xFF555555),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),

              // Card 1: Clima de Hoje
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEEEAE2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Tag & Refresh Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EBE1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'CLIMA DE HOJE',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF444444),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => provider.refreshWeather(),
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: provider.isLoadingWeather
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1A1A1A)),
                                  )
                                : const Icon(Icons.refresh, size: 20, color: Color(0xFF757575)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Temperature display
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${weather.tempC.round()}',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            height: 0.9,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          '°',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              weather.city,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0EBE1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    weather.tag,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF333333),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  weather.condition,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF666666),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sensação térmica ${weather.thermalSensation.round()}°C',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF777777),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Weather details row (Humidity & Wind)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F2EC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.water_drop_outlined, color: Color(0xFF4A80D6), size: 22),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Umidade',
                                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF777777)),
                                    ),
                                    Text(
                                      '${weather.humidity}%',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F2EC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.air, color: Color(0xFF4A80D6), size: 22),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Vento',
                                      style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF777777)),
                                    ),
                                    Text(
                                      '${weather.windSpeedKmH.round()} km/h',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF1A1A1A),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // UV Index Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F2EC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Índice UV',
                                style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF777777)),
                              ),
                              Text(
                                '${weather.uvIndex}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1A1A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (weather.uvIndex / 10).clamp(0.1, 1.0),
                              minHeight: 6,
                              backgroundColor: const Color(0xFFE0DACF),
                              color: const Color(0xFF527853),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Card 2: Curatoria IA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFEEEAE2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'CURATORIA IA',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EBE1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'OTIMIZADO PARA O CLIMA',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF555555),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Outfit Sugerido • Reuniões Casuais & Trabalho',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Suggested Outfit Grid (2 Slots)
                    Row(
                      children: [
                        Expanded(
                          child: _buildSuggestedCard(
                            context,
                            provider.aiSuggestedOutfit.isNotEmpty
                                ? provider.aiSuggestedOutfit.first
                                : null,
                            'Parte Superior',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildSuggestedCard(
                            context,
                            provider.aiSuggestedOutfit.length > 1
                                ? provider.aiSuggestedOutfit[1]
                                : null,
                            'Parte Inferior',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestedCard(BuildContext context, ClothingItem? item, String slotTitle) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3EE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEBE5DB)),
      ),
      child: item == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.diamond_outlined,
                    size: 32,
                    color: Color(0xFF888888),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    slotTitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: item.imagePath != null
                        ? item.imagePath!.startsWith('http')
                            ? Image.network(item.imagePath!, fit: BoxFit.cover)
                            : Image.file(File(item.imagePath!), fit: BoxFit.cover)
                        : Container(color: const Color(0xFFECE6DD)),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${item.category} • ${item.color}',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: const Color(0xFFCCCCCC),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _showChangeCityDialog(BuildContext context, WardrobeProvider provider) {
    final controller = TextEditingController(text: provider.userCity);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Alterar Cidade', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Digite o nome da sua cidade (ex: Campinas)',
              hintStyle: GoogleFonts.inter(color: const Color(0xFFA0A0A0), fontSize: 13),
              filled: true,
              fillColor: const Color(0xFFFBF9F5),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E0D8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E0D8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A1A)),
              onPressed: () {
                final newCity = controller.text.trim();
                if (newCity.isNotEmpty) {
                  provider.updateCity(newCity);
                }
                Navigator.pop(ctx);
              },
              child: const Text('Atualizar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
