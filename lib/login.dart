import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dailyexpenses.dart';
import 'package:transparent_image/transparent_image.dart';


void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ipaddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: "https://cdn-icons-png.flaticon.com/512/2611/2611215.png")
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
              ),
              /*Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: ipaddressController,
                  decoration: const InputDecoration(
                    labelText: 'REST API address',
                  ),
                ),
              ),*/
              ElevatedButton(
                onPressed: () async {
                  String username = usernameController.text;
                  String password = passwordController.text;
                  String ipconfig = ipaddressController.text;
                  if (username == 'group5' && password == '1234') {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString("username", username);
                    await prefs.setBool("isLogin", true);
                    await prefs.setString("ipconfig", "http://$ipconfig");
                    print("Entered IP Address: $ipconfig");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DailyExpensesApp(username: username),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Login Failed'),
                          content: const Text('Invalid username or password.'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent, //sets the button's text color
                  backgroundColor: Colors.lightBlueAccent,
                  padding: EdgeInsets.all(10), //sets the button's padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), //sets the button's border radius
                  ),
                  elevation: 5, //sets the button's elevation
                ),

              ), //Text('Login',style: TextStyle(color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}