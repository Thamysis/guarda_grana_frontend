import 'package:flutter/material.dart';

// Sempre use valores de 0 a 255 no ARGB. O primeiro valor é opacidade: 255 = 100%, 1 = quase transparente
class AppColors {
  static const Color primary = Color.fromARGB(255, 111, 69, 233);
  static const Color accent = Color.fromARGB(255, 51, 16, 152);
  static const Color bg = Color(0xFFF7F7F9);
  static const Color green = Color.fromARGB(255, 42, 144, 126);
  static const Color red = Color.fromARGB(255, 184, 50, 50);
  static const Color bgGreen = Color.fromARGB(255, 217, 255, 250);
  static const Color bgRed = Color.fromARGB(255, 255, 214, 214);
  static const Color brightYellow = Color.fromARGB(255, 253, 194, 40);
}