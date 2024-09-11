// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiUrl = 'http://172.16.45.24:8000';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// Home Screen (Main Page)
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 2; // Default to Home
  Map<String, dynamic>? _powerData;
  Map<String, dynamic>? _weatherData;

  final List<Widget> _pages = [
    SettingsScreen(),
    WeatherScreen(),
    HomeScreenContent(),
    DataAnalyticsScreen(),
    MaintenanceScreen(), // Reintegrated MaintenanceScreen
  ];

  void _onBottomNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 2) {
        _fetchHomeData(); // Fetch data for HomeScreenContent
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchHomeData(); // Initial data fetch
  }

  Future<void> _fetchHomeData() async {
    try {
      final powerData = await fetchPowerData();
      final weatherData = await fetchWeatherData();
      setState(() {
        _powerData = powerData;
        _weatherData = weatherData;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey[500],
        currentIndex: _currentIndex,
        onTap: _onBottomNavBarTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thermostat),
            label: 'Weather',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber_rounded),
            label: 'Maintenance',
          ),
        ],
      ),
    );
  }
}

//mport 'package:flutter/material.dart';

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _HomeScreenState state =
        context.findAncestorStateOfType<_HomeScreenState>()!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Solar Vert',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: state._powerData == null || state._weatherData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Jaz,',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            child: _buildStatCard('Generated',
                                '${state._powerData!['generated']} kWh')),
                        const SizedBox(width: 16),
                        Expanded(
                            child: _buildStatCard(
                                'Left', '${state._powerData!['left']} kWh',
                                isBig: true)),
                        const SizedBox(width: 16),
                        Expanded(
                            child: _buildStatCard('Consumed',
                                '${state._powerData!['consumed']} kWh')),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                'Power Generated',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: MediaQuery.of(context).size.width / 2.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Generated Power Graph',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                'Power Consumed',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: MediaQuery.of(context).size.width / 2.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Consumed Power Graph',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: _buildStatCard('Generated', '5.0 kWh')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Left', '1.5 kWh', isBig: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Consumed', '3.5 kWh')),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Power Generated',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: MediaQuery.of(context).size.width / 2.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Generated Power Graph',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Power Consumed',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: MediaQuery.of(context).size.width / 2.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Consumed Power Graph',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Predicted Power Generation',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: MediaQuery.of(context).size.width / 2.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Predicted Power Generation Graph',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          'Predicted Power Consumed',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: MediaQuery.of(context).size.width / 2.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Predicted Power Consumed Graph',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, {bool isBig = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD

// Weather Screen
class WeatherScreen extends StatelessWidget {
  Future<Map<String, dynamic>> fetchWeatherData() async {
    final response = await http.get(Uri.parse('$apiUrl/weather_advice/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
=======
// Weather Screen
class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? _weatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final weatherData = await fetchWeatherData();
      setState(() {
        _weatherData = weatherData;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
<<<<<<< HEAD
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Weather',
=======
      body: _weatherData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.wb_sunny,
                            size: 80, color: Colors.yellow),
                        const SizedBox(height: 16),
                        Text(
                          _weatherData!['weather'] ?? 'Sunny',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_weatherData!['temperature']}°C',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.water_drop,
                                size: 24, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'Rainfall: ${_weatherData!['rainfall']}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud,
                                size: 24, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Humidity: ${_weatherData!['humidity']}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // 10-Day Forecast and other widgets
                ],
              ),
            ),
    );
  }
}

// Data Analytics Screen
class DataAnalyticsScreen extends StatefulWidget {
  @override
  _DataAnalyticsScreenState createState() => _DataAnalyticsScreenState();
}

class _DataAnalyticsScreenState extends State<DataAnalyticsScreen> {
  Map<String, dynamic>? _analyticsData;

  @override
  void initState() {
    super.initState();
    _fetchAnalyticsData('weekly'); // Fetch weekly data by default
  }

  Future<void> _fetchAnalyticsData(String period) async {
    try {
      final analyticsData = await fetchAnalyticsData(period);
      setState(() {
        _analyticsData = analyticsData;
      });
    } catch (e) {
      print('Error fetching analytics data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Data Analytics',
>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
<<<<<<< HEAD
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchWeatherData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weather Data',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
=======
      backgroundColor: Colors.white,
      body: _analyticsData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Weekly Power Analytics',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Display graphs or charts here
                  Container(
                    height: MediaQuery.of(context).size.width / 2.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Analytics Graph',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
                  ),
                ),
                const SizedBox(height: 16),
                // Display weather data here
                Text('data:${data['suggestion']['current']['temp_c']}'),
                Text('Temperature: ${data['temp_c'] ?? 'N/A'}'),
                Text('Humidity: ${data['humidity'] ?? 'N/A'}'),
              ],
            ),
<<<<<<< HEAD
          );
        },
      ),
=======
>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
    );
  }
}

// Maintenance Screen
class MaintenanceScreen extends StatelessWidget {
<<<<<<< HEAD
  Future<Map<String, dynamic>> fetchMaintenanceData() async {
    final response = await http.get(Uri.parse('$apiUrl/maintenance_data/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load maintenance data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
=======
  @override
  Widget build(BuildContext context) {
    return Scaffold(
>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Maintenance',
          style: TextStyle(
            color: Colors.white,
<<<<<<< HEAD
            fontSize: 22,
=======
            fontSize: 20,
>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
<<<<<<< HEAD
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchMaintenanceData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Maintenance Data',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Display maintenance data here
                Text('Last Check: ${data['last_check'] ?? 'N/A'}'),
                Text('Next Check: ${data['next_check'] ?? 'N/A'}'),
              ],
            ),
          );
        },
=======
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'Maintenance Screen Content',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
      ),
    );
  }
}

// Data Analytics Screen
class DataAnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Center(child: Text('Data Analytics Content')),
    );
  }
}

// Settings Screen
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
<<<<<<< HEAD
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.purple),
              title: const Text('Profile', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to Profile Screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.purple),
              title: const Text('Notifications', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to Notifications Settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.palette, color: Colors.purple),
              title: const Text('Theme', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to Theme Settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.purple),
              title: const Text('Help & Support', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to Help & Support
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.purple),
              title: const Text('Logout', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Handle Logout
              },
            ),
          ],
=======
      body: const Center(
        child: Text(
          'Settings Screen Content',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
>>>>>>> d55e2b7c3e17076f517d175048a5396dd0d79323
        ),
      ),
    );
  }
}
