import 'package:flutter/material.dart';

final theme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  textTheme: Typography.whiteCupertino,
  appBarTheme: const AppBarTheme(
    toolbarHeight: 80,
    backgroundColor: Colors.blue,
    titleTextStyle: TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.grey,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.white,
    selectedIconTheme: IconThemeData(color: Colors.blue),
    unselectedIconTheme: IconThemeData(color: Colors.white),
    selectedLabelStyle: TextStyle(color: Colors.blue),
    unselectedLabelStyle: TextStyle(color: Colors.white),
  ),
);

InputDecoration decorationForm(String label) {
  return InputDecoration(
    label: Text(label),
    labelStyle: const TextStyle(fontSize: 18, color: Colors.blue),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 1),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide:
          BorderSide(color: Colors.blue, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2),
      borderRadius: BorderRadius.all(
        Radius.circular(4),
      ),
    ),
  );
}
