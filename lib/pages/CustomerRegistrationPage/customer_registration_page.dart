import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/database.dart';
import '../../enum_states.dart';
import '../../models/customers_model.dart';
import 'utils/customer_button.dart';
import 'utils/customer_dialog.dart';

///provider referente ao estado dos clientes
class FunctionsCustomer extends ChangeNotifier {
  ///instancia do provider para sempre que for chamado, ele chamar a funcao load
  FunctionsCustomer() {
    load();
  }

  /// Controlador para operações relacionadas aos clientes
  final controller = CustomerController();

  final _controllerName = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerCNPJ = TextEditingController();
  final _controllerCity = TextEditingController();
  States? _selectItem;
  final _listCustomer = <CustomerModel>[];

  /// Getter para o controlador de texto do campo nome
  TextEditingController get controllerName => _controllerName;

  /// Getter para o controlador de texto do campo telefone
  TextEditingController get controllerPhone => _controllerPhone;

  /// Getter para o controlador de texto do campo cnpj
  TextEditingController get controllerCNPJ => _controllerCNPJ;

  /// Getter para o controlador de texto do campo cidade
  TextEditingController get controllerCity => _controllerCity;

  States? get selectItem => _selectItem;

  /// Getter para a lista de modelos de cliente
  List<CustomerModel> get listCustomer => _listCustomer;

  /// Função assíncrona para carregar os dados dos clientes
  Future<void> load() async {
    final list = await controller.select();
    _listCustomer.clear();
    _listCustomer.addAll(list);
    notifyListeners();
  }

  /// Função assíncrona para inserir um novo cliente
  Future<void> insert() async {
    final customers = CustomerModel(
      name: controllerName.text,
      phone: controllerPhone.text,
      cnpj: controllerCNPJ.text,
      city: controllerCity.text,
      state: selectItem,
    );

    await controller.insert(customers);
    await load();

    controllerName.clear();
    controllerPhone.clear();
    controllerCNPJ.clear();
    controllerCity.clear();
    _selectItem = null;
    notifyListeners();
  }

  /// Função assíncrona para deletar um cliente
  Future<void> delete(CustomerModel customer) async {
    await controller.delete(customer);
    await load();

    notifyListeners();
  }

  void updateState(States newValue) {
    _selectItem = newValue;
    notifyListeners();
  }
}

///criacao da tela de resgistro do cliente
class CustomerRegistrationPage extends StatelessWidget {
  ///instancia da classe
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
                        onTap: () {
                          Navigator.pushNamed(context, '/customerDataPage',
                              arguments: customer);
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          customer.name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text('CNPJ: ${customer.cnpj}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                state.delete(customer);
                              },
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
