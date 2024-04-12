import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagedFlights extends StatelessWidget {
  const ManagedFlights({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flights and Airlines',
          style: TextStyle(fontFamily: 'DM Sans'),
        ),
      ),
      body: _buildFlightsList(),
    );
  }

  Widget _buildFlightsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('flights').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No flights available'));
        }

        // Group flights by airline
        Map<String, List<QueryDocumentSnapshot>> flightsByAirline = {};
        for (var doc in snapshot.data!.docs) {
          String airline = doc['airline'] ?? 'Unknown Airline';
          flightsByAirline.putIfAbsent(airline, () => []).add(doc);
        }

        // Build list of flights by airline
        List<Widget> flightWidgets = [];
        flightsByAirline.forEach((airline, flights) {
          flightWidgets.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    airline,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: flights.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(flights[index]['name'] ?? ''),
                      subtitle: Text(
                          'From: ${flights[index]['from'] ?? ''} - To: ${flights[index]['to'] ?? ''}'),
                      // Add more details as needed
                    );
                  },
                ),
              ],
            ),
          );
        });

        return ListView(
          padding: const EdgeInsets.all(16),
          children: flightWidgets,
        );
      },
    );
  }
}
