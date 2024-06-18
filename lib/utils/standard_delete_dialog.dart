import 'package:flutter/material.dart';

class StandardDeleteDialog extends StatelessWidget {
  StandardDeleteDialog({super.key, required this.name, required this.function});

  String name;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete',
        style: TextStyle(color: Colors.red),
      ),
      content: Text(
        'Tem certeza que deseja excluir o $name?',
        style: TextStyle(color: Colors.black),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.red))),
        TextButton(
          onPressed: () {
            function();
            Navigator.pop(context);
          },
          child: Text('Yes', style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
    ;
  }
}
