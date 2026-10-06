import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/clothing_item.dart';
import '../services/image_service.dart';
import '../services/wardrobe_provider.dart';

class AddPieceDialog extends StatefulWidget {
  const AddPieceDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => const AddPieceDialog(),
    );
  }

  @override
  State<AddPieceDialog> createState() => _AddPieceDialogState();
}

class _AddPieceDialogState extends State<AddPieceDialog> {
  String? _imagePath;
  final _nameController = TextEditingController();
  String _selectedCategory = 'Camisas';
  final _subcategoryController = TextEditingController();
  String _selectedColor = 'Preto';
  String _selectedSeason = 'Primavera';
  String _selectedOccasion = 'Casual';
  final _brandController = TextEditingController();
  final _priceController = TextEditingController();
  final _materialController = TextEditingController();

  final List<String> _categories = [
    'Camisas',
    'Calças',
    'Sapatos',
    'Casacos',
    'Acessórios',
    'Vestidos',
    'Calçados',
  ];

  final List<String> _colors = [
    'Preto',
    'Branco',
    'Azul',
    'Vermelho',
    'Verde',
    'Bege',
    'Rosa',
    'Cinza',
    'Marrom',
  ];

  final List<String> _seasons = [
    'Primavera',
    'Verão',
    'Outono',
    'Inverno',
    'Todas',
  ];

  final List<String> _occasions = [
    'Casual',
    'Formal',
    'Esportivo',
    'Festa',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _subcategoryController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _materialController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool camera) async {
    final path = camera
        ? await ImageService.takePhotoWithCamera()
        : await ImageService.pickImageFromGallery();

    if (path != null) {
      setState(() {
        _imagePath = path;
      });
    }
  }

  void _saveItem() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe o nome da peça.')),
      );
      return;
    }

    final priceVal = double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;

    final newItem = ClothingItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      subcategory: _subcategoryController.text.trim(),
      color: _selectedColor,
      season: _selectedSeason,
      occasion: _selectedOccasion,
      brand: _brandController.text.trim(),
      price: priceVal,
      material: _materialController.text.trim(),
      imagePath: _imagePath ?? 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500',
    );

    Provider.of<WardrobeProvider>(context, listen: false).addClothingItem(newItem);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Peça "${newItem.name}" adicionada com sucesso!'),
        backgroundColor: const Color(0xFF1A1A1A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 550),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 12, top: 16, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Adicionar Nova Peça',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF757575)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            // Form Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Photo Upload Area
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF9F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFE5E0D8),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          if (_imagePath != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: _imagePath!.startsWith('http')
                                  ? Image.network(_imagePath!, height: 120, width: 120, fit: BoxFit.cover)
                                  : Image.file(File(_imagePath!), height: 120, width: 120, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 10),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Color(0xFF757575), size: 28),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Arraste uma imagem ou clique para selecionar',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: const Color(0xFF555555),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Suporta JPG, PNG (máx. 5MB)',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0xFF999999),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () => _pickImage(false),
                                icon: const Icon(Icons.file_upload_outlined, size: 18),
                                label: const Text('Enviar Foto'),
                                style: _outlinedBtnStyle(),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: () => _pickImage(true),
                                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                                label: const Text('Tirar Foto'),
                                style: _outlinedBtnStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Field: Nome da Peça
                    _buildLabel('Nome da Peça'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _nameController,
                      decoration: _inputDecoration('Ex: Camisa Polo Azul'),
                    ),
                    const SizedBox(height: 14),

                    // Row: Categoria & Subcategoria
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Categoria'),
                              const SizedBox(height: 6),
                              _buildDropdown(
                                value: _selectedCategory,
                                items: _categories,
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedCategory = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Subcategoria'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _subcategoryController,
                                decoration: _inputDecoration('Ex: Polo, Social...'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Row: Cor & Estação
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Cor'),
                              const SizedBox(height: 6),
                              _buildDropdown(
                                value: _selectedColor,
                                items: _colors,
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedColor = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Estação'),
                              const SizedBox(height: 6),
                              _buildDropdown(
                                value: _selectedSeason,
                                items: _seasons,
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedSeason = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Row: Ocasião & Marca
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Ocasião'),
                              const SizedBox(height: 6),
                              _buildDropdown(
                                value: _selectedOccasion,
                                items: _occasions,
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedOccasion = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Marca'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _brandController,
                                decoration: _inputDecoration('Ex: Zara, Nike...'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Row: Preço (R$) & Material
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Preço (R\$)'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _priceController,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: _inputDecoration('Ex: 199.90'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('Material / Tecido'),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _materialController,
                                decoration: _inputDecoration('Ex: algodão pima...'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF0EBE1),
                      foregroundColor: const Color(0xFF1A1A1A),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _saveItem,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Salvar Peça'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A1A1A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF444444),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: const Color(0xFFAAAAB2), fontSize: 13),
      filled: true,
      fillColor: const Color(0xFFFBF9F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E0D8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE5E0D8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1A1A1A), width: 1.5),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E0D8)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF1A1A1A)),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  ButtonStyle _outlinedBtnStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF1A1A1A),
      side: const BorderSide(color: Color(0xFFD0C9BE)),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
    );
  }
}
