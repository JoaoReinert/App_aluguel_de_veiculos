import 'package:flutter/material.dart';

import '../managers_register_page.dart';
///criacao da estilizacao do botao de cadastro para as telas
class ManagerButton extends StatelessWidget {
   ///instancia para passar a funcao do botao
   const ManagerButton({
    required this.onpressed,
     required FunctionManager state,
    super.key,
  });
///funcao para na tela poder passar uma funcao quando ele ser precionado
  final void Function() onpressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        side: const BorderSide(style: BorderStyle.none),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      onPressed: onpressed,
      icon: const Icon(Icons.work, color: Colors.blue,),
      label: const Text(
        'Manager Registration',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
