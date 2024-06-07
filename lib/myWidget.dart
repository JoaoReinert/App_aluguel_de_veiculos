import 'package:flutter/material.dart';
import 'pages/CustomerDataPage/customerDataPage.dart';
import 'pages/CustomerRegistrationPage/customerRegistrationPage.dart';
import 'pages/HomePage/homePage.dart';
import 'pages/ManagersRegisterPage/managersRegisterPage.dart';
import 'pages/RentsPage/rentsPage.dart';
import 'pages/VehicleRegistrationPage/vehicleRegistrationPage.dart';
import 'theme.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme(context),
        initialRoute: '/homePage',
        routes: {
          '/homePage' : (context) => const HomePage(),
          '/customerRegistrationPage' : (context) => const CustomerRegistrationPage(),
          '/managersRegisterPage' : (context) => const ManagersRegisterPage(),
          '/vehicleRegistrationPage' : (context) => const VehicleRegistrationPage(),
          '/rentsPage' : (context) => const RentsPage(),
          '/customerDataPage' : (context) => const CustomerDataPage(),
        },
    );
  }
}