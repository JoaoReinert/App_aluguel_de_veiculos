import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/database.dart';
import '../../models/rents_model.dart';
import '../../utils/standard_delete_dialog.dart';

class RentsListPageState extends ChangeNotifier {
  RentsListPageState() {
    load();
  }

  final controllerRents = RentsController();
  final controllerCustomers = CustomerController();
  final _listRents = <RentsModel>[];
  final Map<int, String> customerNames = {};

  List<RentsModel> get listRents => _listRents;

  Future<void> load() async {
    final list = await controllerRents.select();
    _listRents.clear();
    _listRents.addAll(list);

    for (var rent in list) {
      if (!customerNames.containsKey(rent.customerId)) {
        final customer = await controllerCustomers.selectId(rent.customerId);
        customerNames[rent.customerId] = customer?.name ?? 'customerrrr';
      }
    }

    notifyListeners();
  }

  Future<void> delete(RentsModel rent) async {
    await controllerRents.delete(rent);
    await load();
    notifyListeners();
  }
}

///criacao da pagina de alugueis
class RentsPage extends StatelessWidget {
  ///instancia da classe
  const RentsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => RentsListPageState(),
      child: Consumer<RentsListPageState>(builder: (_, state, __) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Rents'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                if (state.listRents.isEmpty) {
                  return const Center(
                    child: Text(
                      'No rents registered',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: state.listRents.length,
                    itemBuilder: (context, index) {
                      final rent = state.listRents[index];
                      final customerName = state.customerNames[rent.customerId];
                      return Padding(
                        padding: const EdgeInsets.all(2),
                        child: Card(
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          color: Colors.grey[350],
                          elevation: 3,
                          shadowColor: Colors.black,
                          child: ListTile(
                            onTap: () {},
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            title: Text(
                              customerName!,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Text('Price: ${rent.price}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          StandardDeleteDialog(
                                        name: rent.customerId.toString(),
                                        function: () async {
                                          await state.delete(rent);
                                        },
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        );
      }),
    );
  }
}
