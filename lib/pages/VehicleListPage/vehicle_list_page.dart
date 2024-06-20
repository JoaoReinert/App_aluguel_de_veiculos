import 'package:flutter/material.dart';

import '../../utils/standard_form_button.dart';

///criacao da tela de resgistro do veiculo
class VehicleRegistrationPage extends StatelessWidget {
  ///instancia da classe
  const VehicleRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: StandardFormButton(
              onpressed: () {
                Navigator.pushNamed(context, '/vehicle');
              },
              icon: const Icon(
                Icons.directions_car,
                color: Colors.blue,
              ),
              label: 'Registration +',
            ),
          ),
        ],
      ),
      
    );
  }
}
