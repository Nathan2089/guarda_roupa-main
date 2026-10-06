import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/wardrobe_provider.dart';
import '../models/clothing_item.dart';

class OutfitBuilderScreen extends StatefulWidget {
  const OutfitBuilderScreen({super.key});

  @override
  State<OutfitBuilderScreen> createState() => _OutfitBuilderScreenState();
}

class _OutfitBuilderScreenState extends State<OutfitBuilderScreen> {
  String _inventoryCategory = 'Todos'; // Todos, Superior, Inferior, Calçados, Acessórios
  String _inventorySearch = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categoryTabs = [
    'Todos',
    'Superior',
    'Inferior',
    'Calçados',
    'Acessórios',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _saveOutfit(BuildContext context, WardrobeProvider provider) {
    if (provider.slotUpper == null &&
        provider.slotLower == null &&
        provider.slotShoes == null &&
        provider.slotAccessory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos uma peça para o outfit.')),
      );
      return;
    }

    final nameController = TextEditingController(text: 'Look Casual');
    String selectedOccasion = 'Casual';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSt) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text('Salvar Outfit', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome da combinação:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Ex: Look Reunião',
                      filled: true,
                      fillColor: const Color(0xFFFBF9F5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Ocasião:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedOccasion,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFFBF9F5),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    items: ['Casual', 'Formal', 'Esportivo', 'Festa'].map((oc) {
                      return DropdownMenuItem(value: oc, child: Text(oc));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setSt(() => selectedOccasion = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A1A1A),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    provider.saveCurrentOutfit(nameController.text, selectedOccasion);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Outfit salvo com sucesso!'),
                        backgroundColor: Color(0xFF1A1A1A),
                      ),
                    );
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WardrobeProvider>(context);

    // Inventory filtering for the bottom section
    final inventoryItems = provider.allItems.where((item) {
      if (_inventorySearch.isNotEmpty) {
        final q = _inventorySearch.toLowerCase();
        if (!item.name.toLowerCase().contains(q) && !item.category.toLowerCase().contains(q)) {
          return false;
        }
      }

      if (_inventoryCategory == 'Superior') {
        return item.category == 'Camisas' || item.category == 'Casacos' || item.category == 'Vestidos';
      } else if (_inventoryCategory == 'Inferior') {
        return item.category == 'Calças';
      } else if (_inventoryCategory == 'Calçados') {
        return item.category == 'Calçados' || item.category == 'Sapatos';
      } else if (_inventoryCategory == 'Acessórios') {
        return item.category == 'Acessórios';
      }

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Montar Outfit',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Combine suas peças para criar looks incríveis',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF888888),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => provider.clearOutfitSlots(),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFF0EBE1),
                          foregroundColor: const Color(0xFF1A1A1A),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          'Limpar',
                          style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () => _saveOutfit(context, provider),
                        icon: const Icon(Icons.save_outlined, size: 16),
                        label: const Text('Salvar Outfit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 4 Layout Slots Grid
              Row(
                children: [
                  Expanded(
                    child: _buildSlotCard(
                      context: context,
                      title: '↑ Parte Superior',
                      item: provider.slotUpper,
                      hintText: 'Arraste uma peça aqui',
                      onClear: () => provider.setSlotUpper(null),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSlotCard(
                      context: context,
                      title: '↓ Parte Inferior',
                      item: provider.slotLower,
                      hintText: 'Arraste uma peça aqui',
                      onClear: () => provider.setSlotLower(null),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _buildSlotCard(
                      context: context,
                      title: '👟 Calçados',
                      item: provider.slotShoes,
                      hintText: 'Arraste um calçado aqui',
                      onClear: () => provider.setSlotShoes(null),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSlotCard(
                      context: context,
                      title: '💎 Acessórios',
                      item: provider.slotAccessory,
                      hintText: 'Arraste acessórios aqui',
                      onClear: () => provider.setSlotAccessory(null),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Bottom Inventory Section Card
              Container(
                padding: const EdgeInsets.all(18),
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
                    Text(
                      'Seu Inventário',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Search Input
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F6F1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE8E3DA)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => setState(() => _inventorySearch = val),
                        decoration: InputDecoration(
                          hintText: 'Buscar peça...',
                          hintStyle: GoogleFonts.inter(color: const Color(0xFFAAAAB2), fontSize: 13),
                          prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF888888)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category Filter Pills
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categoryTabs.map((tab) {
                          final isSelected = _inventoryCategory == tab;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(tab),
                              selected: isSelected,
                              onSelected: (_) => setState(() => _inventoryCategory = tab),
                              selectedColor: const Color(0xFF1A1A1A),
                              backgroundColor: const Color(0xFFF0EBE1),
                              labelStyle: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : const Color(0xFF444444),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Items Horizontal/Grid List
                    if (inventoryItems.isEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Center(
                          child: Text(
                            'Nenhuma peça encontrada',
                            style: TextStyle(color: Color(0xFF888888), fontSize: 13),
                          ),
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        height: 130,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: inventoryItems.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = inventoryItems[index];
                            return _buildInventoryItemCard(item, provider);
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlotCard({
    required BuildContext context,
    required String title,
    required ClothingItem? item,
    required String hintText,
    required VoidCallback onClear,
  }) {
    return Container(
      height: 170,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEAE2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              if (item != null)
                GestureDetector(
                  onTap: onClear,
                  child: const Icon(Icons.close, size: 16, color: Color(0xFF888888)),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF9F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE8E3DA),
                  style: item == null ? BorderStyle.solid : BorderStyle.none,
                ),
              ),
              child: item == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          hintText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFFA09A8F),
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              color: Colors.black.withOpacity(0.75),
                              child: Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryItemCard(ClothingItem item, WardrobeProvider provider) {
    return GestureDetector(
      onTap: () {
        // Auto-assign item to appropriate slot based on category
        final cat = item.category;
        if (cat == 'Camisas' || cat == 'Casacos' || cat == 'Vestidos') {
          provider.setSlotUpper(item);
        } else if (cat == 'Calças') {
          provider.setSlotLower(item);
        } else if (cat == 'Calçados' || cat == 'Sapatos') {
          provider.setSlotShoes(item);
        } else if (cat == 'Acessórios') {
          provider.setSlotAccessory(item);
        } else {
          provider.setSlotUpper(item);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} adicionado ao outfit!'),
            duration: const Duration(seconds: 1),
            backgroundColor: const Color(0xFF1A1A1A),
          ),
        );
      },
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: const Color(0xFFFBF9F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E0D8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: item.imagePath != null
                    ? item.imagePath!.startsWith('http')
                        ? Image.network(item.imagePath!, width: 100, fit: BoxFit.cover)
                        : Image.file(File(item.imagePath!), width: 100, fit: BoxFit.cover)
                    : const Icon(Icons.checkroom, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    item.category,
                    style: GoogleFonts.inter(fontSize: 9, color: const Color(0xFF777777)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
