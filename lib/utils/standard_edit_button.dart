import 'package:flutter/material.dart';



///criacao da estilizacao do botao de cadastro para as telas
class StandardEditButton extends StatelessWidget {
  ///construtor
  const StandardEditButton({
    required this.onpressed,
    super.key,
    required this.icon,
    required this.label,
  });

  ///funcao para na tela poder passar uma funcao quando ele ser precionado
  final void Function() onpressed;
  ///icone do botao
  final Icon icon;
  ///texto do botao
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
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
