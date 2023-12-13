import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proj_carpooling/Screen/profile.dart';

class PaymentScreen extends StatefulWidget {
  final String docId;

  const PaymentScreen({Key? key, required this.docId}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = '';
  String _cardNumber = '';
  String _cardHolderName = '';
  String _expiryMonth = '';
  String _expiryYear = '';
  String _cvv = '';


  @override
  void dispose() {
    // Dispose resources here
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  void _makePayment(BuildContext context) async {
    if (!mounted) return; // Check if the widget is mounted before proceeding

    if (_paymentMethod == 'Cash') {
      // Simulate payment and show SnackBar
      await Future.delayed(Duration(seconds: 1));
      if (!mounted) return; // Check again before accessing context
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Payment is complete',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              color: Colors.green,
            ),
          ),
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 5),
        ),
      );
    } else if (_paymentMethod == 'Visa') {
      if (_cardNumber.isEmpty ||
          _cardHolderName.isEmpty ||
          _expiryMonth.isEmpty ||
          _expiryYear.isEmpty ||
          _cvv.isEmpty) {
        // Show a message if Visa details are incomplete
        if (!mounted) return; // Check before showing SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please fill all Visa details',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                color: Colors.red,
              ),
            ),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.blueGrey,
          ),
        );
        return;
      }
      // Perform payment logic for Visa
    }

    if (!mounted) return; // Check before updating Firestore
    try {
      await FirebaseFirestore.instance
          .collection('requests')
          .doc(widget.docId)
          .update({'status': 'pending'});
    } catch (e) {
      print('Error updating status: $e');
    }

    if (!mounted) return; // Check before navigation
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return HomePage();

        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose Payment Method:',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenWidth * 0.1),
              Row(
                children: [
                  Radio<String>(
                    value: 'Cash',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                        // Clear Visa details when switching to Cash payment
                        _cardNumber = '';
                        _cardHolderName = '';
                        _expiryMonth = '';
                        _expiryYear = '';
                        _cvv = '';
                      });
                    },
                  ),
                  SizedBox(width: screenHeight * 0.006),
                  Icon(
                    Icons.money,
                    size: MediaQuery.of(context).size.width * 0.09,
                    color: Colors.green,
                  ),
                  SizedBox(width: screenHeight * 0.002),
                  Text(
                    'Pay Cash',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.02),
              Row(
                children: [
                  Radio<String>(
                    value: 'Visa',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value!;
                      });
                    },
                  ),
                  SizedBox(width: screenHeight * 0.006),
                  Icon(
                    Icons.credit_card,
                    size: MediaQuery.of(context).size.width * 0.09,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: screenHeight * 0.002),
                  Text(
                    'Pay with Visa',
                    style: TextStyle(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.1),
              if (_paymentMethod == 'Visa')
                Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Card Number'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _cardNumber = value;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Card Holder Name'),
                      onChanged: (value) {
                        _cardHolderName = value;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Expiry Month'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _expiryMonth = value;
                            },
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Expiry Year'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _expiryYear = value;
                            },
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'CVV'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _cvv = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              SizedBox(height: screenWidth * 0.1),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: screenWidth * 0.08, vertical: screenHeight * 0.03),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  elevation: MaterialStateProperty.all<double>(8.0),
                ),
                onPressed: () {
                  _makePayment(context);
                },
                child: Text('Pay', style: TextStyle(fontSize: screenWidth * 0.04)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
