import 'package:flutter/material.dart';
import 'create_flights.dart';
import 'managed_flights.dart';
import '../screens/test.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final user = "Skywings Admin";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog.adaptive(
            title: const Text('Welcome to SkyWings Admin Dashboard'),
            content: const Text(
              'As an admin, you have several privileges over the content available across SkyWings. Check manual for more details.',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddFlight()));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.flight),
                      Text(' Add flights'),
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManagedFlights()));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.flight_takeoff_sharp),
                      Text(' View all Managed Flights'),
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Test()));
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.add_alarm_sharp),
                      Text(' Add announcements'),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
