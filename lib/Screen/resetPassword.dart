import 'package:proj_carpooling/Screen/profile.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  final String email;

  ResetPassword({required this.email});
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void setNewPassword(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password updated successfully'),
        duration: Duration(seconds: 5),
      ),
    );

    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return HomePage();
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

    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: ListView(
            children: <Widget> [
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          radius: screenWidth < 600 ? 60.0 : 80.0,
                          backgroundImage: AssetImage('assets/resetpage.jpg'),
                        ),
                      ),
                      SizedBox(height: 20),
                      const Text(
                        'Reset Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        key: ValueKey("newPassword"),
                        controller: newPasswordController,
                        obscureText: true, // Hides the entered text
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        key: ValueKey("confirmPassword"),
                        controller: confirmPasswordController,
                        obscureText: true, // Hides the entered text
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                    ],
                  ),
                ),
              ),
              ElevatedButton(
                key: ValueKey("updatePassword"),
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
                  setNewPassword(context);
                },
                child: const Text(
                  'Update Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
    ]
            ),

      ),
    );
  }
}
