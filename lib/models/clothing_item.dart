import 'package:flutter/material.dart';

class ClothingItem {
  final String id;
  final String name;
  final String category; // Camisas, Calças, Casacos, Acessórios, Vestidos, Calçados
  final String subcategory;
  final String color; // Preto, Branco, Azul, Vermelho, Verde, Bege, Rosa, Cinza, Marrom
  final String season; // Primavera, Verão, Outono, Inverno, Todas
  final String occasion; // Casual, Formal, Esportivo, Festa
  final String brand;
  final double price;
  final String material;
  final String? imagePath; // Path to local file or URL/asset
  final DateTime createdAt;

  ClothingItem({
    required this.id,
    required this.name,
    required this.category,
    this.subcategory = '',
    required this.color,
    this.season = 'Todas',
    this.occasion = 'Casual',
    this.brand = '',
    this.price = 0.0,
    this.material = '',
    this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'subcategory': subcategory,
      'color': color,
      'season': season,
      'occasion': occasion,
      'brand': brand,
      'price': price,
      'material': material,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      subcategory: json['subcategory'] ?? '',
      color: json['color'],
      season: json['season'] ?? 'Todas',
      occasion: json['occasion'] ?? 'Casual',
      brand: json['brand'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      material: json['material'] ?? '',
      imagePath: json['imagePath'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  /// Maps color name to actual Flutter Color object for badges & circles
  Color get colorDisplayValue {
    switch (color.toLowerCase().trim()) {
      case 'preto':
        return const Color(0xFF1A1A1A);
      case 'branco':
        return const Color(0xFFFAFAFA);
      case 'azul':
        return const Color(0xFF4A6FA5);
      case 'vermelho':
        return const Color(0xFFC85A5A);
      case 'verde':
        return const Color(0xFF5A7D5A);
      case 'bege':
        return const Color(0xFFD1C7BD);
      case 'rosa':
        return const Color(0xFFE0B0B0);
      case 'cinza':
        return const Color(0xFF808080);
      case 'marrom':
        return const Color(0xFF795548);
      default:
        return const Color(0xFF808080);
    }
  }
}
