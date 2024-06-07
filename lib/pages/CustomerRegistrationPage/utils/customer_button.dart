import 'package:flutter/material.dart';
///criacao da estilizacao do botao de cadastro para as telas
class CustomerButton extends StatelessWidget {
  ///instancia para passar a funcao do botao
  const CustomerButton({
    super.key,
    required this.onpressed
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
      icon: const Icon(Icons.person, color: Colors.blue,),
      label: const Text(
        'Customers Registration',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
