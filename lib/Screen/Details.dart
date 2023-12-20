import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proj_carpooling/Screen/Payment.dart';

class RideDetail extends StatefulWidget {
  final Map<String, dynamic> rideList;

  RideDetail({Key? key, required this.rideList}) : super(key: key);

  @override
  _RideDetailState createState() => _RideDetailState();
}

class _RideDetailState extends State<RideDetail> {
  late User? _currentUser;


  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
  }
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }
  @override
  void dispose() {
    // Dispose resources here
    super.dispose();
  }
  Future<String> _getStatus(String docId) async {
    // Fetch the status from Firestore using the provided docId
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('requests')
          .doc(docId)
          .get();
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?; // Handle type correctly
      return data?['status'] ?? ''; // Return the status or empty string if not found
    } catch (e) {
      print('Error fetching status: $e');
      return ''; // Return empty string on error
    }
  }
  Future<bool> checkReservationTime() async {

    if (_currentUser != null && _currentUser!.email == 'testuser@eng.asu.edu.eg') {
      return true; // Allow bypassing time restriction for specific email
    }
    Timestamp? rideTimestamp = widget.rideList['Ride_date'] as Timestamp?;
    String? rideTimeString = widget.rideList['Rideselected_time'] as String?;

    if (rideTimestamp == null || rideTimeString == null) {
      // Handle null values
      print('Missing ride date or time.');
      return false;
    }

    DateTime rideDateTime = rideTimestamp.toDate();
    int rideDay = rideDateTime.day;
    int rideMonth = rideDateTime.month;
    int rideYear = rideDateTime.year;

    List<String> timeComponents = rideTimeString.split(':');
    int rideHour = int.parse(timeComponents[0]);
    int rideMinute = int.parse(timeComponents[1].split(' ')[0]);

    DateTime currentTime = DateTime.now();
    DateTime reservationCutoff=DateTime.now();

    if (rideHour < 7 || (rideHour == 7 && rideMinute <= 30)) {
      reservationCutoff = DateTime(rideYear, rideMonth, rideDay - 1, 22, 0); // Before 10:00 PM of the previous day
    } else if (rideHour < 17 || (rideHour == 17 && rideMinute <= 30)) {
      reservationCutoff = DateTime(rideYear, rideMonth, rideDay, 13, 0); // Before 1:00 PM of the same day
    }

    bool isValid = currentTime.isBefore(reservationCutoff);

    return isValid;
  }


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
                                  'Source: ${widget.rideList['Ridestart_location']}',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                ),
                              ),
                          ),
                          ListTile(
                            title: Text(
                                'Destination: ${widget.rideList['Rideend_location']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Price: ${widget.rideList['Ride_cost']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Date: ${DateFormat('dd.MM.yyyy').format(widget.rideList['Ride_date'].toDate())}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Time: ${widget.rideList['Rideselected_time']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Driver Name: ${widget.rideList['Ridedriver_username']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Driver mail: ${widget.rideList['Ridedriver_email']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Car Model: ${widget.rideList['Ridecar_model']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Car Color: ${widget.rideList['Ridecar_color']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Car Number: ${widget.rideList['Ridecar_plateNumber']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Car Letters: ${widget.rideList['Ridecar_plateLetters']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Checking gate : ${widget.rideList['Rideselected_gate']}',
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
              onPressed: () async {
                bool isReservationValid = await checkReservationTime();

                if (isReservationValid) {
                  String status = await _getStatus(widget.rideList['doc_id']);
                  if (mounted && status == 'cart') {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return PaymentScreen(
                            docId: widget.rideList['doc_id'],
                          );
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'This ride is already paid.',
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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Reservation is overdue.',
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

