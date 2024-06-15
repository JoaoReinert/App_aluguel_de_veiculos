import 'package:flutter/material.dart';
import '../../../enum_states.dart';
import '../../../theme.dart';
import '../managers_register_page.dart';

class DialogDefault extends StatelessWidget {
  ///instancia da classe
  const DialogDefault({
    required this.title,
    this.actions,
    required this.items,
    required this.key
  });

  final String title;
  final Widget? actions;
  final List<Widget> items;
  final GlobalKey<FormState> key;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const BeveledRectangleBorder(),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(color: Colors.blue),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: key,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final item in items) item,
                if (actions != null) actions ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
