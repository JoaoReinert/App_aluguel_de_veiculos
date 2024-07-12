import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
///criacao do tema do app
ThemeData theme(BuildContext context) {
  final theme = Theme.of(context);
  return theme.copyWith(
    scaffoldBackgroundColor: Colors.white,
    textTheme: Typography.blackCupertino,
    appBarTheme: const AppBarTheme(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20)
        )
      ),
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
      unselectedItemColor: Colors.white70,
      unselectedLabelStyle: const TextStyle(
        color: Colors.grey,
      ),
    ),
    datePickerTheme: const DatePickerThemeData(
      backgroundColor: Colors.white,
      dayStyle: TextStyle(color: Colors.blue),
      yearStyle: TextStyle(color: Colors.blue),
      headerForegroundColor: Colors.white,
      headerBackgroundColor: Colors.blue,
    ),

  );
}
///decoracao da barra de pesquisa
InputDecoration decorationSearch(String text) {
  return InputDecoration(
    hintText: text,
    hintStyle: const TextStyle(fontSize: 18, color: Colors.white),
    filled: true,
    fillColor: Colors.grey[500],
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(40),
      ),
    ),
    prefixIcon: const Icon(Icons.search, color: Colors.white),
  );
}
///decoracao dos formularios
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
///decoracao do props do drop down de pesquisa
MenuProps menuPropsDecoration() {
  return MenuProps(
    backgroundColor: const Color(0xFFDDEEFF),
    borderRadius: BorderRadius.circular(8),
    shadowColor: Colors.black
  );
}
///decoracao do drop down
DropDownDecoratorProps dropdownDecoration(String label) {
  return DropDownDecoratorProps(
    dropdownSearchDecoration: InputDecoration(
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
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    ),
    baseStyle: const TextStyle(color: Colors.black, fontSize: 17),
  );
}
///decoracao do drop down de pesquisa
TextFieldProps searchFieldDecoration() {
  return const TextFieldProps(
    decoration: InputDecoration(
      labelStyle: TextStyle(fontSize: 18, color: Colors.blue),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      prefixIcon: Icon(Icons.search),
      focusColor: Colors.blue, // Adiciona cor de foco
    ),
    style: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
  );
}




