import 'package:flutter/material.dart';

class StandardDialog extends StatelessWidget {
  ///instancia da classe
  const StandardDialog({
    required this.title,
    this.actions,
    required this.items,
     this.formKey
  });

  final String title;
  final Widget? actions;
  final List<Widget> items;
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
