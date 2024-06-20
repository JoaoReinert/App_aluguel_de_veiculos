import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
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

DropDownDecoratorProps dropdownDecoration(String label) {
  return DropDownDecoratorProps(
    dropdownSearchDecoration: InputDecoration(
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      labelText: label, labelStyle: TextStyle(color: Colors.black, fontSize: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
    ),
  );
}

TextFieldProps searchFieldDecoration() {
  return const TextFieldProps(
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      prefixIcon: Icon(Icons.search)
    ),
    style: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  );
}


