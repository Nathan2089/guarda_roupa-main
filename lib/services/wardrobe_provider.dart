import 'package:flutter/material.dart';
import '../models/clothing_item.dart';
import '../models/weather_model.dart';
import '../models/outfit.dart';
import 'weather_service.dart';

class WardrobeProvider extends ChangeNotifier {
  // Auth & Multi-User State
  bool _isLoggedIn = true;
  String _currentUserKey = 'usuario@wardrobe.ai';

  final Map<String, List<ClothingItem>> _userWardrobes = {};
  final Map<String, List<Outfit>> _userSavedOutfits = {};
  final Map<String, String> _userNames = {};
  final Map<String, String> _userCities = {};

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userNames[_currentUserKey] ?? 'Usuário Demo';
  String get userCity => _userCities[_currentUserKey] ?? 'São Paulo';

  // Weather State
  WeatherModel _weather = WeatherModel.initial();
  bool _isLoadingWeather = false;

  WeatherModel get weather => _weather;
  bool get isLoadingWeather => _isLoadingWeather;

  // Inventory & Filter State
  String _searchQuery = '';
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedColors = {};
  final Set<String> _selectedSeasons = {};
  final Set<String> _selectedOccasions = {};

  String get searchQuery => _searchQuery;
  Set<String> get selectedCategories => _selectedCategories;
  Set<String> get selectedColors => _selectedColors;
  Set<String> get selectedSeasons => _selectedSeasons;
  Set<String> get selectedOccasions => _selectedOccasions;

  // Active Outfit Builder Slots
  ClothingItem? _slotUpper;
  ClothingItem? _slotLower;
  ClothingItem? _slotShoes;
  ClothingItem? _slotAccessory;

  ClothingItem? get slotUpper => _slotUpper;
  ClothingItem? get slotLower => _slotLower;
  ClothingItem? get slotShoes => _slotShoes;
  ClothingItem? get slotAccessory => _slotAccessory;

  // Current Active Wardrobe & Outfits getters
  List<ClothingItem> get _currentWardrobe => _userWardrobes[_currentUserKey] ?? [];
  List<Outfit> get _currentSavedOutfits => _userSavedOutfits[_currentUserKey] ?? [];

  List<ClothingItem> get allItems => List.unmodifiable(_currentWardrobe);
  List<Outfit> get savedOutfits => List.unmodifiable(_currentSavedOutfits);

  WardrobeProvider() {
    _initDefaultDemoUser();
    refreshWeather();
  }

  void _initDefaultDemoUser() {
    _currentUserKey = 'usuario@wardrobe.ai';
    _userNames[_currentUserKey] = 'Usuário Demo';
    _userCities[_currentUserKey] = 'São Paulo';
    _userWardrobes[_currentUserKey] = _createStarterWardrobe();
    _userSavedOutfits[_currentUserKey] = [];
  }

