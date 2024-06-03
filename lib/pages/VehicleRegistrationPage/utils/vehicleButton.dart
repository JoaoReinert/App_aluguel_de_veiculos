import 'package:flutter/material.dart';

class VehicleButton extends StatelessWidget {
  const VehicleButton({
    super.key,
  });

  // final void Function() onpressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(style: BorderStyle.none),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      onPressed: () {},
      icon: const Icon(
        Icons.directions_car,
        color: Colors.blue,
      ),
      label: const Text(
        'Vehicle Registration',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
