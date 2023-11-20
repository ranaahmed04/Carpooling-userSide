import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/resetPassword.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();

  void resetPassword(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ResetPassword();
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reset password link sent to ${emailController.text}'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding:  EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
        child: ListView(
            children: <Widget>[
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
                      SizedBox(height: screenHeight * 0.04),
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      TextField(
                        key: ValueKey("forgotPasswordEmail"),
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Enter your email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                    ],
                ),
              ),

            ),
              ElevatedButton(
                key: ValueKey("resetPassword"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.03,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  elevation: MaterialStateProperty.all<double>(8.0),
                ),
                onPressed: () {
                  resetPassword(context);
                },
                child: const Text(
                  'Reset Password',
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
