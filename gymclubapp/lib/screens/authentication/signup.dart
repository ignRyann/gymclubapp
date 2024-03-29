// ignore_for_file: library_private_types_in_public_api,

import 'package:flutter/material.dart';
import 'package:gymclubapp/screens/screens.dart';
import 'package:gymclubapp/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Global Key to identify the Form Widget
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Error Messages
  String _errorMessage = '';
  bool _usernameAvailable = false;

  @override
  Widget build(BuildContext context) {
    // [Widget] Error Message
    final errorMessage = Text(
      _errorMessage,
      style: const TextStyle(fontSize: 14.0, color: Colors.red),
      textAlign: TextAlign.center,
    );

    // [Widget] Username TextFormField
    final username = TextFormField(
      controller: _usernameController,
      enableSuggestions: false,
      autocorrect: false,
      autofocus: false,
      keyboardType: TextInputType.text,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      onChanged: ((String text) async {
        final usernameAvailable = await AuthService().usernameAvailable(text);
        setState(() {
          _errorMessage = '';
          _usernameAvailable = usernameAvailable;
        });
      }),
      decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person_outline,
            color: Colors.white70,
          ),
          suffixIcon: _usernameAvailable
              ? const Icon(
                  Icons.check_outlined,
                  color: Colors.green,
                  size: 30.0,
                )
              : const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 30.0,
                ),
          labelText: 'Enter Username',
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
          filled: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: Colors.white.withOpacity(0.3),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(width: 0, style: BorderStyle.none))),
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
      keyboardType: TextInputType.emailAddress,
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
          labelText: 'Enter Email Address',
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
      validator: ((value) {
        if (value != null) {
          if (value.isEmpty) {
            return 'Please enter a password.';
          } else if (value.length < 6) {
            return 'Password must have a minimum of 6 characters.';
          }
        }
        return null;
      }),
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

    // [Widget] Confirm Password TextFormField
    final confirmPassword = TextFormField(
      validator: ((value) {
        if (value != null) {
          if (_passwordController.text != value) {
            return 'Passwords do not match.';
          } else if (value.length < 6) {
            return 'Password must have a minimum of 6 characters.';
          }
        }
        return null;
      }),
      controller: _confirmPasswordController,
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
        labelText: 'Confirm Password',
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
      ),
    );

    // [Widget] Sign Up Elevated Button
    final signUpButton = Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate() && _usernameAvailable) {
            await AuthService()
                .createUserWithEmailAndPassword(
                    _usernameController, _emailController, _passwordController)
                .then((string) {
              setState(() {
                _errorMessage = string;
              });
              if (string == '') {
                showPopUpDialog(
                    'An Email Verification has been sent!',
                    MaterialPageRoute(
                        builder: (((context) => const SignInScreen()))));
              }
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
          'SIGN UP',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );

    // Main Body
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: const Text(
              "Sign Up",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(gradient: gradientDesign()),
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
                    child: Column(
                      children: <Widget>[
                        logoWidget("images/dumbell.png", 120, 120),
                        const SizedBox(height: 20),
                        errorMessage,
                        const SizedBox(height: 20),
                        username,
                        const SizedBox(height: 20),
                        email,
                        const SizedBox(height: 20),
                        password,
                        const SizedBox(height: 20),
                        confirmPassword,
                        const SizedBox(height: 20),
                        signUpButton,
                        const SizedBox(height: 200),
                      ],
                    )),
              )),
        ));
  }

  // Pop Up Dialog
  void showPopUpDialog(String errorMsg, MaterialPageRoute? route) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            content: Text(
              errorMsg,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            //buttons?
            actions: <Widget>[
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(120)),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (route != null) {
                      Navigator.push(context, route);
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black;
                        }
                        return Colors.black;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)))),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
