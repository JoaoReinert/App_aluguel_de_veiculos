import 'package:flutter/material.dart';

import '../../models/customers_model.dart';

///criacao da pagina de dados do cliente
class CustomerDataPage extends StatelessWidget {
  ///instancia da pagina
  const CustomerDataPage({super.key, required this.customer});
  ///puxando o modelo de cliente que sera exibido nessa pagina
  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                      customer.name,
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
                        customer.phone,
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
                      const Icon(Icons.business),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'CNPJ -',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        customer.cnpj,
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
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'City -',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        customer.city,
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
                        customer.state.sgEstado,
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
                      const Icon(Icons.account_balance),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Company -',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          customer.companyName,
                          style:
                              const TextStyle(color: Colors.black, fontSize: 18),
                              softWrap: true,
                              
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                   Row(
                    children: [
                      Icon(Icons.work),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Manager -',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        customer.manager!.name,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
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
