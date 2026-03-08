import 'package:flutter/material.dart';
// استبدل المسارات التالية بمسارات مشروعك الحقيقية
import 'package:basic_store_app/model/weatherResponseModel.dart';
import 'package:basic_store_app/remote/apiService.dart';
import 'package:basic_store_app/remote/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();

  // متغيرات الحالة
  bool _isLoading = false;
  String? _errorMessage;
  WeatherResponse? _weatherData;

  // دالة جلب البيانات
  void _getWeather() async {
    if (_cityController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // نداء الـ Singleton باستخدام await
      final data = await ApiService.api.weahterResponse(
        cityName: _cityController.text,
      );

      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _weatherData = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: const Text('🌤️ Weather Now'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSearchSection(),
            const SizedBox(height: 20),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            if (_weatherData != null && !_isLoading) ...[
              _buildMainWeatherCard(),
              const SizedBox(height: 25),
              _buildDetailsCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _cityController,
            decoration: InputDecoration(
              hintText: 'Enter city name...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: Colors.white,
            ),
            onSubmitted: (_) => _getWeather(),
          ),
        ),
        const SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: Colors.blueAccent,
          radius: 28,
          child: IconButton(
            icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            onPressed: _getWeather,
          ),
        ),
      ],
    );
  }

  Widget _buildMainWeatherCard() {
    // استخدام ! للوصول للبيانات لأننا تأكدنا أنها ليست Null في الـ build
    final temp = _weatherData!.main.temp.toInt();
    final desc = _weatherData!.weather.isNotEmpty
        ? _weatherData!.weather[0].description
        : "No Description";
    final icon = _weatherData!.weather.isNotEmpty
        ? _weatherData!.weather[0].icon
        : "";

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            Text(
              _weatherData!.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            if (icon.isNotEmpty)
              Image.network(
                'https://openweathermap.org/img/wn/$icon@2x.png',
                width: 120,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
              ),

            const SizedBox(height: 10),
            Text(
              '$temp°C',
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.w200,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              desc.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _weatherDetailItem(
              icon: Icons.water_drop,
              title: "Humidity",
              value: "${_weatherData!.main.humidity}%",
            ),
            Container(height: 40, width: 1, color: Colors.grey.shade300),
            _weatherDetailItem(
              icon: Icons.compress,
              title: "Pressure",
              value: "${_weatherData!.main.pressure} hPa",
            ),
          ],
        ),
      ),
    );
  }

  Widget _weatherDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
