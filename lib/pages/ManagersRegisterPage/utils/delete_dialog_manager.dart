import 'package:flutter/material.dart';

class Delete_dialog_manager extends StatelessWidget {
   Delete_dialog_manager({super.key, required this.nameManager, required this.function});

  String nameManager;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete'),
      content: Text('Tem certeza que deseja excluir o $nameManager'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            }, child: Text('Cancel')),
        TextButton(onPressed: () {
          function();
          Navigator.pop(context);
        }, child: Text('Yes'),),

      ],
    );;
  }
}
