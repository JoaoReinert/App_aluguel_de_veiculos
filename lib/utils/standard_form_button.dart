import 'package:flutter/material.dart';


///criacao da estilizacao do botao de cadastro para as telas
class StandardFormButton extends StatelessWidget {
  ///instancia para passar a funcao do botao
  const StandardFormButton({
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
        side: const BorderSide(style: BorderStyle.none),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      onPressed: onpressed,
      icon: icon,
      label: Text(
        label,
        style: const TextStyle(color: Colors.blue),
      ),
    );
  }
}
