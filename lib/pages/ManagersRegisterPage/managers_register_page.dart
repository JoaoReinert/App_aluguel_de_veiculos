import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/database.dart';
import '../../enum_states.dart';
import '../../models/managers_model.dart';
import 'utils/manager_button.dart';
import 'utils/manager_dialog.dart';

///provider referente ao estado dos gerentes
class FunctionManager extends ChangeNotifier {
  ///instancia do provider para sempre que for chamado, ele chamar a funcao load
  FunctionManager() {
    load();
  }
  /// Controlador para operações relacionadas aos clientes
  final controller = ManagerController();

  final _controllerName = TextEditingController();
  final _controllerCPF = TextEditingController();
  final _controllerState = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerComission = TextEditingController();
  States? _selectItem;
  final _listManager = <ManagerModel>[];

  /// Getter para o controlador de texto do campo nome
  TextEditingController get controllerName => _controllerName;

  /// Getter para o controlador de texto do campo cpf
  TextEditingController get controllerCPF => _controllerCPF;

  /// Getter para o controlador de texto do campo estado
  TextEditingController get controllerState => _controllerState;

  /// Getter para o controlador de texto do campo telefone
  TextEditingController get controllerPhone => _controllerPhone;

  /// Getter para o controlador de texto do campo comissao
  TextEditingController get controllerComission => _controllerComission;

  ///Getter para o controlador de item selecionado (estado)
  States? get selectItem => _selectItem;

  /// Getter para a lista de modelos de cliente
  List<ManagerModel> get listManager => _listManager;

  /// Função assíncrona para carregar os dados dos gerentes
  Future<void> load() async {
    final list = await controller.select();
    _listManager.clear();
    _listManager.addAll(list);
    print('Lista de gerentes carregada: $_listManager');  
    notifyListeners();
  }
  /// Função assíncrona para inserir um novo gerente
  Future<void> insert() async {
    final managers = ManagerModel(
        name: controllerName.text,
        cpf: controllerCPF.text,
        state: selectItem,
        phone: controllerPhone.text,
        comission: controllerComission.text);

    await controller.insert(managers);
    await load();

    controllerName.clear();
    controllerCPF.clear();
    _selectItem = null;
    controllerPhone.clear();
    controllerComission.clear();

    notifyListeners();
  }

  Future<void> delete(ManagerModel manager) async {
    await controller.delete(manager);
    await load();
    notifyListeners();
  }

  void updateState(States newValue) {
    _selectItem = newValue;
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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text('Managers'),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ManagerButton(
                    state: state,
                    onpressed: () {
                      showManagerDialog(context, state);
                    },
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: state.listManager.length,
                itemBuilder: (context, index) {
                  final manager = state.listManager[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Card(
                      color: const Color.fromARGB(255, 203, 202, 202),
                      elevation: 3,
                      shadowColor: Colors.black,
                      child: ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/managerDataPage',
                              arguments: manager);
                        },
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.white, width: 1),
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
                                state.delete(manager);
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
