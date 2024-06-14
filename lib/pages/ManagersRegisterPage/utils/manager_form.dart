import 'package:flutter/material.dart';
import '../../../enum_states.dart';
import '../../../theme.dart';
import '../managers_register_page.dart';

///formulario referente ao cadastro de gerentes
class ManagerForm extends StatelessWidget {
  ///instancia da classe
  const ManagerForm(
      {super.key, required this.state, required this.managerFormKey});
  ///provider
  final FunctionManager state;
  ///key do formulario para validacao
  final GlobalKey<FormState> managerFormKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: managerFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: state.controllerName,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            decoration: decorationForm('Name'),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Enter the manager name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: state.controllerCPF,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            decoration: decorationForm('CPF'),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Enter the manager CPF';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownButtonFormField<States>(
            value: state.selectItem,
            onChanged: (value) {
              if (value != null) {
                state.updateState(value);
              }
            },
            items: States.values.map(
              (state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state.toString().split('.').last.toUpperCase()),
                );
              },
            ).toList(),
            decoration: decorationForm('States'),
            dropdownColor: Colors.white,
            style: const TextStyle(color: Colors.black, fontSize: 20),
            iconEnabledColor: Colors.blue,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: state.controllerPhone,
            keyboardType: TextInputType.phone,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            decoration: decorationForm('Phone'),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Enter the manager telephone number';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: state.controllerComission,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 15, color: Colors.black),
            decoration: decorationForm('Comission'),
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Enter the manager comission';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
