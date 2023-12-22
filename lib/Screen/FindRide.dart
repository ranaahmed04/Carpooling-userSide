import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/login.dart';
import 'package:proj_carpooling/Screen/profile.dart';
import 'package:proj_carpooling/Screen/RideCart.dart';
import 'package:intl/intl.dart';



class UserDetails {
  final String userId;
  final String userEmail;
  final String userphone;
  final String username;

  UserDetails({required this.userId, required this.userEmail, required this.userphone, required this.username});
}


class RideListPage extends StatefulWidget {
  const RideListPage({Key? key}) : super(key: key);

  @override
  State<RideListPage> createState() => _RideListPageState();
}

class _RideListPageState extends State<RideListPage> {
  late Stream<QuerySnapshot> _ridesStream;
  DateTime? _selectedDate; // Variable to hold the selected date for filtering
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _ridesStream = FirebaseFirestore.instance.collection('rides').snapshots();
  }
// Function to get the current user's details
  Future<UserDetails> getCurrentUserDetails() async {
    if (_currentUser != null) {
      String userId = _currentUser!.uid;
      String userEmail = _currentUser!.email ?? ''; // Default empty string if null\

      // Fetch the user's name from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      String userName = userSnapshot['username'] ?? '';
      String userPhone = userSnapshot['phoneNumber'] ?? '';

      return UserDetails(userId: userId, userEmail: userEmail,userphone: userPhone,username: userName);
    } else {
      throw Exception('No user is currently logged in');
    }
  }
  Future<void> addRideToCart(DocumentSnapshot rideSnapshot) async {
    Map<String, dynamic> rideData =
    rideSnapshot.data() as Map<String, dynamic>;


    try {
      var currentUser = await getCurrentUserDetails(); // Await to get user details

      var rideExists = await FirebaseFirestore.instance
          .collection('requests')
          .where('ride_id', isEqualTo: rideSnapshot.id)
          .where('user_id', isEqualTo: currentUser.userId)
          .get();

      if (rideExists.docs.isEmpty) {
        // If the ride with the user doesn't exist in the request collection, add it

        Map<String, dynamic> rideDetails = {
          'user_id': currentUser.userId,
          'userName': currentUser.username,
          'userEmail': currentUser.userEmail,
          'userphone':currentUser.userphone,
          'ride_id':rideSnapshot.id,
          'Ridestart_location': rideData["start_location"] ,
          'Rideend_location':rideData["end_location"] ,
          'Rideselected_time': rideData["selected_time"] ,
          'Rideselected_gate': rideData["selected_gate"] ,
          'Ride_date': rideData["ride_date"] ,
          'Ride_cost': rideData["ride_cost"] ,
          'Ridedriver_id':rideData["driver_id"] ,
          'Ridedriver_username': rideData["driver_username"] ,
          'Ridedriver_email': rideData["driver_email"] ,
          'Ridecar_model': rideData["car_model"] ,
          'Ridecar_color': rideData["car_color"] ,
          'Ridecar_plateNumber': rideData["car_plateNumber"] ,
          'Ridecar_plateLetters': rideData["car_plateLetters"] ,
          'status': 'cart',
          // Add other fields or details of the ride
        };
        await FirebaseFirestore.instance.collection('requests').add(rideDetails);


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ride added to cart successfully!'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('this ride is already in the cart '),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error adding ride to cart: $e');
      // Handle the error
    }
  }
  void _getCurrentUser() {
    _currentUser = FirebaseAuth.instance.currentUser;
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
        title: Text('Ain_shams car pooling'),
        backgroundColor: Colors.purple,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _selectDate(context);
            },
          ),
          if (_selectedDate != null) // Show clear button only when date is selected
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _selectedDate = null; // Clear selected date
                });
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ridesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final rides = snapshot.data!.docs;

          final currentTime = DateTime.now();
          final upcomingRides = rides.where((ride) {
            final rideDate = (ride['ride_date'] as Timestamp).toDate();
            final rideTime = ride['selected_time'] as String;
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

            return (_selectedDate == null || rideDate.isAtSameMomentAs(_selectedDate!)) &&
                currentTime.isBefore(rideDateTime);
          }).toList();
          return Center(
            child: ListView.builder(
              padding: EdgeInsets.all(screenWidth * 0.02),
              itemCount: upcomingRides.length,
              itemBuilder: (BuildContext context, int index) {
                final ride = upcomingRides[index];
                return Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Card(
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.07),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.07),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From: ${ride['start_location']}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.001),
                          Text(
                            'To: ${ride['end_location']}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.001),
                          Text(
                            'Driver Name: ${ride['driver_username']}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.001),
                          Text(
                            'Time: ${ride['selected_time']}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.001),
                          Text(
                            'Date: ${DateFormat('dd.MM.yyyy').format(ride['ride_date'].toDate())}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.001),
                          Text(
                            'Price: ${ride['ride_cost']}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.001),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            icon: Icon(
                              Icons.bus_alert_rounded,
                              size: screenWidth * 0.09,
                            ),
                            label: Text('Add to cart'),
                            onPressed: () {
                              addRideToCart(ride);
                            },
                          ),
                        ],
                      ),
                      tileColor: Colors.purple.shade50,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          if (i == 3) {
            signOutUser();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()),
                  (route) => false,
            );
          }  else if (i == 2) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return RideCart();
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
              color: Colors.purple,
            ),
            label: "Find Rides",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_shopping_cart_rounded,
              color: Colors.grey,
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
  // Function to open a date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2060),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked; // Set selected date
      });
    }
  }
}
