// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:gymclubapp/utils/utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Global Key to identify the Form Widget
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Error Messages
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    // [Widget] Error Message
    var errorMessage = Text(
      _errorMessage,
      style: const TextStyle(fontSize: 14.0, color: Colors.red),
      textAlign: TextAlign.center,
    );

    // [Widget] Email TextFormField
    final email = TextFormField(
      validator: ((value) {
        if (value != null) {
          if (value.isEmpty || !value.contains('@')) {
            return 'Please enter a valid email.';
          }
        }
        return null;
      }),
      controller: _emailController,
      enableSuggestions: false,
      autocorrect: false,
      autofocus: false,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      onChanged: ((String text) {
        setState(() {
          _errorMessage = '';
        });
      }),
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person_outline,
            color: Colors.white70,
          ),
          labelText: 'Enter Username/Email',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
    );

    // [Widget] Password TextFormField
    final password = TextFormField(
      controller: _passwordController,
      obscureText: true,
      enableSuggestions: false,
      autocorrect: false,
      autofocus: false,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      textInputAction: TextInputAction.done,
      onChanged: ((String text) {
        setState(() {
          _errorMessage = '';
        });
      }),
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.white70,
        ),
        labelText: 'Enter Password',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );

    // [Widget] Forget Password GestureDetector
    final forgetPassword = Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgetPasswordScreen()));
              },
              child: const Text(
                "Forgotten Password?",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));

    // [Widget] Login Elevated Button
    final signInButton = Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await AuthService()
                .signInWithEmailAndPassword(
                    _emailController, _passwordController)
                .then((string) async {
              if (string != '') {
                setState(() {
                  _errorMessage = string;
                });
              }
              // if (string == '') {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const HomeScreen()));
              // }
            });
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              return Colors.white;
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)))),
        child: const Text(
          'LOG IN',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    // [Widget] Sign Up GestureDetector
    final signUp = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );

    // [Widget] Main Body Scaffold
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: gradientDesign()),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.1, 20, 0),
                    child: Column(
                      children: <Widget>[
                        logoWidget("images/dumbell.png", 240, 240),
                        const SizedBox(
                          height: 120,
                        ),
                        errorMessage,
                        const SizedBox(
                          height: 20,
                        ),
                        email,
                        const SizedBox(
                          height: 20,
                        ),
                        password,
                        forgetPassword,
                        const SizedBox(height: 20),
                        signInButton,
                        signUp,
                      ],
                    ))),
          )),
    );
  }
}
