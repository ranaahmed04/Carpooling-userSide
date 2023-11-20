import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/profile.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ain_shams car pooling'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding
              child: const Text(
                'Sign-Up',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),
            const Divider(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding
              child: TextField(
                key: ValueKey("emailID"),
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),// Adjust border radius
                  ),
                  labelText: 'example@eng.asu.edu.eg',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding
              child: TextField(
                key: ValueKey("userName"),
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),// Adjust border radius
                  ),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding
              child: TextField(
                key: ValueKey("password"),
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),// Adjust border radius
                  ),
                  labelText: 'Password',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding
              child: TextField(
                key: ValueKey("confirmPassword"),
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),// Adjust border radius
                  ),
                  labelText: 'Confirm Password',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding
              child: TextField(
                key: ValueKey("number"),
                keyboardType: TextInputType.number,
                controller: phoneController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    borderSide: BorderSide(color: Colors.purple, width: 2.0),// Adjust border radius
                  ),
                  labelText: 'Phone Number',
                ),
              ),
            ),
            Container(
              height: screenHeight * 0.08, // Adjust button height
              padding: EdgeInsets.fromLTRB(screenWidth * 0.03, 0, screenWidth * 0.03, 0), // Adjust padding
              child: ElevatedButton(
                key: ValueKey("submit"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05), // Adjust border radius
                    ),
                  ),
                ),
                child: const Text(
                    'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,

                  ),
                ),
                onPressed: () async {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => HomePage(),));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
