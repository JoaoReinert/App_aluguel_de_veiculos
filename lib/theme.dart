import 'package:flutter/material.dart';

ThemeData theme(BuildContext context) {
  final theme = Theme.of(context);
  return theme.copyWith(
    scaffoldBackgroundColor: Colors.white,
    textTheme: Typography.whiteCupertino,
    appBarTheme: const AppBarTheme(
      toolbarHeight: 75,
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: theme.bottomNavigationBarTheme.copyWith(
      backgroundColor: Colors.blue,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white60,
      unselectedLabelStyle: TextStyle(
        color: Colors.grey,
      ),
    ),
  );
}

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
      borderSide: BorderSide(color: Colors.blue, width: 2),
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
