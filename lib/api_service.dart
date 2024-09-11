import 'dart:convert';
import 'package:http/http.dart' as http;

<<<<<<< HEAD
const String baseUrl = 'http://172.16.45.24:8000';

Future<Map<String, dynamic>> fetchPowerData() async {
  final response = await http.get(Uri.parse('$baseUrl/power_data/1/')); // Adjust sensor_id as needed
=======
const String apiUrl =
    'http://your_backend_url/api'; // Replace with your backend URL

Future<Map<String, dynamic>> fetchPowerData() async {
  final response = await http.get(Uri.parse('$apiUrl/power_data'));

>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load power data');
  }
}

Future<Map<String, dynamic>> fetchWeatherData() async {
<<<<<<< HEAD
  final response = await http.get(Uri.parse('$baseUrl/weather_advice/'));
=======
  final response = await http.get(Uri.parse('$apiUrl/weather_data'));

>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load weather data');
  }
}

Future<Map<String, dynamic>> fetchAnalyticsData(String period) async {
<<<<<<< HEAD
  final response = await http.get(Uri.parse('$baseUrl/predict_usage/?period=$period'));
=======
  final response =
      await http.get(Uri.parse('$apiUrl/analytics_data?period=$period'));

>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load analytics data');
  }
}
