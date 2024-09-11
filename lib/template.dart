// ignore_for_file: avoid_print, always_declare_return_types

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// ignore: unused_import

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
    });
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

class HomeScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                  const SizedBox(height: 32),
                  // Predicted Power Generation and Consumed
                  const Text(
                    'Predicted Power Generation: 4.8 kWh',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Predicted Power Consumed: 3.2 kWh',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

// Weather Screen
class WeatherScreen extends StatelessWidget {
  Future<Map<String, dynamic>> fetchWeatherData() async {
    final response = await http.get(Uri.parse('$apiUrl/weather_advice/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Weather Forecast',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
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
          // Check if the icon URL is present in the API response
          String currentIconUrl = data['suggestion']['current']['condition']['icon'];
          if (currentIconUrl.isEmpty) {
            print('Icon URL is empty');
            return const Center(child: Text('Icon URL is empty'));
          }
          return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Weather Forecast
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
                      Image.network(
                        'https:${currentIconUrl}', // Using Image.network
                        width: 80,
                        height: 80,
                      ),
                  const SizedBox(height: 16),
                  Text(
                    '${data['suggestion']['current']['condition']['text']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${data['suggestion']['current']['temp_c']}',
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
                      const Icon(Icons.water_drop, size: 24, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Rainfall: ${data['suggestion']['current']['precip_mm']}',
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
                      const Icon(Icons.cloud, size: 24, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Humidity: ${data['suggestion']['current']['humidity']}',
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
            // 10-Day Forecast
                const Text(
                  '10-Day Forecast',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: data['suggestion']['forecast']['forecastday'].length - 1,
                    itemBuilder: (context, index) {
                      final forecastDay = data['suggestion']['forecast']['forecastday'][index + 1];
                      final forecastIconUrl = forecastDay['day']['condition']['icon'];

                      return SizedBox(
                        width: 200, // Adjust width as needed
                        height: 80, // Adjust height as needed
                        child: Container(
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  'https:${forecastIconUrl}', // Using Image.network
                                  width: 40, // Increased icon size
                                  height: 40, // Increased icon size
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${forecastDay['date']}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16, // Adjust text size as needed
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${forecastDay['day']['avgtemp_c']} °C',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16, // Adjust text size as needed
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Rain: ${forecastDay['day']['totalprecip_mm']} mm',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16, // Adjust text size as needed
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
      }
      )
    );
  }
}





// Data Analytics Screen
class DataAnalyticsScreen extends StatefulWidget {
  @override
  _DataAnalyticsScreenState createState() => _DataAnalyticsScreenState();
}

class _DataAnalyticsScreenState extends State<DataAnalyticsScreen> {
  String _selectedPeriod = 'Day';
  List<Map<String, String>> _statsList = [];

  @override
  void initState() {
    super.initState();
    _updateDataForPeriod(_selectedPeriod);
  }

  void _updateDataForPeriod(String period) {
    // This is where you'd update your data based on the selected period
    setState(() {
      _statsList = List.generate(
        5,
        (index) => {
          'label': 'Stat ${index + 1}',
          'value': '${(index + 1) * 10} kWh',
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Analytics Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Date Range Selection
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTabButton('Day'),
                  _buildTabButton('Week'),
                  _buildTabButton('Month'),
                ],
              ),
            ),

            // Graph Area
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width / 1.5, // Adjusted height for aspect ratio
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
                        'Graph for $_selectedPeriod', // Display Graph
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

            // Power Stats
            Expanded(
              child: ListView.builder(
                itemCount: _statsList.length,
                itemBuilder: (context, index) {
                  final stat = _statsList[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.grey[900],
                    child: ListTile(
                      title: Text(
                        '${stat['label']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${stat['value']}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String period) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedPeriod == period ? Colors.purple : Colors.grey[800],
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        setState(() {
          _selectedPeriod = period;
          _updateDataForPeriod(period);
        });
      },
      child: Text(
        period,
        style: const TextStyle(color: Colors.white),
      ),
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
        ),
      ),
    );
  }
}

// Maintenance Screen
class MaintenanceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Maintenance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Maintenance Status',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.warning, color: Colors.red),
                    title: Text('System Check'),
                    subtitle: Text('Last checked: 24 hours ago'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.refresh, color: Colors.orange),
                    title: Text('Pending Updates'),
                    subtitle: Text('4 updates pending'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.check_circle, color: Colors.green),
                    title: Text('Maintenance Completed'),
                    subtitle: Text('No pending maintenance tasks'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
