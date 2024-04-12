import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddFlight extends StatefulWidget {
  const AddFlight({super.key});

  @override
  _AddFlightState createState() => _AddFlightState();
}

class _AddFlightState extends State<AddFlight> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _airlineController = TextEditingController();
  final TextEditingController _seatsController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _arrController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Function to upload image to Firestore Storage
  Future<String> uploadImageToStorage(File imageFile) async {
    // Create a reference to the location you want to upload to in Firestore Storage
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}.png');

    // Upload the file to Firestore Storage
    UploadTask uploadTask = storageReference.putFile(imageFile);

    // Get the download URL of the uploaded image
    late String downloadURL;
    await uploadTask.whenComplete(() async {
      downloadURL = await storageReference.getDownloadURL();
    });

    // Return the download URL
    return downloadURL;
  }

  // Function to save flight details with image URL in Firestore collection
  Future<void> saveFlightDetails(
      String name,
      String airline,
      int seats,
      String from,
      String to,
      //String imageURL,
      String departureTime,
      String arrivalTime,
      int price) async {
    CollectionReference flightsCollection =
        FirebaseFirestore.instance.collection('flights');
    await flightsCollection.add({
      'name': name,
      'airline': airline,
      'seats': seats,
      'from': from,
      'to': to,
      //'imageURL': imageURL,
      "departureTime": departureTime,
      "arrivalTime": arrivalTime,
      "price": price
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Validate form fields
      _formKey.currentState!.save();
      // Upload image to Firestore Storage
      //String imageURL = await uploadImageToStorage(_image);

      // Save flight details with image URL in Firestore collection
      await saveFlightDetails(
          _nameController.text,
          _airlineController.text,
          int.parse(_seatsController.text),
          _fromController.text,
          _toController.text,
          //imageURL,
          _deptController.text,
          _arrController.text,
          int.parse(_priceController.text));
      // Reset form fields
      _formKey.currentState!.reset();
    }
    _formKey.currentState!.reset();
  }

  List<Map<String, dynamic>> flights = [
    {
      "name": "Boeing 747",
      "airline": "Sri Lankan Airlines",
      "seats": 250,
      "from": "LHR",
      "to": "CMB",
      "departureTime": "08:00",
      "arrivalTime": "21:30",
      "price": 1200,
    },
    {
      "name": "Airbus A380",
      "airline": "Qatar Airways",
      "seats": 350,
      "from": "JFK",
      "to": "CMB",
      "departureTime": "10:30",
      "arrivalTime": "23:45",
      "price": 1300,
    },
    {
      "name": "Boeing 787",
      "airline": "Emirates",
      "seats": 300,
      "from": "DXB",
      "to": "CMB",
      "departureTime": "13:15",
      "arrivalTime": "02:00",
      "price": 1100,
    },
    {
      "name": "Airbus A320",
      "airline": "Fits Air",
      "seats": 150,
      "from": "SIN",
      "to": "CMB",
      "departureTime": "16:00",
      "arrivalTime": "06:30",
      "price": 900,
    },
    {
      "name": "Embraer E190",
      "airline": "Air India",
      "seats": 100,
      "from": "NRT",
      "to": "CMB",
      "departureTime": "09:45",
      "arrivalTime": "21:15",
      "price": 800,
    },
    {
      "name": "Boeing 777",
      "airline": "Sri Lankan Airlines",
      "seats": 300,
      "from": "CDG",
      "to": "CMB",
      "departureTime": "11:30",
      "arrivalTime": "01:00",
      "price": 1250,
    },
    {
      "name": "Airbus A330",
      "airline": "Qatar Airways",
      "seats": 270,
      "from": "SYD",
      "to": "CMB",
      "departureTime": "14:20",
      "arrivalTime": "03:45",
      "price": 1150,
    },
    {
      "name": "Boeing 737",
      "airline": "Emirates",
      "seats": 180,
      "from": "YYZ",
      "to": "CMB",
      "departureTime": "16:10",
      "arrivalTime": "04:30",
      "price": 1050,
    },
    {
      "name": "Bombardier Q400",
      "airline": "Fits Air",
      "seats": 80,
      "from": "SVO",
      "to": "CMB",
      "departureTime": "18:00",
      "arrivalTime": "06:45",
      "price": 950,
    },
    {
      "name": "Airbus A380",
      "airline": "Air India",
      "seats": 380,
      "from": "HKG",
      "to": "CMB",
      "departureTime": "20:30",
      "arrivalTime": "09:15",
      "price": 1350,
    },
  ];
  //bulk insert
  void bulkInsertFlights(List<Map<String, dynamic>> flights) async {
    final CollectionReference flightsCollection =
        FirebaseFirestore.instance.collection('flights');

    for (final flight in flights) {
      try {
        await flightsCollection.add(flight);
        print('Flight added successfully: $flight');
      } catch (e) {
        print('Error adding flight: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Flight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Flight Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _airlineController,
                decoration: const InputDecoration(labelText: 'Airline'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an airline';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _seatsController,
                decoration: const InputDecoration(labelText: 'Number of Seats'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the number of seats';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fromController,
                decoration: const InputDecoration(labelText: 'From'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the departure location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _toController,
                decoration: const InputDecoration(labelText: 'To'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the destination';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _deptController,
                decoration: const InputDecoration(labelText: 'Departure time'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _arrController,
                decoration: const InputDecoration(labelText: 'arrival time'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter time';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'price'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              /*ElevatedButton(
                onPressed: () async {
                  // Open image picker
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = File(pickedFile.path);
                    });
                  }
                },
                child: const Text('Add logo'),
              ),*/
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Add Flight'),
              ),
              ElevatedButton(
                onPressed: () => bulkInsertFlights(flights),
                child: const Text('Bulk data add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: AddFlight(),
  ));
}
