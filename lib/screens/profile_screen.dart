import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'package:mymeals/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userEmail = "";
  @override
  void initState() {
    super.initState();
    User? loggedInUser = FirebaseAuth.instance.currentUser;
    if (loggedInUser != null) {
      userEmail = loggedInUser.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                children: [
                  const Divider(
                    thickness: 1,
                  ),
                  const Text(
                    'Username ',
                    style:
                        TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(userEmail.toString(),
                      style:
                          TextStyle(fontSize: 12.0, color: Colors.grey[600])),
                  const Divider(
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await auth.logout();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false);
                      },
                      child: const Text('Logout'))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
