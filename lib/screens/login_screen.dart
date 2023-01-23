import 'package:mymeals/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_screen.dart';
import 'package:mymeals/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen(
      {Key? key,
      this.testMode = false,
      this.mockAuth = false,
      this.mockGoogleSignIn = false})
      : super(key: key);
  final bool testMode;
  final dynamic mockAuth;
  final dynamic mockGoogleSignIn;

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic auth;
  @override
  void dispose() {
    emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  dynamic signin() async {
    try {
      await auth
          .handleSignInEmail(emailController.text, _passwordController.text)
          .then((value) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error while logging in, please try again'),
      ));
    }
  }

  dynamic googleSignIn() async {
    try {
      await auth.signInwithGoogle();
      if (!mounted) return;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error in Google SignIn'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.testMode) {
      auth = Provider.of<Auth>(context);
    } else {
      auth = Auth(
          testMode: widget.testMode,
          mockAuth: widget.mockAuth,
          mockGoogleSignIn: widget.mockGoogleSignIn);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                  child: Image(image: AssetImage('assets/images/appLogo.png'))),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration:
                          const InputDecoration(labelText: 'Enter your email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          labelText: 'Enter your password'),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        } else if (value.length < 6) {
                          return 'Password should be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        signin();
                      },
                      child: const Text('Login')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                      },
                      child: const Text('Don\'t have an account?')),
                  const SizedBox(
                    height: 20,
                    child: Text("or"),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: OutlinedButton.icon(
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        googleSignIn();
                      },
                      label: const Text(
                        "Sign-in with Google",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide.none)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
