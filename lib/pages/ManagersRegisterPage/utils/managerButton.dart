import 'package:flutter/material.dart';

class ManagerButton extends StatelessWidget {
   const ManagerButton({
    required this.onpressed,
    super.key,
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
      icon: const Icon(Icons.work, color: Colors.blue,),
      label: const Text(
        'Manager Registration',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
