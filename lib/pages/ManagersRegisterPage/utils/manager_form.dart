import 'package:flutter/material.dart';
import '../../../enum_states.dart';
import '../../../theme.dart';
///formulario referente ao cadastro de gerentes
class ManagerForm extends StatefulWidget {
  ///instancia da classe
  const ManagerForm({super.key});

  @override
  State<ManagerForm> createState() => _ManagerFormState();
}

class _ManagerFormState extends State<ManagerForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
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
            // value: state.controllerStates,
            onChanged: (value) {
              if (value != null) {}
            },
            items: States.values.map(
              (state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(state.toString().split('.').last),
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
