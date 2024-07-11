import 'package:flutter/material.dart';

import '../pages/ManagersRegisterPage/managers_register_page.dart';

///criacao da estilizacao do botao de cadastro para as telas
class StandardEditButton extends StatelessWidget {
  ///instancia para passar a funcao do botao
  const StandardEditButton({
    required this.onpressed,
    super.key,
    required this.icon,
    required this.label,
  });

  ///funcao para na tela poder passar uma funcao quando ele ser precionado
  final void Function() onpressed;

  final Icon icon;

  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        side: const BorderSide(style: BorderStyle.none),
        elevation: 4,
        backgroundColor: Colors.grey[300],
      ),
      onPressed: onpressed,
      icon: icon,
      label: Text(
        label,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
