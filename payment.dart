import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'main_screen.dart';
import 'seat_selection.dart';

import '../util/flight.dart';

class PaymentForm extends StatefulWidget {
  final Flight flight;
  final int price;
  final Set<SeatNumber> selectedSeats;
  final String email = FirebaseAuth.instance.currentUser?.email ?? '';
  PaymentForm(
      {super.key,
      required this.flight,
      required this.price,
      required this.selectedSeats});

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  late String? useremail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    var mobileDeviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Form'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'SkyWing\'s Secure Payment Gateway',
                    style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Enter your card details ',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter card number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    //controller: _cardNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Card Holder\'s Name',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Expiry date ',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          //controller: _expiryDateController,
                          decoration: const InputDecoration(
                            labelText: 'MM',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter expiration date';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextFormField(
                          //controller: _expiryDateController,
                          decoration: const InputDecoration(
                            labelText: 'YY',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter expiration date';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter CVV';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                      'We use secure connection gateway to process your payments. We don\'t store any personal information',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 5),
                  Image.asset(
                    'assets/crd.png', // Make sure to put your logo.png in the assets folder
                    width: mobileDeviceWidth,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                height: 150,
                width: mobileDeviceWidth,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total payable: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        Text(
                          '\$${widget.price}.00',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          submitPayment(widget.flight, widget.email,
                              widget.selectedSeats);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                          return Colors.black; // Set button color to black
                        }),
                        minimumSize: MaterialStateProperty.all<Size>(const Size(
                            double.infinity,
                            50)), // Set button width to screen width
                      ),
                      child: const Text('Pay now'),
                    ),
                  ),
                  const Text('Protected by 256-Bit Encryption',
                      style: TextStyle(color: Colors.grey, fontSize: 12))
                ]),
              ))
        ],
      ),
    );
  }

  void submitPayment(Flight flightData, String email, selectedSeats) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference paymentRef =
          FirebaseFirestore.instance.collection('payment');

// Add a new document to the payment collection
      DocumentReference paymentDocRef = await paymentRef.add({
        'date': DateTime.now().toString(),
        'email': email,
        'amount': flightData.price * selectedSeats.length + 15,
        'card': _cardNumberController.text,
      });

      // Get the ID of the newly created payment document
      String paymentId = paymentDocRef.id;

      // Update the corresponding booking document in the booking collection
      CollectionReference bookingRef =
          FirebaseFirestore.instance.collection('booking');

      // Add a new document to the booking collection
      DocumentReference bookingDocRef = await bookingRef.add({
        'flightId': flightData.id,
        'date': flightData.date,
        'email': email,
        'seats': selectedSeats.length,
        'totalPrice': flightData.price * selectedSeats.length + 15,
        'selectedSeats': selectedSeats.join(" , "),
        'checkin': false
      });

      // Get the ID of the newly created booking document
      String bookingId = bookingDocRef.id;

      // Add a new document to the userNotification collection
      CollectionReference userNotificationRef =
          FirebaseFirestore.instance.collection('userNotification');

      await userNotificationRef.add({
        'email': email,
        'bookingId': bookingId, // Assuming you have the bookingId variable
        'paymentId': paymentId,
        'created': DateTime.now().toString(),
        'date': flightData.date,
        'read_status': false
      });

      _sendmail(
          DateTime.now().toString().split(' ')[0],
          flightData.price * selectedSeats.length + 15,
          paymentId.substring(0, 5),
          bookingId.substring(0, 5),
          widget.email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking successful. Check your mail.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } catch (e) {
      // Show a snackbar to indicate error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _sendmail(
      String paymentDate, amount, paymentId, bookingId, recipient) async {
    String username = 'skywingsbooking@gmail.com';
    String password = 'sbymzyzkmfrvqwdv';

    final String htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <title>Payment Confirmation</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
    }
    .container {
      width: 80%;
      margin: auto;
      padding: 20px;
    }
    h1 {
      color: #007bff;
    }
    p {
      color: #333;
    }
    .logo {
      text-align: center;
    }
    .logo img {
      width: 100px;
    }
    .payment-details {
      margin-top: 20px;
      border-top: 1px solid #ccc;
      padding-top: 20px;
    }
    .payment-details h2 {
      margin-bottom: 10px;
      color: #007bff;
    }
    .payment-details p {
      margin-bottom: 5px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="logo">
      <img src="https://firebasestorage.googleapis.com/v0/b/skywings-travel.appspot.com/o/logo.png?alt=media&token=b002b1a7-c02c-47ef-90a5-11eb0ed94d36" alt="Skywings Logo">
      <h1>Skywings</h1>
      <p>Thank you for using SkyWings</p>
    </div>
    <h2>Payment confirmation</h2>
    <div class="payment-details">
      <p><strong>Booking ID:</strong> $bookingId</p>
      <p><strong>Payment ID:</strong> $paymentId</p>
      <p><strong>Date:</strong> $paymentDate</p>
      <p><strong>Amount:</strong> $amount USD</p>
      <p><strong>Payment Method:</strong> Credit Card</p>
      <br>
      <p>This is a system generated email. Please do not reply. Skywings 2024</p>
    </div>
  </div>
</body>
</html>
''';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'SkyWings Booking')
      ..recipients.add(recipient)
      ..subject = 'Skywings booking confirmation'
      ..text = 'This is a system generated mail. Do not reply.'
      ..html = htmlContent;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

    var connection = PersistentConnection(smtpServer);

    await connection.send(message);

    await connection.close();
  }
}
