import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mymeals/screens/home_screen.dart';
import 'package:mymeals/services/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen(
      {Key? key,
      this.testMode = false,
      this.mockAuth = false,
      this.mockGoogleSignIn = false})
      : super(key: key);
  final bool testMode;
  final dynamic mockAuth;
  final dynamic mockGoogleSignIn;
  @override
  State<RegisterScreen> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  dynamic auth;

  @override
  void dispose() {
    emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  dynamic register() async {
    try {
      await auth
          .handleSignUp(emailController.text, _passwordController.text)
          .then((value) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error, please try again'),
      ));
    }
  }

  dynamic emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  }

  dynamic passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return null;
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
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
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
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Enter your email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String? value) => emailValidator(value),
                      controller: emailController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          labelText: 'Enter your password'),
                      validator: (String? value) => passwordValidator(value),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        register();
                      },
                      child: const Text('Register'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
