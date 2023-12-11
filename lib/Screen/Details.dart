import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/Payment.dart';

class RideDetail extends StatefulWidget {
  final Map<String, dynamic> rideList;

  RideDetail({Key? key, required this.rideList}) : super(key: key);

  @override
  _RideDetailState createState() => _RideDetailState();
}

class _RideDetailState extends State<RideDetail> {


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(
        title: const Text('Ain_shams car pooling'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.01),

        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: const Text(
                'Ride Details',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),
              Card(
                color: Colors.purple.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
                ),
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.07, vertical: screenHeight * 0.025),
              elevation: 7.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              title: Text(
                                  'Source: ${widget.rideList['source']}',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                          ),
                          ListTile(
                            title: Text(
                                'Destination: ${widget.rideList['destination']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Price: ${widget.rideList['price']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Time: ${widget.rideList['time']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Driver Name: ${widget.rideList['rider name']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Driver mail: ${widget.rideList['rider mail']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Car Model: ${widget.rideList['Car type']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Car Color: ${widget.rideList['Car color']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Car Number: ${widget.rideList['Car number']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Checking gate : ${widget.rideList['Gate']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                        ],
                      ),
    ),

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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return PaymentScreen();
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
                );
              },
              child: Text('Pay'),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}

