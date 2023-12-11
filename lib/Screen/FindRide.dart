import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/login.dart';
import 'package:proj_carpooling/Screen/profile.dart';
import 'package:proj_carpooling/Screen/RideCart.dart';
import 'package:intl/intl.dart';


class RideListPage extends StatefulWidget {
  const RideListPage({Key? key}) : super(key: key);

  @override
  State<RideListPage> createState() => _RideListPageState();
}

class _RideListPageState extends State<RideListPage> {
  late Stream<QuerySnapshot> _ridesStream;

  @override
  void initState() {
    super.initState();
    _ridesStream = FirebaseFirestore.instance.collection('rides').snapshots();
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
              // Handle search logic
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
          return Center(
            child: ListView.builder(
              padding: EdgeInsets.all(screenWidth * 0.02),
              itemCount: rides.length,
              itemBuilder: (BuildContext context, int index) {
                final ride = rides[index];
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
                              // Handle onPressed logic here
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
}
