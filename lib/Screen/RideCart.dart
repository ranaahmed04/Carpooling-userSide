import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  final List<Map<String, dynamic>> rideList = [
    {
      'id': '1',
      'source': 'Ain shams uni',
      'destination': 'Nasr city',
      'time': '5:30 PM',
      'price':'50',
      'rider name':'Ahmed',
      'rider mail':'user1@eng.asu.edu.eg',
      'Car type':'Toyota',
      'Car color':'Red',
      'Car number':'2468 ارن',
      'Gate':'3',
    },
    {
      'id': '2',
      'source': 'fifth settlement',
      'destination': 'Ain shams uni',
      'time': '7:00 AM',
      'price':'100',
      'rider name':'Rana',
      'rider mail':'user2@eng.asu.edu.eg',
      'Car type':'Kia cerato',
      'Car color':'Red',
      'Car number':'2468 ارن',
      'Gate':'4',
    },
    {
      'id': '3',
      'source': 'nasr city',
      'destination': 'Ain shams uni',
      'time': '7:00 AM',
      'price':'50',
      'rider name':'Mohamed',
      'rider mail':'user3@eng.asu.edu.eg',
      'Car type':'Huyudai elentra',
      'Car color':'Blue',
      'Car number':'1357 ارن',
      'Gate':'3',
    },
    {
      'id': '4',
      'source': 'Ain shams uni',
      'destination': 'Maadi',
      'time': '5:30 PM',
      'price':'70',
      'rider name':'Salma',
      'rider mail':'user4@eng.asu.edu.eg',
      'Car type':'Nisaan sunny',
      'Car color':'Grey',
      'Car number':'5546 ارن',
      'Gate':'4',
    },
    {
      'id': '5',
      'source': 'Ain shams uni',
      'destination': 'Roxy',
      'time': '5:30 PM',
      'price':'35',
      'rider name':'Yussef',
      'rider mail':'user5@eng.asu.edu.eg',
      'Car type':'Kia cerato',
      'Car color':'Black',
      'Car number':'4412 ارن',
      'Gate':'3',
    },

    // Add more dummy data items if needed
    // ...
  ];

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
                        onPressed: () {
                          setState(() {
                            rideList.removeAt(index);
                          });
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'From: ${rideList[index]['source']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.001),
                            Text(
                              'To: ${rideList[index]['destination']}',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.001),
                            Text(
                              'Price: ${rideList[index]['price']}',
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.035),
                              ),
                            SizedBox(height: screenHeight * 0.001),
                            Text(
                              'Time: ${rideList[index]['time']}',
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
