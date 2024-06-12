import 'package:flutter/material.dart';
import '../managers_register_page.dart';
import 'manager_form.dart';

Future<void> showManagerDialog(
    BuildContext context, FunctionManager state) async {
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
              state: state,
              managerFormKey: managerFormKey,
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
                onPressed: () async {
                  if (managerFormKey.currentState!.validate()) {
                    await state.insert();
                    Navigator.of(context).pop();
                  } else {
                    managerFormKey.currentState!.validate();
                  }
                },
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
