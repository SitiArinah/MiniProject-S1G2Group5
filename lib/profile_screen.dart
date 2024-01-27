import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // user profile information
  String _name = "Group 5";
  int _age = 23;
  String _occupation = "Student";

  // text editing controllers for profile information
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _occupationController;

  // key for the form widget
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default values
    _nameController = TextEditingController(text: _name);
    _ageController = TextEditingController(text: _age.toString());
    _occupationController = TextEditingController(text: _occupation);
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _nameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage("assets/profile_picture.jpg"),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Age",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your age";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10.0),
              TextFormField(
                controller: _occupationController,
                decoration: InputDecoration(
                  labelText: "Occupation",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your occupation";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState!.validate()) {
                    // Save the changes to the profile
                    _saveProfileChanges();
                  }
                },
                child: Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent, //sets the button's text color
                  backgroundColor: Colors.lightBlueAccent,
                  padding: EdgeInsets.all(10), //sets the button's padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), //sets the button's border radius
                  ),
                  elevation: 5, //sets the button's elevation
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfileChanges() {
    // Update the profile information with the values from the controllers
    setState(() {
      _name = _nameController.text;
      _age = int.parse(_ageController.text);
      _occupation = _occupationController.text;
    });

    // Perform any additional actions needed when saving changes
    // For example, you might want to update the user's profile on a server

    // Optionally, you can show a success message or navigate to another screen
    // For example:
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text("Profile updated successfully"),
    // ));
    // Navigator.pop(context); // Navigate back to the previous screen
  }
}


