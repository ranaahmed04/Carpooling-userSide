import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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


  Future<void> signUpWithEmailAndPassword(BuildContext context) async {
    String email = emailController.text.trim();
    String username = nameController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String phoneNumber = phoneController.text.trim();

    // Check if the email has the correct domain
    if (!email.endsWith('@eng.asu.edu.eg')) {
      // Show an error message to the user if the email domain is incorrect
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please use an @eng.asu.edu.eg email address.'),
        ),
      );
      return;
    }

    // Check if the password is strong (at least 6 characters, include numbers, etc.)
    if (password.length < 6 || !containsNumbers(password)) {
      // Show an error message for a weak password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password should be at least 6 characters long and include numbers.'),
        ),
      );
      return;
    }

    // Check if the entered password and confirm password match
    if (password != confirmPassword) {
      // Show an error message for mismatched passwords
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return;
    }
    // Validate phone number format and length
    if (phoneNumber.length != 11 || !phoneNumber.startsWith('01')) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid phone number that start with 01'),
        ),
      );
      return;
    }
    // Check if the email is already in use
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access the current user after sign-up
      User? currentUser = userCredential.user;

      // Save additional user information to Firestore
      await FirebaseFirestore.instance.collection('users').doc(currentUser?.uid).set({
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'username': username,
        // Add more fields as needed
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      // Firebase createUserWithEmailAndPassword failed, handle the error
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign up failed. Please try again.'),
        ),
      );
    }
  }

  bool containsNumbers(String value) {
    return RegExp(r'\d').hasMatch(value);
  }


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
                  signUpWithEmailAndPassword(context);

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
