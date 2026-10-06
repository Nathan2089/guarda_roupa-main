import 'clothing_item.dart';

class Outfit {
  final String id;
  final String name;
  final ClothingItem? upperItem;
  final ClothingItem? lowerItem;
  final ClothingItem? shoesItem;
  final ClothingItem? accessoryItem;
  final String occasion;
  final DateTime createdAt;

  Outfit({
    required this.id,
    required this.name,
    this.upperItem,
    this.lowerItem,
    this.shoesItem,
    this.accessoryItem,
    this.occasion = 'Casual',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  List<ClothingItem> get items {
    final list = <ClothingItem>[];
    if (upperItem != null) list.add(upperItem!);
    if (lowerItem != null) list.add(lowerItem!);
    if (shoesItem != null) list.add(shoesItem!);
    if (accessoryItem != null) list.add(accessoryItem!);
    return list;
  }

  bool get isEmpty => upperItem == null && lowerItem == null && shoesItem == null && accessoryItem == null;
}
