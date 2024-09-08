import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF003366),
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.grey[200],
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(color: Colors.black, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
        ),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1C1C1E),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue, // Default button color
          textTheme: ButtonTextTheme.primary, // Text color for buttons
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue, // Text color for ElevatedButton
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: const Size(80, 40),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Solar',
                style: TextStyle(color: Colors.white, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
              ),
              Text(
                'Vert',
                style: TextStyle(color: Colors.blue, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.account_circle, color: Colors.blue, size: 30),
              onSelected: (value) {
                switch (value) {
                  case 'My Profile':
                    // Navigate to My Profile
                    break;
                  case 'Settings':
                    // Navigate to Settings
                    break;
                  case 'Logout':
                    // Handle logout
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'My Profile', 'Settings', 'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        drawer: PowerUsageDrawer(),
        body: OverviewPage(showWeatherForecast: showWeatherForecast),
      ),
    );
  }

  void showWeatherForecast(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(175, 15, 54, 115),
          title: const Text(
            'Weather Forecast',
            style: TextStyle(color: Colors.white, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Temperature: 30°C', style: TextStyle(color: Colors.white, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600)),
              Text('Wind: 10 km/h', style: TextStyle(color: Colors.white, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600)),
              Text('Humidity: 60%', style: TextStyle(color: Colors.white, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}

class OverviewPage extends StatelessWidget {
  final void Function(BuildContext) showWeatherForecast;

  OverviewPage({required this.showWeatherForecast});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Jaz',
              style: TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PowerDetailsPage(
                      title: 'Power Generated',
                      powerValue: '150kW',
                    ),
                  ),
                );
              },
              child: PowerCard(
                title: 'Power Generated',
                powerValue: '150kW',
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PowerDetailsPage(
                      title: 'Power Usage',
                      powerValue: '100kW',
                    ),
                  ),
                );
              },
              child: PowerCard(
                title: 'Power Usage',
                powerValue: '100kW',
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
                if (kDebugMode) {
                  print("Weather Forecast tapped");
                }
                showWeatherForecast(context);
              },
              child: const Text(
                'Weather Forecast',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'AlbertSans',
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Daily Review',
              style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              'Power Generated Today: 150kW\nPower Consumed Today: 100kW\nSolar Panel: Working\nSensors: Working',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'AlbertSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PowerCard extends StatelessWidget {
  final String title;
  final String powerValue;

  PowerCard({required this.title, required this.powerValue});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              'Power generated today: $powerValue',
              style: const TextStyle(color: Colors.blue, fontSize: 18, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 150, // Height of the graph
              child: Placeholder(), // Replace with a real graph widget
            ),
          ],
        ),
      ),
    );
  }
}

class PowerDetailsPage extends StatefulWidget {
  final String title;
  final String powerValue;

  PowerDetailsPage({required this.title, required this.powerValue});

  @override
  _PowerDetailsPageState createState() => _PowerDetailsPageState();
}

class _PowerDetailsPageState extends State<PowerDetailsPage> {
  String selectedTab = 'Daily'; // Default selected tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Make the back button white for visibility
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(color: Colors.black, fontSize: 24, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildTabButton('Daily'),
                buildTabButton('Weekly'),
                buildTabButton('Monthly'),
              ],
            ),
            const SizedBox(height: 20),
            buildGraphAndValues(),
          ],
        ),
      ),
    );
  }

  Widget buildTabButton(String tabName) {
    bool isSelected = selectedTab == tabName;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedTab = tabName;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[600], // Updated button color
      ),
      child: Text(tabName, style: const TextStyle(fontFamily: 'AlbertSans', fontWeight: FontWeight.w600)),
    );
  }

  Widget buildGraphAndValues() {
    switch (selectedTab) {
      case 'Daily':
        return Column(
          children: [
            const Text(
              'Daily Distribution',
              style: TextStyle(color: Colors.black, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 200, // Main graph size
              child: Placeholder(), // Replace with actual graph for Daily
            ),
            const SizedBox(height: 20),
            powerGeneratedRow('6 AM', '50 kW'),
            powerGeneratedRow('9 AM', '80 kW'),
            powerGeneratedRow('12 PM', '90 kW'),
            powerGeneratedRow('3 PM', '70 kW'),
            powerGeneratedRow('6 PM', '40 kW'),
          ],
        );
      case 'Weekly':
        return Column(
          children: [
            const Text(
              'Weekly Distribution',
              style: TextStyle(color: Colors.black, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 200, // Main graph size
              child: Placeholder(), // Replace with actual graph for Weekly
            ),
            const SizedBox(height: 20),
            powerGeneratedRow('Monday', '500 kW'),
            powerGeneratedRow('Tuesday', '600 kW'),
            powerGeneratedRow('Wednesday', '700 kW'),
            powerGeneratedRow('Thursday', '550 kW'),
            powerGeneratedRow('Friday', '650 kW'),
          ],
        );
      case 'Monthly':
        return Column(
          children: [
            const Text(
              'Monthly Distribution',
              style: TextStyle(color: Colors.black, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 200, // Main graph size
              child: Placeholder(), // Replace with actual graph for Monthly
            ),
            const SizedBox(height: 20),
            powerGeneratedRow('Week 1', '1500 kW'),
            powerGeneratedRow('Week 2', '1800 kW'),
            powerGeneratedRow('Week 3', '1700 kW'),
            powerGeneratedRow('Week 4', '1600 kW'),
          ],
        );
      default:
        return const SizedBox();
    }
  }

  Widget powerGeneratedRow(String timeOrDay, String power) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timeOrDay,
            style: const TextStyle(color: Colors.black, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
          ),
          Text(
            power,
            style: const TextStyle(color: Colors.black, fontFamily: 'AlbertSans', fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class PowerUsageDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {
              // Handle item 1 tap
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Handle item 2 tap
            },
          ),
        ],
      ),
    );
  }
}
