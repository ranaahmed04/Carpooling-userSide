import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proj_carpooling/Screen/login.dart';
import 'package:proj_carpooling/Screen/profile.dart';
import 'package:proj_carpooling/Screen/FindRide.dart';
import 'package:proj_carpooling/Screen/Details.dart';

class RideCart extends StatefulWidget {
  const RideCart({Key? key}) : super(key: key);

  @override
  _RideCartState createState() => _RideCartState();
}

class _RideCartState extends State<RideCart> {

  late List<Map<String, dynamic>> rideList = [];
  String _searchStatus = ''; // Track selected status

  @override
  void dispose() {
    // Dispose resources here
    super.dispose();
  }
  void checkAndUpdateStatus() {
    DateTime currentTime = DateTime.now();

    for (int i = 0; i < rideList.length; i++) {
      final rideDate = (rideList[i]['Ride_date'] as Timestamp).toDate();
      final rideTime = rideList[i]['Rideselected_time'] as String;

      // Parse the selected time string to get the time components
      final timeComponents = rideTime.split(':');
      int hours = int.parse(timeComponents[0]);
      hours=hours+12;
      final int minutes = int.parse(timeComponents[1].split(' ')[0]);

      DateTime rideDateTime = DateTime(
        rideDate.year,
        rideDate.month,
        rideDate.day,
          hours,
          minutes,

      );

      final rideStatus = rideList[i]['status'];
      print('curent $currentTime');
      print('date $rideDateTime');

      print('condition ${currentTime.isAfter(rideDateTime)}');

      if ((rideStatus == 'cart' || rideStatus == 'pending') && currentTime.isAfter(rideDateTime)) {
        rideList[i]['status'] = 'Expired';
        FirebaseFirestore.instance
            .collection('requests')
            .doc(rideList[i]['doc_id'])
            .update({'status': 'Expired'})
            .then((_) {
          print('Status updated to expired for ride ${rideList[i]['doc_id']}');
        }).catchError((error) {
          print('Error updating status: $error');
        });
      } else if (rideStatus == 'Accepted' && currentTime.isAfter(rideDateTime)) {
        rideList[i]['status'] = 'Completed';
        FirebaseFirestore.instance
            .collection('requests')
            .doc(rideList[i]['doc_id'])
            .update({'status': 'Completed'})
            .then((_) {
          print('Status updated to completed for ride ${rideList[i]['doc_id']}');
        }).catchError((error) {
          print('Error updating status: $error');
        });
      }
    }
  }


  // Function to fetch rides requested by the current user
  Future<void> fetchUserRides() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Fetch rides associated with the user ID
        QuerySnapshot rideSnapshot = await FirebaseFirestore.instance
            .collection('requests')
            .where('user_id', isEqualTo: userId)
            .get();

        // Clear the existing rideList
        setState(() {
          rideList.clear();
        });

        // Add fetched rides to the rideList
        rideSnapshot.docs.forEach((rideDoc) {
          final rideData = rideDoc.data() as Map<String, dynamic>?;
          final rideId = rideDoc.id;
          if (rideData != null) {
            setState(() {
              rideData['doc_id'] = rideId;
              rideList.add(Map<String, dynamic>.from(rideData));
            });
          }
        });
      }
    } catch (e) {
      print('Error fetching user rides: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    initializePage();
  }

  void initializePage() async {
    await fetchUserRides(); // Wait for fetching rides to complete
    checkAndUpdateStatus(); // Now, update the status based on fetched rides
  }
  void signOutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    print('User signed out');
  }
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'cart':
        return Colors.amberAccent;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'accepted':
        return Colors.green;
      case 'completed':
        return Colors.purple;
      case 'expired':
        return Colors.black54;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ain_shams car pooling"),
        backgroundColor: Colors.purple,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth * 0.5,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchStatus = value.toLowerCase(); // Update search status
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search by status...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Center(
        child: ListView.builder(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          itemCount: rideList.length,
          itemBuilder: (BuildContext context, int index) {
            bool isExpired = rideList[index]['status'] == 'Expired';

            // Filter rides based on search status
            final status = rideList[index]['status'].toString().toLowerCase();
            if (_searchStatus.isNotEmpty && !status.contains(_searchStatus)) {
              return SizedBox(); // Return an empty SizedBox for non-matching statuses
            }
            return Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: Card(
                elevation: 7,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
                  ),
                  title: Row(
                    children: [
                      Visibility(
                        visible: rideList[index]['status'] == 'cart' || rideList[index]['status'] == 'Expired',
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            // Your delete logic here
                            if (rideList[index]['status'] == 'cart'|| rideList[index]['status'] == 'Expired') {
                              // Remove from Firestore collection
                              await FirebaseFirestore.instance
                                  .collection('requests')
                                  .doc(rideList[index]['doc_id'])
                                  .delete();

                              setState(() {
                                rideList.removeAt(index); // Remove from the page
                              });
                            } else {
                              // Show snackbar indicating the action cannot be performed
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Cannot remove ride as it is not in the cart'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From: ${rideList[index]['Ridestart_location']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.001),
                            Text(
                              'To: ${rideList[index]['Rideend_location']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.001),
                            Text(
                              'Price: ${rideList[index]['Ride_cost']}',
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),
                              ),
                            SizedBox(height: screenHeight * 0.001),
                            Text(
                              'Date: ${DateFormat('dd.MM.yyyy').format(rideList[index]['Ride_date'].toDate())}',
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),
                            ),
                            SizedBox(height: screenHeight * 0.001),
                            Text(
                              'Time: ${rideList[index]['Rideselected_time']}',
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),
                            ),
                            SizedBox(height: screenHeight * 0.001),
                            Text(
                              'Staus: ${rideList[index]['status']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.035,
                                color: getStatusColor(rideList[index]['status']),
                               ),
                            ),
                            SizedBox(height: screenHeight * 0.001),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: isExpired
                      ? TextButton.icon(
                         icon: Icon(
                          Icons.bus_alert,
                          size: MediaQuery.of(context).size.width * 0.09,
                        ),
                          label: Text('Details'),
                        onPressed: null, // Button is disabled
                  )
                      : TextButton.icon(
                          icon: Icon(
                           Icons.bus_alert,
                            size: MediaQuery.of(context).size.width * 0.09,
                    ),
                            label: Text('Details'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) {
                            return RideDetail(rideList: rideList[index]);
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
                  ),
                  tileColor: Colors.purple.shade50,
                ),
              ),
            );
          },
        ),

      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          if (i == 3) {
            signOutUser();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()),
                  (route) => false,
            );
          }  else if (i == 1) {
            Navigator.pushReplacement(context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return RideListPage();
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),);
          }else if (i == 0) {
            Navigator.pushReplacement(context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return HomePage();
                },
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
                Icons.account_box,
              color: Colors.grey,
            ),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.manage_search_rounded,
              color: Colors.grey,
            ),
            label: "Find Rides",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.add_shopping_cart_rounded,
              color: Colors.purple,
            ),
            label: "Ride Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(
                Icons.logout,
              color: Colors.grey,
            ),
            label: "Log Out",
          ),
        ],
      ),
    );
  }
}
