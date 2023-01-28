import 'package:flutter/material.dart';
import 'package:mymeals/screens/login_screen.dart';
import 'package:mymeals/services/auth.dart';

class ResetPassScreen extends StatefulWidget {
  ResetPassScreen(
      {Key? key,
      this.testMode = false,
      this.mockAuth = false,
      this.mockGoogleSignIn = false})
      : super(key: key) {
    if (!testMode) {
      auth = Auth();
    } else {
      auth = Auth(
          testMode: testMode,
          mockAuth: mockAuth,
          mockGoogleSignIn: mockGoogleSignIn);
    }
  }

  final bool testMode;
  final dynamic mockAuth;
  final dynamic mockGoogleSignIn;
  dynamic auth;
  @override
  State<ResetPassScreen> createState() => ResetPassScreenState();
}

class ResetPassScreenState extends State<ResetPassScreen> {
  final emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String resetButtonText = "Reset";
  bool emailSent = false;

  @override
  void dispose() {
    emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    resetButtonText = "Reset";
    emailSent = false;
    super.initState();
  }

  dynamic sendResetCode() async {
    try {
      await widget.auth.resetPassword(emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
              "Please Follow Instructions sent by email to reset your password"),
          action: SnackBarAction(
            label: "Login",
            onPressed: (() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }),
          )));
      emailSent = true;
      resetButtonText = "Back to Login";
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("An error Occured"),
      ));
    }
  }

  dynamic buttonController() async {
    if (!emailSent) {
      await sendResetCode();
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      return LoginScreen;
    }
  }

  dynamic emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Image(
                          image: AssetImage('assets/images/appLogo.png'))),
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
                      ElevatedButton(
                          onPressed: () {
                            buttonController();
                          },
                          child: Text(resetButtonText)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
