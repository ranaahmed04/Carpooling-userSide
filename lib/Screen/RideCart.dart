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

  @override
  void dispose() {
    // Dispose resources here
    super.dispose();
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
    fetchUserRides(); // Fetch user rides when the widget initializes
  }
  void signOutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    print('User signed out');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ain_shams car pooling"),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: ListView.builder(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
          itemCount: rideList.length,
          itemBuilder: (BuildContext context, int index) {
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
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          if (rideList[index]['status'] == 'cart') {
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
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),
                            ),
                            SizedBox(height: screenHeight * 0.001),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: TextButton.icon(
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
