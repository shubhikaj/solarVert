import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://172.16.45.24:8000';

Future<Map<String, dynamic>> fetchPowerData() async {
  final response = await http.get(Uri.parse('$baseUrl/power_data/1/')); // Adjust sensor_id as needed
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load power data');
  }
}

Future<Map<String, dynamic>> fetchWeatherData() async {
  final response = await http.get(Uri.parse('$baseUrl/weather_advice/'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<Map<String, dynamic>> fetchAnalyticsData(String period) async {
  final response = await http.get(Uri.parse('$baseUrl/predict_usage/?period=$period'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load analytics data');
  }
}
