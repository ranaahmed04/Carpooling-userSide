import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/login.dart';
import 'package:proj_carpooling/Screen/RideCart.dart';
import 'package:proj_carpooling/Screen/editProfile.dart';
import 'package:proj_carpooling/Screen/FindRide.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map userData = {
    'Name': 'Rana Ahmed',
    'Phone': '1234567890',
  };
  String email = '19p2468@eeng.asu.edu.eg';

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
        padding: EdgeInsets.all(screenWidth * 0.03),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(screenWidth * 0.03),
              child: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),
            Card(
              elevation: 7.0,
              color: Colors.purple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.07),
              ),
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.07, vertical: screenHeight * 0.025),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.3, // Adjust the value for image size
                        backgroundImage: AssetImage('assets/female-avatar-profile.jpg'),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        userData['Name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        email,
                        style: const TextStyle(fontSize: 17),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        userData['Phone'],
                        style: const TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),

            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.02),
              child: ElevatedButton(
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
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,

                  ),
                ),
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile()),);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (i) {
          if (i == 3) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()),
                  (route) => false,
            );
          } else if (i == 2) {
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

          } else if (i == 1) {
            Navigator.pushReplacement(context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return RideListPage();
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
