import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../controllers/customers_table.dart';
import '../../models/customers_model.dart';
import '../../theme.dart';
import '../../utils/standard_dialog.dart';
import '../../utils/standard_edit_button.dart';

///state da tela de detalhes do cliente
class CustomerDataPageState extends ChangeNotifier {
  ///variavel para controlar o cliente e pegar as variaveis dele
  final CustomerModel customer;

  ///controlador de nome para edição
  final TextEditingController controllerName = TextEditingController();

  ///controlador de telefone para edição
  final TextEditingController controllerPhone = TextEditingController();

  ///controlador de cidade para edição
  final TextEditingController controllerCity = TextEditingController();

  ///controlador de cliente
  final controllerCustomer = CustomerController();

  ///construtor
  CustomerDataPageState(this.customer);

  ///funcao para edicao do nome do cliente
  Future<void> updateName(BuildContext context, String newName) async {
    customer.name = newName;
    await controllerCustomer.updateName(customer.id!, newName);
    notifyListeners();
  }

  ///funcao para edicao do telefone do cliente
  Future<void> updatePhone(BuildContext context, String newPhone) async {
    customer.phone = newPhone;
    await controllerCustomer.updatePhone(customer.id!, newPhone);
    notifyListeners();
  }

  ///funcao para edicao do cidade do cliente
  Future<void> updateCity(BuildContext context, String newCity) async {
    customer.city = newCity;
    await controllerCustomer.updateCity(customer.id!, newCity);
    notifyListeners();
  }

  ///mascara para formatar o telefone no campo de texto
  MaskTextInputFormatter formatterPhone = MaskTextInputFormatter(
      mask: '(##)#####-####', type: MaskAutoCompletionType.eager);
}

///criacao da pagina de dados do cliente
class CustomerDataPage extends StatelessWidget {
  ///instancia da pagina
  const CustomerDataPage({super.key, required this.customer});

  ///puxando o modelo de cliente que sera exibido nessa pagina
  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CustomerDataPageState(customer),
      child: Consumer<CustomerDataPageState>(builder: (_, state, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            toolbarHeight: 60,
          ),
          backgroundColor: Colors.blue,
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            customer.name,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text('Personal information',
                            style:
                                TextStyle(color: Colors.black, fontSize: 25)),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Phone -',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              customer.phone,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.business),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'CNPJ -',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              customer.cnpj,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'City -',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              customer.city,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.map),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'State -',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              customer.state.sgEstado,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.account_balance),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Company -',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (customer.companyName.isNotEmpty)
                              Expanded(
                                child: Text(
                                  customer.companyName,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  softWrap: true,
                                ),
                              ),
                            if (customer.companyName.isEmpty)
                              const Expanded(
                                child: Text(
                                  'Name not found',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                  softWrap: true,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Icon(Icons.work),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Manager -',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              customer.manager!.name,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StandardEditButton(
                          label: 'Name',
                          onpressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StandardDialog(
                                  title: 'Edit Name',
                                  actions: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final newName =
                                              state.controllerName.text;
                                          if (newName.isNotEmpty) {
                                            state.updateName(context,
                                                state.controllerName.text);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: [
                                    TextFormField(
                                      controller: state.controllerName,
                                      keyboardType: TextInputType.name,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      decoration: decorationForm('New Name'),
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return 'Enter the new name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                        StandardEditButton(
                          label: 'Phone',
                          onpressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StandardDialog(
                                  title: 'Edit Phone',
                                  actions: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final newPhone =
                                              state.controllerPhone.text;
                                          if (newPhone.isNotEmpty) {
                                            state.updatePhone(context,
                                                state.controllerPhone.text);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: [
                                    TextFormField(
                                      controller: state.controllerPhone,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [state.formatterPhone],
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      decoration: decorationForm('New phone'),
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return 'Enter the new phone';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StandardEditButton(
                          label: 'City',
                          onpressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StandardDialog(
                                  title: 'Edit City',
                                  actions: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final newCity =
                                              state.controllerCity.text;
                                          if (newCity.isNotEmpty) {
                                            state.updateCity(context,
                                                state.controllerCity.text);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text(
                                          'Save',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                  items: [
                                    TextFormField(
                                      controller: state.controllerCity,
                                      keyboardType: TextInputType.name,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      style: const TextStyle(
                                          fontSize: 15, color: Colors.black),
                                      decoration: decorationForm('New City'),
                                      validator: (value) {
                                        if (value != null && value.isEmpty) {
                                          return 'Enter the new City';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
