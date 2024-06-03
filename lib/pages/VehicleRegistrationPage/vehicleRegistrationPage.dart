import 'package:flutter/material.dart';

import 'utils/vehicleButton.dart';

class VehicleRegistrationPage extends StatelessWidget {
  const VehicleRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
       actions: const [
           Padding(
            padding: EdgeInsets.all(8.0),
            child: VehicleButton(),
          ),
       ],
      ),
    );
  }
}
