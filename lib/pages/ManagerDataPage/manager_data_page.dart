import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../controllers/managers_table.dart';
import '../../models/managers_model.dart';
import '../../theme.dart';
import '../../utils/standard_dialog.dart';
import '../../utils/standard_edit_button.dart';

///criacao do state da tela de dados do gerente
class ManagerDataPageState extends ChangeNotifier {
  ///variavel para mostrar os dados do gerente
  final ManagerModel manager;

  ///controlador de nome para edicao
  final TextEditingController controllerName = TextEditingController();

  ///controlador de cpf para edicao
  final TextEditingController controllerCPF = TextEditingController();

  ///controlador de telefone para edicao
  final TextEditingController controllerPhone = TextEditingController();

  ///controlador de comissao para edicao
  final TextEditingController controllerCommission = TextEditingController();

  ///controlador de gerente
  final controllerManager = ManagerController();

  ///construtor
  ManagerDataPageState(this.manager);

  ///funcao para editar o nome do gerentee
  Future<void> updateName(BuildContext context, String newName) async {
    manager.name = newName;
    await controllerManager.updateName(manager.id!, newName);
    notifyListeners();
  }

  ///funcao para editar o cpf do gerentee
  Future<void> updateCPF(BuildContext context, String newCPF) async {
    manager.cpf = newCPF;
    await controllerManager.updateCPF(manager.id!, newCPF);
    notifyListeners();
  }

  ///funcao para editar o telefone do gerentee
  Future<void> updatePhone(BuildContext context, String newPhone) async {
    manager.phone = newPhone;
    await controllerManager.updatePhone(manager.id!, newPhone);
    notifyListeners();
  }

  ///funcao para editar a comissao do gerentee
  Future<void> updateCommission(
      BuildContext context, String newCommission) async {
    manager.comission = newCommission;
    await controllerManager.updateCommission(manager.id!, newCommission);
    notifyListeners();
  }

  ///mascara para formatar o telefone
  MaskTextInputFormatter formatterPhone = MaskTextInputFormatter(
      mask: '(##)#####-####', type: MaskAutoCompletionType.eager);

  ///mascara para formatar o cpf
  MaskTextInputFormatter formatterCpf = MaskTextInputFormatter(
      mask: '###.###.###-##', type: MaskAutoCompletionType.eager);
}

///criacao da pagina de dados do gerente
class ManagerDataPage extends StatelessWidget {
  ///instancia da pagina
  const ManagerDataPage({super.key, required this.manager});

  ///puxando o modelo de gerente que sera exibido nessa pagina
  final ManagerModel manager;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ManagerDataPageState(manager),
      child: Consumer<ManagerDataPageState>(builder: (_, state, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            toolbarHeight: 60,
          ),
          backgroundColor: Colors.blue,
          body: Container(
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
                          manager.name,
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
                          style: TextStyle(color: Colors.black, fontSize: 25)),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.account_circle),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'CPF -',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            manager.cpf,
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
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            manager.state.sgEstado,
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
                          const Icon(Icons.phone),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Phone -',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            manager.phone,
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
                          const Icon(Icons.attach_money_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Comission -',
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${manager.comission}%',
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
                        label: 'CPF',
                        onpressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StandardDialog(
                                title: 'Edit CPF',
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
                                        final newCpf = state.controllerCPF.text;
                                        if (newCpf.isNotEmpty) {
                                          state.updateCPF(context,
                                              state.controllerCPF.text);
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
                                    controller: state.controllerCPF,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [state.formatterCpf],
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                    decoration: decorationForm('New CPF'),
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return 'Enter the new CPF';
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
                                    decoration: decorationForm('New Phone'),
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
                      StandardEditButton(
                        label: 'Commission',
                        onpressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StandardDialog(
                                title: 'Edit commission',
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
                                        final newComission =
                                            state.controllerCommission.text;
                                        if (newComission.isNotEmpty) {
                                          state.updateCommission(context,
                                              state.controllerCommission.text);
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
                                    controller: state.controllerCommission,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black),
                                    decoration:
                                        decorationForm('New commission'),
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return 'Enter the new commission';
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
