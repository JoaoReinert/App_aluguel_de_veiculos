import 'package:flutter/material.dart';
import '../customerRegistrationPage.dart';
import 'customerForm.dart';

Future<void> showCustomerDialog(BuildContext context, FunctionsCustomer state) async {
  showDialog(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: AlertDialog(
          shape: const BeveledRectangleBorder(),
          backgroundColor: Colors.white,
          title: const Text(
            'Customer Registration',
            style: TextStyle(color: Colors.blue),
          ),
          content: CustomerForm(
            state: state,
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
                await state.insert();
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    },
  );
}