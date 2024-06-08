import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/manager_button.dart';
import 'utils/manager_form.dart';

///provider referente ao estado dos gerentes
class FunctionManager extends ChangeNotifier {
  void alertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              shape: const BeveledRectangleBorder(),
              backgroundColor: Colors.white,
              title: const Text(
                'Manager Registration',
                style: TextStyle(color: Colors.blue),
              ),
              content: const ManagerForm(),
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
                  onPressed: () {},
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          );
        });
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
                    onpressed: () {
                      state.alertDialog(context);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
