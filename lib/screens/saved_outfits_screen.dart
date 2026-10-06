import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/wardrobe_provider.dart';
import '../models/outfit.dart';

class SavedOutfitsScreen extends StatelessWidget {
  final VoidCallback onGoToBuilder;

  const SavedOutfitsScreen({
    super.key,
    required this.onGoToBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WardrobeProvider>(context);
    final saved = provider.savedOutfits;

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
                'Outfits Salvos',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Suas combinações salvas',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 36),

              if (saved.isEmpty) ...[
                const SizedBox(height: 40),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.star_outline_rounded,
                        size: 64,
                        color: Color(0xFFD0C9BE),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum outfit salvo ainda',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: onGoToBuilder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Montar primeiro outfit',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ] else ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: saved.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final outfit = saved[index];
                    return _buildOutfitCard(context, outfit, provider);
                  },
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOutfitCard(BuildContext context, Outfit outfit, WardrobeProvider provider) {
    final formattedDate = DateFormat('dd/MM/yyyy • HH:mm').format(outfit.createdAt);
    final items = outfit.items;

    return Container(
      padding: const EdgeInsets.all(16),
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    outfit.name,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$formattedDate • ${outfit.occasion}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: const Color(0xFF888888),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Color(0xFF999999)),
                onPressed: () {
                  provider.deleteSavedOutfit(outfit.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Outfit removido.')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Items Thumbnails Row
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, idx) {
                final item = items[idx];
                return Container(
                  width: 75,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F3EE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8E3DA)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            color: Colors.black.withOpacity(0.75),
                            child: Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Load into Builder button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                provider.setSlotUpper(outfit.upperItem);
                provider.setSlotLower(outfit.lowerItem);
                provider.setSlotShoes(outfit.shoesItem);
                provider.setSlotAccessory(outfit.accessoryItem);

                onGoToBuilder();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Look carregado no criador de outfits!'),
                    backgroundColor: Color(0xFF1A1A1A),
                  ),
                );
              },
              icon: const Icon(Icons.dry_cleaning_outlined, size: 16),
              label: const Text('Carregar Look'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1A1A1A),
                textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
