class WeatherResponse {
  final List<Weather> weather;
  final Main main; // جعلناه غير nullable لتسهيل التعامل في الـ UI
  final String name;

  WeatherResponse({
    required this.weather,
    required this.main,
    required this.name,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      weather: (json['weather'] as List? ?? [])
          .map((item) => Weather.fromJson(item))
          .toList(),
      main: json['main'] != null
          ? Main.fromJson(json['main'])
          : Main(temp: 0.0, pressure: 0, humidity: 0),
      name: json['name'] ?? '',
    );
  }
}

class Weather {
  final String description;
  final String icon;

  Weather({required this.description, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}

class Main {
  final double temp;
  final int pressure;
  final int humidity;

  Main({required this.temp, required this.pressure, required this.humidity});

  factory Main.fromJson(Map<String, dynamic> json) {
    return Main(
      temp: (json['temp'] as num).toDouble(),
      pressure: json['pressure'] as int,
      humidity: json['humidity'] as int,
    );
  }
}
