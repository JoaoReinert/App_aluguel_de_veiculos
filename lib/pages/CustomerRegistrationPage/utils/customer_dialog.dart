import 'package:flutter/material.dart';
import '../customer_registration_page.dart';
import 'customer_form.dart';

Future<void> showCustomerDialog(
    BuildContext context, FunctionsCustomer state) async {
  final customerFormKey = GlobalKey<FormState>();
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
            customerFormKey: customerFormKey,
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
                state.cnpjverified = false;
                if (customerFormKey.currentState!.validate()) {
                  await state.checkCnpj();
                if (state.cnpjverified && !state.error) {
                  await state.insert();
                  Navigator.of(context).pop();
                } else {
                  customerFormKey.currentState!.validate();
                }
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
    },
  );
}