  List<ClothingItem> _createStarterWardrobe() {
    return [
      ClothingItem(
        id: '1',
        name: 'Camisa Linho Off-White',
        category: 'Camisas',
        subcategory: 'Linho / Manga Longa',
        color: 'Bege',
        season: 'Primavera',
        occasion: 'Casual',
        brand: 'Zara',
        price: 229.90,
        material: 'Linho 100%',
        imagePath: 'https://images.unsplash.com/photo-1598033129183-c4f50c736f10?w=500',
      ),
      ClothingItem(
        id: '2',
        name: 'Camisa Polo Marinho',
        category: 'Camisas',
        subcategory: 'Polo Slim',
        color: 'Azul',
        season: 'Verão',
        occasion: 'Casual',
        brand: 'Lacoste',
        price: 299.00,
        material: 'Algodão Pima',
        imagePath: 'https://images.unsplash.com/photo-1625910513413-5fc2814ba368?w=500',
      ),
      ClothingItem(
        id: '3',
        name: 'Calça Alfaiataria Bege',
        category: 'Calças',
        subcategory: 'Social / Chino',
        color: 'Bege',
        season: 'Outono',
        occasion: 'Formal',
        brand: 'Massimo Dutti',
        price: 349.90,
        material: 'Lã Leve',
        imagePath: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=500',
      ),
      ClothingItem(
        id: '4',
        name: 'Calça Jeans Premium',
        category: 'Calças',
        subcategory: 'Slim Fit',
        color: 'Preto',
        season: 'Inverno',
        occasion: 'Casual',
        brand: 'Levi\'s',
        price: 399.00,
        material: 'Algodão com Elastano',
        imagePath: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?w=500',
      ),
      ClothingItem(
        id: '5',
        name: 'Blazer Estruturado Chumbo',
        category: 'Casacos',
        subcategory: 'Blazer',
        color: 'Cinza',
        season: 'Inverno',
        occasion: 'Formal',
        brand: 'Aramis',
        price: 699.00,
        material: 'Lã Batida',
        imagePath: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=500',
      ),
      ClothingItem(
        id: '6',
        name: 'Mocassim Couro Marrom',
        category: 'Sapatos',
        subcategory: 'Loafer',
        color: 'Marrom',
        season: 'Todas',
        occasion: 'Formal',
        brand: 'Sergio K',
        price: 450.00,
        material: 'Couro Legítimo',
        imagePath: 'https://images.unsplash.com/photo-1614252235316-8c857d38b5f4?w=500',
      ),
      ClothingItem(
        id: '7',
        name: 'Tênis Urbano Minimalista',
        category: 'Calçados',
        subcategory: 'Sneaker',
        color: 'Branco',
        season: 'Todas',
        occasion: 'Casual',
        brand: 'Veja / Vert',
        price: 590.00,
        material: 'Couro Ecológico',
        imagePath: 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=500',
      ),
      ClothingItem(
        id: '8',
        name: 'Relógio Cronógrafo Clássico',
        category: 'Acessórios',
        subcategory: 'Relógio',
        color: 'Preto',
        season: 'Todas',
        occasion: 'Formal',
        brand: 'Seiko',
        price: 1200.00,
        material: 'Aço Inoxidável & Couro',
        imagePath: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=500',
      ),
    ];
  }

  // Multi-user login & isolation logic
  void loginUser(String name, String email, String city) {
    final key = email.trim().isEmpty ? 'usuario@wardrobe.ai' : email.trim().toLowerCase();
    _currentUserKey = key;

    _userNames[key] = name.trim().isEmpty ? 'Usuário' : name.trim();
    _userCities[key] = city.trim().isEmpty ? 'São Paulo' : city.trim();

    // If new user, create their isolated wardrobe
    if (!_userWardrobes.containsKey(key)) {
      _userWardrobes[key] = _createStarterWardrobe();
      _userSavedOutfits[key] = [];
    }

    _isLoggedIn = true;
    clearOutfitSlots();
    clearFilters();
    refreshWeather();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    clearOutfitSlots();
    clearFilters();
    notifyListeners();
  }

  void updateCity(String newCity) {
    _userCities[_currentUserKey] = newCity;
    refreshWeather();
    notifyListeners();
  }

  Future<void> refreshWeather() async {
    _isLoadingWeather = true;
    notifyListeners();

    _weather = await WeatherService.fetchWeatherForCity(userCity);

    _isLoadingWeather = false;
    notifyListeners();
  }

