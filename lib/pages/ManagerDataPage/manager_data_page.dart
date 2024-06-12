import 'package:flutter/material.dart';

import '../../models/managers_model.dart';

class ManagerDataPage extends StatelessWidget {

  const ManagerDataPage({super.key, required this.manager});

  final ManagerModel manager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
      ),
      backgroundColor: Colors.blue,
      body: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      manager.name,
                      style: const TextStyle(color: Colors.black, fontSize: 35),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Personal information',
                      style: TextStyle(color: Colors.black, fontSize: 25)),
                  const SizedBox(
                    height: 20,
                  ),
                   Row(
                    children: [
                      const Icon(Icons.account_circle),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'CPF -',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        manager.cpf,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.map),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'State -',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        manager.state.toString().split('.').last.toUpperCase(),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.phone),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Phone -',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        manager.phone,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.attach_money_outlined),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Comission -',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        '${manager.comission} %',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
