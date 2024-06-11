import 'package:flutter/material.dart';

import '../managers_register_page.dart';
import 'manager_form.dart';

Future <void> showCustomerDialog(BuildContext context, FunctionManager state) async {
  final managerFormKey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            shape: const BeveledRectangleBorder(),
            backgroundColor: Colors.white,
            title: const Text(
              'Manager Registration',
              style: TextStyle(color: Colors.blue),
            ),
            content: ManagerForm(
              key: managerFormKey,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        );
      });
}