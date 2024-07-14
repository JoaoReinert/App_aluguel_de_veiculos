import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../controllers/customers_table.dart';
import '../../controllers/managers_table.dart';
import '../../controllers/states_table.dart';
import '../../models/managers_model.dart';
import '../../models/state_model.dart';
import '../../theme.dart';
import '../../utils/standard_delete_dialog.dart';
import '../../utils/standard_dialog.dart';
import '../../utils/standard_form_button.dart';

///provider referente ao estado dos gerentes
class FunctionManager extends ChangeNotifier {
  ///key para o formulario de cadastro do gerente
  final managerKey = GlobalKey<FormState>();

  ///instancia do provider para sempre que for chamado, ele chamar a funcao load
  FunctionManager() {
    load();
  }

  /// Controlador para operações relacionadas aos clientes
  final controller = ManagerController();
  ///controlador de estado do gerente
  final controllerEstado = EstadoController();
  ///controlador de cliente
  final controllerCustomer = CustomerController();

  final _controllerName = TextEditingController();
  final _controllerCPF = TextEditingController();
  final _controllerState = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerCommission = TextEditingController();
  EstadoModel? _selectItem;
  final _listManager = <ManagerModel>[];
  final _listEstado = <EstadoModel>[];
  ///controlador para a barra de pesquisa da tela
  final controllerResearch = TextEditingController();
  List<ManagerModel> _listManagerFilter = <ManagerModel>[];

  /// Getter para o controlador de texto do campo nome
  TextEditingController get controllerName => _controllerName;

  /// Getter para o controlador de texto do campo cpf
  TextEditingController get controllerCPF => _controllerCPF;

  /// Getter para o controlador de texto do campo estado
  TextEditingController get controllerState => _controllerState;

  /// Getter para o controlador de texto do campo telefone
  TextEditingController get controllerPhone => _controllerPhone;

  /// Getter para o controlador de texto do campo comissao
  TextEditingController get controllerCommission => _controllerCommission;

  ///Getter para o controlador de item selecionado (estado)
  EstadoModel? get selectItem => _selectItem;

  /// Getter para a lista de modelos de gerente
  List<ManagerModel> get listManager => _listManagerFilter;

  ///getter para a lista de estado
  List<EstadoModel> get listEstado => _listEstado;

  /// Função assíncrona para carregar os dados dos gerentes
  Future<void> load() async {
    final list = await controller.select();
    final listEstado = await controllerEstado.select();
    _listManager.clear();
    _listManager.addAll(list);
    _listEstado
      ..clear()
      ..addAll(listEstado);
    _listManagerFilter = _listManager;
    notifyListeners();
  }

  /// Função assíncrona para inserir um novo gerente
  Future<void> insert() async {
    if (selectItem == null) {
      return;
    }

    final managers = ManagerModel(
      name: controllerName.text,
      cpf: controllerCPF.text,
      state: selectItem!,
      phone: controllerPhone.text,
      comission: controllerCommission.text,
    );

    await controller.insert(managers);
    await load();

    controllerName.clear();
    controllerCPF.clear();
    _selectItem = null;
    controllerPhone.clear();
    controllerCommission.clear();

    notifyListeners();
  }

  ///funcao de delete para deletar o gerente do banco de dados
  Future<void> delete(ManagerModel manager) async {
    await controller.delete(manager);
    await load();
    notifyListeners();
  }

  ///funcao de update para controlar qual estado foi colocado
  void updateState(EstadoModel newValue) {
    _selectItem = newValue;
    notifyListeners();
  }
  ///mascara para formatar o telefone
  MaskTextInputFormatter formatterPhone = MaskTextInputFormatter(
      mask: '(##)#####-####', type: MaskAutoCompletionType.eager);
  ///mascara para formatar o cpf
  MaskTextInputFormatter formatterCpf = MaskTextInputFormatter(
      mask: '###.###.###-##', type: MaskAutoCompletionType.eager);

  ///funcao para verificacao de exclusao do gerente
  ///se tiver cliente ligado a ele, nao pode excluir
  Future<void> verificationDeleteManager(BuildContext context,
      ManagerModel manager) async {
    final function = await controllerCustomer
        .registeredStatesVerification(manager.state.cdEstado);
    if (function) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('It is not possible to delete this manager'),
            content: const Text('This manager has registered clients'),
            actions: [
              TextButton(
                child: const Text(
                  'Exit', style: TextStyle(color: Colors.blue),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) =>
            StandardDeleteDialog(
              name: manager.name,
              function: () async {
                await delete(manager);
              },
            ),
      );
    }
  }
  ///funcao para filtragem da barra de pesquisa da tela
  void filterManagers(String nameManager) {
    if (nameManager.isEmpty) {
      _listManagerFilter = _listManager;
    } else {
      _listManagerFilter = _listManager.where((manager) =>
          manager.name.toLowerCase().contains(nameManager.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

///criacao da tela de resgistro do gerente
class ManagersRegisterPage extends StatelessWidget {
  ///instancia da classe
  const ManagersRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FunctionManager(),
      child: Consumer<FunctionManager>(
        builder: (_, state, __) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: const Text('Managers'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StandardFormButton(
                    icon: const Icon(
                      Icons.work,
                      color: Colors.blue,
                    ),
                    label: 'Registration +',
                    onpressed: () async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return StandardDialog(
                            formKey: state.managerKey,
                            title: 'Manager registration',
                            actions: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
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
                                    if (state.managerKey.currentState!
                                        .validate()) {
                                      await state.insert();
                                      if (!context.mounted) return;
                                      Navigator.of(context).pop();
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
                                textCapitalization: TextCapitalization.words,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                decoration: decorationForm('Name'),
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Enter the manager name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: state.controllerCPF,
                                inputFormatters: [state.formatterCpf],
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                decoration: decorationForm('CPF'),
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Enter the manager CPF';
                                  } if(value!.length < 10) {
                                    return 'Invalid CPF';
                                  }
                                  return null;
                                },
                              ),
                              DropdownButtonFormField<EstadoModel>(
                                value: state.selectItem,
                                onChanged: (value) {
                                  state.updateState(value!);
                                },
                                items: state.listEstado.map(
                                      (state) {
                                    return DropdownMenuItem(
                                      value: state,
                                      child: Text(state.sgEstado),
                                    );
                                  },
                                ).toList(),
                                decoration: decorationForm('States'),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                                iconEnabledColor: Colors.blue,
                              ),
                              TextFormField(
                                controller: state.controllerPhone,
                                inputFormatters: [state.formatterPhone],
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                decoration: decorationForm('Phone'),
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Enter the manager telephone number';
                                  }
                                  if (value!.length < 10) {
                                    return 'Invalid number';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: state.controllerCommission,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                                decoration: decorationForm('Comission'),
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return 'Enter the manager comission';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    controller: state.controllerResearch,
                    onChanged: state.filterManagers,
                    decoration: decorationSearch(
                      'Search Managers',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state.listManager.isEmpty) {
                          return const Center(
                            child: Text(
                              'No managers registered',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: state.listManager.length,
                            itemBuilder: (context, index) {
                              final manager = state.listManager[index];
                              return Padding(
                                padding: const EdgeInsets.all(2),
                                child: Card(
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.grey[350],
                                  elevation: 3,
                                  shadowColor: Colors.black,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/managerDataPage',
                                          arguments: manager);
                                    },
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.white, width: 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    title: Text(
                                      manager.name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    subtitle: Text('CPF: ${manager.cpf}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            state.verificationDeleteManager(
                                                context, manager);
                                          },
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
