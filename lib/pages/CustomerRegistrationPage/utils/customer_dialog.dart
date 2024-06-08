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
                if (customerFormKey.currentState!.validate()) {
                  await state.insert();
                  Navigator.of(context).pop();
                  print('Name: ${state.controllerName.text}');
                  print('Phone: ${state.controllerPhone.text}');
                  print('CNPJ: ${state.controllerCNPJ.text}');
                  print('City: ${state.controllerCity.text}');
                  print('State: ${state.controllerStates?.toString() ?? ''}');
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
