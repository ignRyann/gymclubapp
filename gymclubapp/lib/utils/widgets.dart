import 'package:flutter/material.dart';
import 'colour_utils.dart';

// Gradient Widget
LinearGradient gradientDesign() {
  return LinearGradient(colors: [
    hexStringToColor("000000"),
    hexStringToColor("2d2b2e"),
    hexStringToColor("000000"),
  ], begin: Alignment.topCenter, end: Alignment.bottomCenter);
}

// Image Widget
Image logoWidget(String imageName, double w, double h) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: w,
    height: h,
    color: Colors.white,
  );
}

// TextField Widget
TextField reusableTextField(
    String text, IconData icon, TextEditingController controller) {
  return TextField(
    controller: controller,
    enableSuggestions: false,
    autocorrect: false,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
  );
}
