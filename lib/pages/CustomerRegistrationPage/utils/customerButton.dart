import 'package:flutter/material.dart';

class CustomerButton extends StatelessWidget {
  const CustomerButton({
    super.key,
    required this.onpressed
  });

  final void Function() onpressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(style: BorderStyle.none),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      onPressed: onpressed,
      icon: const Icon(Icons.person, color: Colors.blue,),
      label: const Text(
        'Customers Registration',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
