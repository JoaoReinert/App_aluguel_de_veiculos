

import 'package:flutter/material.dart';

class Delete_dialog extends StatelessWidget {
   Delete_dialog({super.key,required this.nameCustomer, required this.function});

  String nameCustomer;
  final Function() function;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete'),
      content: Text('Tem certeza que deseja excluir o $nameCustomer'),
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
    );
  }
}
