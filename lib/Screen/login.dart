import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/sign_up.dart';
import 'package:proj_carpooling/Screen/profile.dart';
import 'package:proj_carpooling/Screen/ForgetPassword.dart';

final globalScaffoldKey = GlobalKey<ScaffoldState>();

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: globalScaffoldKey,
      appBar: AppBar(
        title: const Text('Ain_shams car pooling '),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Log-In',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  Image.asset(
                    'assets/loginicon.jpg',
                    width: screenWidth * 0.5, // Adjust image size
                    height: screenHeight * 0.2, // Adjust image size
                  ),
                ],
              ),
            ),
            const Divider(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(5),

              child: TextField(
                key: ValueKey("userName"),
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.person, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),// Adjust border radius
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),
                ),
              ),),
            ),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(5),
              child: TextField(
                key: ValueKey("password"),
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),
                    // Adjust border radius
                  ),
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.purple),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return ForgotPassword();
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
              style: TextButton.styleFrom(primary: Colors.purple),
              child: const Text('Forgot Password'),
            ),
            Container(
              height: screenHeight * 0.09, // Adjust button height
              decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton(

                key: ValueKey("login"),
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
                    'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,

                  ),
                ),
                onPressed: () async{
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => HomePage(),));
                  // Logic for login button was removed
                },
              ),
            ),
            Container(
              child: Row(
                children: <Widget>[
                  const Text("Don't have an account?"),
                  TextButton(
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20, color: Colors.purple),

                    ),
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ));
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
