import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiUrl = 'http://172.16.45.187:8000';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF121212),
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey[500],
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.purple),
      ),
      home: HomeScreen(),
    );
  }
}

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
    MaintenanceScreen(),
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
      appBar: AppBar(
        title: const Text(
          'Solar Vert',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Jaz,',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Stats
            _buildStats(context),
            const SizedBox(height: 32),
            _buildGraphCard(context, 'Power Generated', 'Generated Power Graph'),
            const SizedBox(height: 16),
            _buildGraphCard(context, 'Power Consumed', 'Consumed Power Graph'),
            const SizedBox(height: 32),
            // Place efficiency and battery health side by side
            _buildSideBySideStats(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Power Status',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 16),
        // Circular Progress Indicators for stats
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildProgressIndicator('Generated', '5.0 kWh', Colors.green, 0.7),
            _buildProgressIndicator('Left', '1.5 kWh', Colors.blue, 0.3),
            _buildProgressIndicator('Consumed', '3.5 kWh', Colors.red, 0.6),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(String label, String value, Color color, double progress) {
    return Column(
      children: [
        CircularProgressIndicator(
          value: progress,
          strokeWidth: 8,
          valueColor: AlwaysStoppedAnimation<Color>(color),
          backgroundColor: Colors.grey[800],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGraphCard(BuildContext context, String title, String graphText) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF212121),
        borderRadius: BorderRadius.circular(16),
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: MediaQuery.of(context).size.width / 2.5,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                graphText,
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
    );
  }

  Widget _buildSideBySideStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildEfficiencyAndBatteryCard('Efficiency', '75%', 0.75, context),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildEfficiencyAndBatteryCard('Battery Health', '85%', 0.85, context),
        ),
      ],
    );
  }

  Widget _buildEfficiencyAndBatteryCard(
      String label, String value, double progress, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF212121),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey[700],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}



class WeatherScreen extends StatelessWidget {
  Future<Map<String, dynamic>> fetchWeatherData() async {
    final response = await http.get(Uri.parse('$apiUrl/weather_advice/'));
    if (response.statusCode == 200) {
      print("API Response: ${response.body}"); // Debugging: Print API response
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
            fontSize: 22,
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
          
          // Check if forecast data is available
          if (data['suggestion'] == null ||
              data['suggestion']['forecast'] == null ||
              data['suggestion']['forecast']['forecastday'] == null ||
              data['suggestion']['forecast']['forecastday'].isEmpty) {
            return const Center(child: Text('No forecast data available'));
          }

          List forecastDays = data['suggestion']['forecast']['forecastday'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today's Weather Forecast
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.6),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.wb_sunny, size: 90, color: Colors.yellow),
                      const SizedBox(height: 18),
                      const Text(
                        'Sunny',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${data['suggestion']['current']['temp_c'] ?? 'N/A'}°C',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.water_drop, size: 28, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            'Rainfall: ${data['suggestion']['current']['precip_mm'] ?? 'N/A'} mm',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud, size: 28, color: Colors.grey),
                          const SizedBox(width: 10),
                          Text(
                            'Humidity: ${data['suggestion']['current']['humidity'] ?? 'N/A'}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: forecastDays.length, // Ensuring correct item count
                    itemBuilder: (context, index) {
                      var dayData = forecastDays[index]['day'];
                      return SizedBox(
                        width: 220,
                        height: 80,
                        child: Container(
                          margin: const EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  index % 2 == 0 ? Icons.wb_sunny : Icons.cloud,
                                  size: 30,
                                  color: Colors.yellow,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'D${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dayData != null && dayData['avgtemp_c'] != null
                                      ? '${dayData['avgtemp_c']}°C'
                                      : 'N/A',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dayData != null && dayData['totalprecip_mm'] != null
                                      ? 'Rain: ${dayData['totalprecip_mm']} mm'
                                      : 'N/A',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
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
        },
      ),
    );
  }
}



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
    // Simulate fetching data based on the selected period
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            const SliverAppBar(
              expandedHeight: 0,
              pinned: true,
              backgroundColor: Colors.black,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Analytics Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Date Range Selection Bar (Horizontal Scrollable)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: ['Day', 'Week', 'Month'].map((period) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPeriod = period;
                          _updateDataForPeriod(period);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: _selectedPeriod == period
                              ? Colors.purple
                              : Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          period,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Graph Area - Minimalistic and Clean
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.8, // Aspect ratio
                  color: Colors.grey[900],
                  child: Center(
                    child: Text(
                      'Graph for $_selectedPeriod', // Placeholder text for graph
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Power Stats List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final stat = _statsList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${stat['label']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${stat['value']}',
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: _statsList.length,
              ),
            ),
          ],
        ),
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
      backgroundColor: Colors.black,  // Set background to black to match the app theme
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildListTile(Icons.person, 'Profile', context),
            _buildListTile(Icons.notifications, 'Notifications', context),
            _buildListTile(Icons.palette, 'Theme', context),
            _buildListTile(Icons.help, 'Help & Support', context),
            _buildListTile(Icons.logout, 'Logout', context),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.grey[900],  // Dark background for each card
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,  // White text for contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // Handle navigation or actions for each ListTile
          // Example: Navigate to corresponding screen
        },
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
      backgroundColor: Colors.black,  // Dark background to match the app theme
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Maintenance Status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Maintenance status card
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],  // Dark background to match the app theme
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
                  _buildMaintenanceTile(Icons.warning, 'System Check', 'Last checked: 24 hours ago', Colors.red),
                  _buildMaintenanceTile(Icons.refresh, 'Pending Updates', '4 updates pending', Colors.orange),
                  _buildMaintenanceTile(Icons.check_circle, 'Maintenance Completed', 'No pending maintenance tasks', Colors.green),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceTile(IconData icon, String title, String subtitle, Color iconColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.grey[900],  // Dark background for each card
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,  // White text for contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white,  // White subtitle for better readability
          ),
        ),
      ),
    );
  }
}
