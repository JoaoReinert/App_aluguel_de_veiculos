import 'package:flutter/material.dart';

import '../../../theme.dart';

class CustomerDataForm extends StatefulWidget {
  const CustomerDataForm({super.key});

  @override
  State<CustomerDataForm> createState() => _CustomerDataFormState();
}

class _CustomerDataFormState extends State<CustomerDataForm> {
  final _customerDataForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _customerDataForm,
      child: Column(
          children: [
            
          ],
      ),
    );
  }
}