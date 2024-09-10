import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl =
    'http://your_backend_url/api'; // Replace with your backend URL

Future<Map<String, dynamic>> fetchPowerData() async {
  final response = await http.get(Uri.parse('$apiUrl/power_data'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load power data');
  }
}

Future<Map<String, dynamic>> fetchWeatherData() async {
  final response = await http.get(Uri.parse('$apiUrl/weather_data'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<Map<String, dynamic>> fetchAnalyticsData(String period) async {
  final response =
      await http.get(Uri.parse('$apiUrl/analytics_data?period=$period'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load analytics data');
  }
}
