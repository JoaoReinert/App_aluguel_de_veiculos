import 'package:flutter/material.dart';

import 'utils/customerDataForm.dart';

class CustomerDataPage extends StatelessWidget {
  const CustomerDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          title: const Text('Customer Data'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: CustomerDataForm(),
        ));
  }
}
