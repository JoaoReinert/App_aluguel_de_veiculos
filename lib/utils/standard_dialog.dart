import 'package:flutter/material.dart';

///criacao do dialogo reutilizavel para cadastro
class StandardDialog extends StatelessWidget {
  ///construtor
  const StandardDialog({super.key,
    required this.title,
    this.actions,
    required this.items,
     this.formKey
  });
  ///variavel para o titulo do dialog
  final String title;
  ///armazena os botoes de save e cancel
  final Widget? actions;
  ///armazena os campos de texti
  final List<Widget> items;
  ///key para os formularios
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AlertDialog(
        shape: const BeveledRectangleBorder(),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(color: Colors.blue, fontSize: 20),
        ),
        content: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < items.length; i++)... [
                  items[i],
                  if (i < items.length -1) const SizedBox(height: 10,),
                ],
                if (actions != null) actions ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