  // Filter methods
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleCategoryFilter(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void toggleColorFilter(String color) {
    if (_selectedColors.contains(color)) {
      _selectedColors.remove(color);
    } else {
      _selectedColors.add(color);
    }
    notifyListeners();
  }

  void toggleSeasonFilter(String season) {
    if (_selectedSeasons.contains(season)) {
      _selectedSeasons.remove(season);
    } else {
      _selectedSeasons.add(season);
    }
    notifyListeners();
  }

  void toggleOccasionFilter(String occasion) {
    if (_selectedOccasions.contains(occasion)) {
      _selectedOccasions.remove(occasion);
    } else {
      _selectedOccasions.add(occasion);
    }
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedCategories.clear();
    _selectedColors.clear();
    _selectedSeasons.clear();
    _selectedOccasions.clear();
    notifyListeners();
  }

  List<ClothingItem> get filteredItems {
    return _currentWardrobe.where((item) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesName = item.name.toLowerCase().contains(q);
        final matchesBrand = item.brand.toLowerCase().contains(q);
        final matchesSub = item.subcategory.toLowerCase().contains(q);
        if (!matchesName && !matchesBrand && !matchesSub) return false;
      }

      if (_selectedCategories.isNotEmpty) {
        final itemCat = item.category;
        bool matchesCat = _selectedCategories.contains(itemCat);
        if (!matchesCat && (_selectedCategories.contains('Sapatos') || _selectedCategories.contains('Calçados'))) {
          if (itemCat == 'Sapatos' || itemCat == 'Calçados') matchesCat = true;
        }
        if (!matchesCat) return false;
      }

      if (_selectedColors.isNotEmpty && !_selectedColors.contains(item.color)) {
        return false;
      }

      if (_selectedSeasons.isNotEmpty) {
        if (item.season != 'Todas' && !_selectedSeasons.contains(item.season)) {
          return false;
        }
      }

      if (_selectedOccasions.isNotEmpty && !_selectedOccasions.contains(item.occasion)) {
        return false;
      }

      return true;
    }).toList();
  }

  // Item Mutation Methods (User Isolated)
  void addClothingItem(ClothingItem item) {
    _currentWardrobe.insert(0, item);
    notifyListeners();
  }

  void deleteClothingItem(String id) {
    _currentWardrobe.removeWhere((item) => item.id == id);
    if (_slotUpper?.id == id) _slotUpper = null;
    if (_slotLower?.id == id) _slotLower = null;
    if (_slotShoes?.id == id) _slotShoes = null;
    if (_slotAccessory?.id == id) _slotAccessory = null;
    notifyListeners();
  }

  // Outfit Slot Methods
  void setSlotUpper(ClothingItem? item) {
    _slotUpper = item;
    notifyListeners();
  }

  void setSlotLower(ClothingItem? item) {
    _slotLower = item;
    notifyListeners();
  }

  void setSlotShoes(ClothingItem? item) {
    _slotShoes = item;
    notifyListeners();
  }

  void setSlotAccessory(ClothingItem? item) {
    _slotAccessory = item;
    notifyListeners();
  }

  void clearOutfitSlots() {
    _slotUpper = null;
    _slotLower = null;
    _slotShoes = null;
    _slotAccessory = null;
    notifyListeners();
  }

  void saveCurrentOutfit(String name, String occasion) {
    if (_slotUpper == null && _slotLower == null && _slotShoes == null && _slotAccessory == null) {
      return;
    }

    final outfitName = name.trim().isEmpty
        ? 'Look ${_currentSavedOutfits.length + 1}'
        : name.trim();

    final newOutfit = Outfit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: outfitName,
      upperItem: _slotUpper,
      lowerItem: _slotLower,
      shoesItem: _slotShoes,
      accessoryItem: _slotAccessory,
      occasion: occasion,
    );

    _currentSavedOutfits.insert(0, newOutfit);
    notifyListeners();
  }

  void deleteSavedOutfit(String outfitId) {
    _currentSavedOutfits.removeWhere((o) => o.id == outfitId);
    notifyListeners();
  }

  // AI Curation Recommendation
  List<ClothingItem> get aiSuggestedOutfit {
    final list = _currentWardrobe;
    ClothingItem? upper = list.cast<ClothingItem?>().firstWhere(
      (i) => i != null && (i.category == 'Camisas' || i.category == 'Casacos'),
      orElse: () => list.isNotEmpty ? list.first : null,
    );
    ClothingItem? lower = list.cast<ClothingItem?>().firstWhere(
      (i) => i != null && i.category == 'Calças',
      orElse: () => list.length > 2 ? list[2] : null,
    );

    final result = <ClothingItem>[];
    if (upper != null) result.add(upper);
    if (lower != null && lower != upper) result.add(lower);
    return result;
  }
}
