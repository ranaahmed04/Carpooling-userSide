import 'package:flutter/material.dart';
import 'package:proj_carpooling/Screen/profile.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ain Shams CarPooling'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Use your desired return icon
          onPressed: () {
            Navigator.of(context).pop(); // This will pop the current screen off the navigation stack
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[

            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Edit Your Profile',
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(height: 10,),
            const Divider(
              height: 2,
              thickness: 5,
              color: Colors.purple,
            ),
            const SizedBox(height: 20),
            TextField(
              key: ValueKey("emailID"),
              controller: nameController,
              decoration: InputDecoration(
                labelText: "19p2468@eng.asu.edu.eg",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),

            const SizedBox(height: 2),
            buildTextFieldWithEditIcon("Rana Ahmed", nameController, Icons.edit),
            const SizedBox(height: 2),
            buildTextFieldWithEditIcon("Phone Number", phoneController, Icons.edit),
            const SizedBox(height: 20),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                key: ValueKey("submit"),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
                    ),
                  ),
                ),
                child: const Text('Save Changes'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget buildTextFieldWithEditIcon(String label, TextEditingController controller, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: ValueKey(label),
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                labelText: label,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(icon),
          ),
        ],
      ),
    );
  }
}



