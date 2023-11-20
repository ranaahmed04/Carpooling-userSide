import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
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

  void _makePayment(BuildContext context) {
    // Implement your payment logic here
    // For demo purposes, simulate a delay and show a SnackBar message
    Future.delayed(Duration(seconds: 1), () {
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
    });
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
                  // Handle payment logic based on selected method
                  if (_paymentMethod == 'Cash') {
                    _makePayment(context);
                  } else if (_paymentMethod == 'Visa') {
                    // Validate Visa details before payment
                    if (_cardNumber.isNotEmpty &&
                        _cardHolderName.isNotEmpty &&
                        _expiryMonth.isNotEmpty &&
                        _expiryYear.isNotEmpty &&
                        _cvv.isNotEmpty) {
                      _makePayment(context);
                    } else {
                      // Show a message if Visa details are incomplete
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
                    }
                  }
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
