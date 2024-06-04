import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customersModel.dart';
import 'utils/customerButton.dart';
import 'utils/customerForm.dart';
import '../../../generalControllers.dart';

class FunctionsCustomer extends ChangeNotifier {
  final _controllerName = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerCNPJ = TextEditingController();
  final _controllerCity = TextEditingController();
  States? _controllerStates;

  TextEditingController get controllerName => _controllerName;
  TextEditingController get controllerPhone => _controllerPhone;
  TextEditingController get controllerCNPJ => _controllerCNPJ;
  TextEditingController get controllerCity => _controllerCity;
  States? get controllerStates => _controllerStates;

  final _listCustomer = <CustomerModel>[];
  List<CustomerModel> get listCustomer => _listCustomer;

  void include(CustomerModel customer) {
    _listCustomer.add(customer);
    notifyListeners();
  }

  void insert() {
    final customers = CustomerModel(
        name: controllerName.text,
        phone: controllerPhone.text,
        cnpj: controllerCNPJ.text,
        city: controllerCity.text,
        state: controllerStates.toString());

    include(customers);
  }

  void alertDialog(BuildContext context) {
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
            content: const CustomerForm(),
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
                onPressed: () {
                  insert();
                  Navigator.of(context).pop();
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
}

class CustomerRegistrationPage extends StatelessWidget {
  const CustomerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final listaNaMao = [
      CustomerModel(
          name: 'João',
          phone: '47999473769',
          cnpj: '89114230',
          city: 'Gaspar',
          state: 'SC'),
      CustomerModel(
          name: 'Felipe',
          phone: '473484020',
          cnpj: '3948204',
          city: 'Gaspar',
          state: 'SC')
    ];

    return ChangeNotifierProvider(
      create: (context) => FunctionsCustomer(),
      child: Consumer<FunctionsCustomer>(
        builder: (_, state, __) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Customers'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomerButton(
                    onpressed: () {
                      state.alertDialog(context);
                    },
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: listaNaMao.length,
                itemBuilder: (context, index) {
                  final customer = listaNaMao[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text(
                        customer.name,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(customer.cnpj),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
