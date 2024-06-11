import 'package:flutter/material.dart';
import 'models/customers_model.dart';
import 'pages/CustomerDataPage/customer_data_page.dart';
import 'pages/CustomerRegistrationPage/customer_registration_page.dart';
import 'pages/HomePage/home_page.dart';
import 'pages/ManagerDataPage/manager_data_page.dart';
import 'pages/ManagersRegisterPage/managers_register_page.dart';
import 'pages/RentsPage/rents_page.dart';
import 'pages/VehicleRegistrationPage/vehicle_registration_page.dart';
import 'theme.dart';

///criacao da classe onde ira ficar todo meu aplicativo,
/// chamando apenas na main para organizacao
class MyWidget extends StatelessWidget {
  ///instancia da classe
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(context),
      initialRoute: '/homePage',
      // criando on generate para passar os argumentos para
      // usar navigator.pushnamed para tela de dados dos clientes
       onGenerateRoute: (settings) {
        if (settings.name == '/customerDataPage') {
          final customer = settings.arguments as CustomerModel;
          return MaterialPageRoute(
            builder: (context) {
              return CustomerDataPage(customer: customer);
            },
          );
        }
      },
      routes: {
        '/homePage': (context) => const HomePage(),
        '/customerRegistrationPage': (context) =>
            const CustomerRegistrationPage(),
        '/managersRegisterPage': (context) => const ManagersRegisterPage(),
        '/vehicleRegistrationPage': (context) =>
            const VehicleRegistrationPage(),
        '/rentsPage': (context) => const RentsPage(),
        '/managerDataPage':(context) => const ManagerDataPage(),
      },
    );
  }
}
