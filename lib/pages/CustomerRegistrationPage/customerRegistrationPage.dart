import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/database.dart';
import '../../models/customers_model.dart';
import 'utils/customerButton.dart';
import '../../../generalControllers.dart';
import 'utils/customer_dialog.dart';

class FunctionsCustomer extends ChangeNotifier {
  FunctionsCustomer() {
    load();
  }

  final controller = CustomerController();

  final _controllerName = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerCNPJ = TextEditingController();
  final _controllerCity = TextEditingController();
  States? _controllerStates;
  final _listCustomer = <CustomerModel>[];

  TextEditingController get controllerName => _controllerName;

  TextEditingController get controllerPhone => _controllerPhone;

  TextEditingController get controllerCNPJ => _controllerCNPJ;

  TextEditingController get controllerCity => _controllerCity;

  States? get controllerStates => _controllerStates;

  List<CustomerModel> get listCustomer => _listCustomer;

  Future<void> load() async {
    final list = await controller.select();

    listCustomer.clear();
    listCustomer.addAll(list);

    notifyListeners();
  }

  Future<void> insert() async {
    final customers = CustomerModel(
      name: controllerName.text,
      phone: controllerPhone.text,
      cnpj: controllerCNPJ.text,
      city: controllerCity.text,
      state: controllerStates?.toString() ?? '',
    );

    await controller.insert(customers);
    await load();

    controllerName.clear();
    controllerPhone.clear();
    controllerCNPJ.clear();
    controllerCity.clear();

    notifyListeners();
  }

  Future<void> delete(CustomerModel customer) async {
    await controller.delete(customer);
    await load();

    notifyListeners();
  }
}

class CustomerRegistrationPage extends StatelessWidget {
  const CustomerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      showCustomerDialog(context, state);
                    },
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: state.listCustomer.length,
                itemBuilder: (context, index) {
                  final customer = state.listCustomer[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Card(
                      color: const Color.fromARGB(255, 203, 202, 202),
                      elevation: 3,
                      shadowColor: Colors.black,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          customer.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text('CNPJ: ${customer.cnpj}'),
                        onTap: () {
                          Navigator.pushNamed(context, '/customerDataPage',
                              arguments: customer);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
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
