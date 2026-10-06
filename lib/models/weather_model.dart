class WeatherModel {
  final String city;
  final double tempC;
  final String condition;
  final String tag;
  final double thermalSensation;
  final int humidity;
  final double windSpeedKmH;
  final int uvIndex;
  final String textSuggestion;

  WeatherModel({
    required this.city,
    required this.tempC,
    required this.condition,
    required this.tag,
    required this.thermalSensation,
    required this.humidity,
    required this.windSpeedKmH,
    required this.uvIndex,
    required this.textSuggestion,
  });

  factory WeatherModel.initial() {
    return WeatherModel(
      city: 'São Paulo',
      tempC: 15.0,
      condition: 'Nublado',
      tag: 'Ameno e Fresco',
      thermalSensation: 11.0,
      humidity: 87,
      windSpeedKmH: 9.0,
      uvIndex: 1,
      textSuggestion:
          'Hoje é um ótimo dia para sobreposições leves de linho e tons terrosos. A brisa suave favorece cortes fluidos e tecidos respiráveis.',
    );
  }
}
