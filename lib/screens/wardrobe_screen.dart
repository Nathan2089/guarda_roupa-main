import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../services/wardrobe_provider.dart';
import '../models/clothing_item.dart';
import 'add_piece_dialog.dart';

class WardrobeScreen extends StatefulWidget {
  const WardrobeScreen({super.key});

  @override
  State<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isGridView = true;
  bool _isFilterExpanded = true;

  final List<String> _categories = [
    'Camisas',
    'Calças',
    'Sapatos',
    'Casacos',
    'Acessórios',
    'Vestidos',
    'Calçados',
  ];

  final List<Map<String, dynamic>> _colorDots = [
    {'name': 'Preto', 'color': const Color(0xFF1A1A1A)},
    {'name': 'Branco', 'color': const Color(0xFFFFFFFF)},
    {'name': 'Azul', 'color': const Color(0xFF4A6FA5)},
    {'name': 'Vermelho', 'color': const Color(0xFFC85A5A)},
    {'name': 'Verde', 'color': const Color(0xFF5A7D5A)},
    {'name': 'Bege', 'color': const Color(0xFFD1C7BD)},
    {'name': 'Rosa', 'color': const Color(0xFFE0B0B0)},
    {'name': 'Cinza', 'color': const Color(0xFF808080)},
    {'name': 'Marrom', 'color': const Color(0xFF795548)},
  ];

  final List<String> _seasons = ['Primavera', 'Verão', 'Outono', 'Inverno'];
  final List<String> _occasions = ['Casual', 'Formal', 'Esportivo', 'Festa'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WardrobeProvider>(context);
    final filtered = provider.filteredItems;

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
                'Meu Guarda-Roupa',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Todas as suas peças em um lugar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: const Color(0xFF888888),
                ),
              ),
              const SizedBox(height: 20),

              // Search & Add Button Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E0D8)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) => provider.setSearchQuery(val),
                        decoration: InputDecoration(
                          hintText: 'Buscar peças...',
                          hintStyle: GoogleFonts.inter(color: const Color(0xFFAAAAB2), fontSize: 13.5),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF888888), size: 20),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => AddPieceDialog.show(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Adicionar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Filters Panel Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => setState(() => _isFilterExpanded = !_isFilterExpanded),
                    child: Row(
                      children: [
                        Text(
                          'Filtros',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _isFilterExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _searchController.clear();
                      provider.clearFilters();
                    },
                    child: Text(
                      'Limpar',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFF888888),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              // Expandable Filter Section
              if (_isFilterExpanded) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEEEAE2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & Color side by side
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // CATEGORIA
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _filterSectionHeader('CATEGORIA'),
                                const SizedBox(height: 8),
                                ..._categories.map((cat) {
                                  final isChecked = provider.selectedCategories.contains(cat);
                                  return InkWell(
                                    onTap: () => provider.toggleCategoryFilter(cat),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isChecked
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            size: 18,
                                            color: isChecked
                                                ? const Color(0xFF1A1A1A)
                                                : const Color(0xFFB0AAA0),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            cat,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: const Color(0xFF333333),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),

                          // COR
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _filterSectionHeader('COR'),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _colorDots.map((cMap) {
                                    final name = cMap['name'] as String;
                                    final color = cMap['color'] as Color;
                                    final isSelected = provider.selectedColors.contains(name);

                                    return GestureDetector(
                                      onTap: () => provider.toggleColorFilter(name),
                                      child: Container(
                                        width: 26,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? const Color(0xFF1A1A1A)
                                                : const Color(0xFFD0C9BE),
                                            width: isSelected ? 2.5 : 1,
                                          ),
                                          boxShadow: isSelected
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.15),
                                                    blurRadius: 4,
                                                  )
                                                ]
                                              : null,
                                        ),
                                        child: isSelected && name == 'Branco'
                                            ? const Icon(Icons.check, size: 14, color: Colors.black)
                                            : isSelected
                                                ? const Icon(Icons.check, size: 14, color: Colors.white)
                                                : null,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Estação & Ocasião side by side
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ESTAÇÃO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _filterSectionHeader('ESTAÇÃO'),
                                const SizedBox(height: 8),
                                ..._seasons.map((st) {
                                  final isChecked = provider.selectedSeasons.contains(st);
                                  return InkWell(
                                    onTap: () => provider.toggleSeasonFilter(st),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isChecked
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            size: 18,
                                            color: isChecked
                                                ? const Color(0xFF1A1A1A)
                                                : const Color(0xFFB0AAA0),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            st,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: const Color(0xFF333333),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),

                          // OCASIÃO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _filterSectionHeader('OCASIÃO'),
                                const SizedBox(height: 8),
                                ..._occasions.map((oc) {
                                  final isChecked = provider.selectedOccasions.contains(oc);
                                  return InkWell(
                                    onTap: () => provider.toggleOccasionFilter(oc),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            isChecked
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            size: 18,
                                            color: isChecked
                                                ? const Color(0xFF1A1A1A)
                                                : const Color(0xFFB0AAA0),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            oc,
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              color: const Color(0xFF333333),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Items Count & View Mode Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filtered.length} peças',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xFF777777),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.grid_view_rounded,
                          color: _isGridView ? const Color(0xFF1A1A1A) : const Color(0xFFB0AAA0),
                        ),
                        onPressed: () => setState(() => _isGridView = true),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.view_list_rounded,
                          color: !_isGridView ? const Color(0xFF1A1A1A) : const Color(0xFFB0AAA0),
                        ),
                        onPressed: () => setState(() => _isGridView = false),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Inventory Display or Empty State
              if (filtered.isEmpty) ...[
                const SizedBox(height: 36),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F3EE),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE5E0D8),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: const Icon(Icons.add, size: 32, color: Color(0xFF888888)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma peça encontrada',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => AddPieceDialog.show(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A1A1A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Adicionar primeira peça',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ] else if (_isGridView) ...[
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.72,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _buildGridCard(context, item, provider);
                  },
                ),
              ] else ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _buildListTile(context, item, provider);
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

  Widget _filterSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1A1A1A),
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, ClothingItem item, WardrobeProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEAE2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFF6F3EE),
                    child: item.imagePath != null
                        ? item.imagePath!.startsWith('http')
                            ? Image.network(item.imagePath!, fit: BoxFit.cover)
                            : Image.file(File(item.imagePath!), fit: BoxFit.cover)
                        : const Center(child: Icon(Icons.checkroom, color: Colors.grey, size: 36)),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: item.colorDisplayValue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${item.category} • ${item.color}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF777777),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Delete button on top right
          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              onTap: () => _confirmDelete(context, item, provider),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, ClothingItem item, WardrobeProvider provider) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEAE2)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 50,
              height: 50,
              color: const Color(0xFFF6F3EE),
              child: item.imagePath != null
                  ? item.imagePath!.startsWith('http')
                      ? Image.network(item.imagePath!, fit: BoxFit.cover)
                      : Image.file(File(item.imagePath!), fit: BoxFit.cover)
                  : const Icon(Icons.checkroom, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  '${item.category} • ${item.color} • ${item.brand}',
                  style: GoogleFonts.inter(color: const Color(0xFF777777), fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFF999999)),
            onPressed: () => _confirmDelete(context, item, provider),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, ClothingItem item, WardrobeProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Excluir peça?', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        content: Text('Deseja realmente remover "${item.name}" do seu guarda-roupa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              provider.deleteClothingItem(item.id);
              Navigator.pop(ctx);
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
