import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/login.dart';
import 'package:proj_carpooling/Screen/profile.dart';
import 'package:proj_carpooling/Screen/RideCart.dart';


class RideListPage extends StatefulWidget {
  const RideListPage({Key? key}) : super(key: key);
  @override
  State<RideListPage> createState() => _RideListPageState();
}

class _RideListPageState extends State<RideListPage> {
  var rideList = [
    {
      'start': 'Ain Shams University',
      'end': 'Nasr City',
      'time': '8:00 AM',
      'price':'50',
    },
    {
      'start': 'Fifth Settlement',
      'end': 'Ain Shams University',
      'time': '7:30 AM',
      'price':'100',
    },
    {
      'start': 'Ain shams uni',
      'end': 'Maadi',
      'time': '5:30 PM',
      'price':'70',
    },
    // Add more dummy data if needed
    // ...
  ];

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
                  title:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From: ${rideList[index]['start']}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.001),
                      Text(
                        'To: ${rideList[index]['end']}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.001),
                      Text(
                        'Time: ${rideList[index]['time']}',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035),
                      ),
                      SizedBox(height: screenHeight * 0.001),
                      Text(
                        'Price: ${rideList[index]['price']}',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035),
                      ),
                      SizedBox(height: screenHeight * 0.001),
                    ]
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          Icons.bus_alert_rounded,
                          size: MediaQuery.of(context).size.width * 0.09,
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
            icon: Icon(Icons.account_box),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_search_rounded),
            label: "Find Rides",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_shopping_cart_rounded),
            label: "Ride Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "Log Out",
          ),
        ],
      ),
    );
  }
}
