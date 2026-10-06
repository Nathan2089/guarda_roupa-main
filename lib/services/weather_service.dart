import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const Map<String, Map<String, double>> cityCoordinates = {
    'São Paulo': {'lat': -23.5505, 'lon': -46.6333},
    'Rio de Janeiro': {'lat': -22.9068, 'lon': -43.1729},
    'Brasília': {'lat': -15.7975, 'lon': -47.8919},
    'Belo Horizonte': {'lat': -19.9167, 'lon': -43.9345},
    'Salvador': {'lat': -12.9777, 'lon': -38.5016},
    'Curitiba': {'lat': -25.4284, 'lon': -49.2733},
    'Porto Alegre': {'lat': -30.0346, 'lon': -51.2177},
    'Recife': {'lat': -8.0476, 'lon': -34.8770},
    'Fortaleza': {'lat': -3.7319, 'lon': -38.5267},
    'Florianópolis': {'lat': -27.5954, 'lon': -48.5480},
  };

  static Future<Map<String, double>?> _getCoordinatesForCity(String cityName) async {
    if (cityCoordinates.containsKey(cityName)) {
      return cityCoordinates[cityName];
    }

    try {
      final geoUrl = Uri.parse(
        'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(cityName)}&count=1&language=pt&format=json',
      );
      final response = await http.get(geoUrl).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['results'] != null && (data['results'] as List).isNotEmpty) {
          final first = data['results'][0];
          final double lat = (first['latitude'] as num).toDouble();
          final double lon = (first['longitude'] as num).toDouble();
          return {'lat': lat, 'lon': lon};
        }
      }
    } catch (_) {}

    return null;
  }

  static Future<WeatherModel> fetchWeatherForCity(String cityName) async {
    final cleanCity = cityName.trim().isEmpty ? 'São Paulo' : cityName.trim();
    final coords = await _getCoordinatesForCity(cleanCity) ?? cityCoordinates['São Paulo']!;
    final lat = coords['lat'];
    final lon = coords['lon'];

    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m&daily=uv_index_max&timezone=auto',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];
        final daily = data['daily'];

        final double temp = (current['temperature_2m'] as num).toDouble();
        final double apparentTemp = (current['apparent_temperature'] as num).toDouble();
        final int humidity = (current['relative_humidity_2m'] as num).toInt();
        final double wind = (current['wind_speed_10m'] as num).toDouble();
        final int code = (current['weather_code'] as num).toInt();
        final int uv = (daily != null && daily['uv_index_max'] != null && (daily['uv_index_max'] as List).isNotEmpty)
            ? (daily['uv_index_max'][0] as num).round()
            : 1;

        final conditionInfo = _mapWeatherCode(code, temp);

        return WeatherModel(
          city: cleanCity,
          tempC: temp.roundToDouble(),
          condition: conditionInfo['condition']!,
          tag: conditionInfo['tag']!,
          thermalSensation: apparentTemp.roundToDouble(),
          humidity: humidity,
          windSpeedKmH: wind.roundToDouble(),
          uvIndex: uv,
          textSuggestion: conditionInfo['suggestion']!,
        );
      }
    } catch (_) {
      // Fallback on timeout/offline
    }

    return WeatherModel(
      city: cleanCity,
      tempC: 22.0,
      condition: 'Agradável',
      tag: 'Ameno e Fresco',
      thermalSensation: 21.0,
      humidity: 65,
      windSpeedKmH: 10.0,
      uvIndex: 3,
      textSuggestion:
          'Hoje em $cleanCity é um ótimo dia para combinações leves e confortáveis. A temperatura amena favorece sobreposições elegantes.',
    );
  }

  static Map<String, String> _mapWeatherCode(int code, double temp) {
    String condition = 'Ensolarado';
    String tag = 'Ameno';
    String suggestion =
        'Dia equilibrado. Experimente um visual casual elegante com combinações confortáveis.';

    if (code == 0) {
      condition = 'Ensolarado';
      tag = 'Quente & Iluminado';
      suggestion =
          'O sol pede tecidos leves como algodão ou linho e cores claras para um look fresco e sofisticado.';
    } else if (code >= 1 && code <= 3) {
      condition = 'Parcialmente Nublado';
      if (temp < 18) {
        tag = 'Ameno e Fresco';
        suggestion =
            'Hoje é um ótimo dia para sobreposições leves de linho e tons terrosos. A brisa suave favorece cortes fluidos e tecidos respiráveis.';
      } else {
        tag = 'Agradável';
        suggestion =
            'Clima ideal para t-shirts básicas combinadas com calças de sarja ou jeans leves.';
      }
    } else if (code >= 45 && code <= 48) {
      condition = 'Nevoeiro';
      tag = 'Frio e Úmido';
      suggestion =
          'Aposte em jaquetas com textura, tricots confortáveis e calçados fechados.';
    } else if (code >= 51 && code <= 82) {
      condition = 'Chuvoso';
      tag = 'Úmido e Frio';
      suggestion =
          'Dia chuvoso: opte por casacos impermeáveis ou sobreposições quentes com botas e calçados resistentes.';
    } else if (code >= 95) {
      condition = 'Tempestade';
      tag = 'Instável';
      suggestion =
          'Clima fechado. Priorize conforto, casacos estruturados e calçados impermeáveis.';
    }

    if (temp >= 26) {
      tag = 'Calor Intenso';
      suggestion =
          'Dia quente! Escolha regatas, camisas curtas de linho, bermudas e acessórios de proteção solar.';
    } else if (temp <= 14) {
      tag = 'Frio Intenso';
      suggestion =
          'Dia frio! Combine casacos encorpados, cachecóis e sobreposições em camadas quentes.';
    }

    return {'condition': condition, 'tag': tag, 'suggestion': suggestion};
  }
}
