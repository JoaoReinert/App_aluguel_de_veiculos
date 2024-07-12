import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/customers_table.dart';
import '../../controllers/rents_table.dart';
import '../../controllers/vehicles_table.dart';
import '../../models/customers_model.dart';
import '../../models/rents_model.dart';
import '../../models/vehicles_model.dart';
import '../../pdf/pdf.dart';
import '../../theme.dart';
import '../../utils/standard_delete_dialog.dart';
import '../RentsRegisterPage/rents_register_page.dart';

///criacao do state da tela de listagem dos alugueis
class RentsListPageState extends ChangeNotifier {
  ///instacia para sempre que vir para tela, chamar a funcao de carregar
  RentsListPageState() {
    load();
  }

  ///controlador de algueis
  final controllerRents = RentsController();

  ///controlador de cliente
  final controllerCustomers = CustomerController();

  ///controlador de veiculo
  final controllerVehicles = VehicleController();
  final _listRents = <RentsModel>[];

  ///map para armazenar todas as informacoes do cliente referente ao aluguel
  final Map<int, CustomerModel> customerInformations = {};

  ///map para armazenar todas as informacoes do veiculo referente ao aluguel
  final Map<int, VehiclesModels> vehiclesInformations = {};

  ///controlador para barra de pesquisa da tela
  final controllerResearch = TextEditingController();
  List<RentsModel> _listRentsFilter = <RentsModel>[];

  ///getter da lista de alugueis
  List<RentsModel> get listRents => _listRentsFilter;

  ///funcao para carregar a tela
  Future<void> load() async {
    final list = await controllerRents.select();
    _listRents.clear();
    _listRents.addAll(list);
    _listRentsFilter = _listRents;

    for (var rent in list) {
      if (!customerInformations.containsKey(rent.customerId)) {
        final customer = await controllerCustomers.selectId(rent.customerId);
        if (customer != null) {
          customerInformations[rent.customerId] = customer;
        }
      }
    }

    for (var rent in list) {
      if (!vehiclesInformations.containsKey(rent.vehicleId)) {
        final vehicle = await controllerVehicles.selectId(rent.vehicleId);
        if (vehicle != null) {
          vehiclesInformations[rent.vehicleId] = vehicle;
        }
      }
    }

    notifyListeners();
  }

  ///funcao delete para deletar o aluguel
  Future<void> delete(RentsModel rent) async {
    await controllerRents.delete(rent);
    await load();
    notifyListeners();
  }

  ///funcao de filtragem para a barra de pesquisa de alguel
  void filterRents(String nameRent) async {
    if (nameRent.isEmpty) {
      _listRentsFilter = _listRents;
    } else {
      _listRentsFilter = _listRents.where(
        (rent) {
          final vehicle = vehiclesInformations[rent.vehicleId];
          return vehicle?.model?.name
                  ?.toLowerCase()
                  .contains(nameRent.toLowerCase()) ??
              false;
        },
      ).toList();
    }
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
            child: Column(
              children: [
                TextField(
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  controller: state.controllerResearch,
                  onChanged: state.filterRents,
                  decoration: decorationSearch(
                    'Search Rent',
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
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
                            final customer =
                                state.customerInformations[rent.customerId];
                            final vehicle =
                                state.vehiclesInformations[rent.vehicleId];
                            return Padding(
                              padding: const EdgeInsets.all(2),
                              child: Card(
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black,
                                child: ExpansionTile(
                                  leading: const Icon(
                                    Icons.car_rental,
                                    color: Colors.blue,
                                  ),
                                  title: Text(
                                    '${vehicle?.model?.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        customer!.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        'Initial Date: ${rent.initialDate.dateFormater()}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'Final Date: ${rent.finalDate.dateFormater()}',
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Customer Information',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.person),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                customer.name,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                customer.phone,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.map),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                customer.state.sgEstado,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                          const Divider(),
                                          const Text(
                                            'Vehicle Information',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons
                                                  .directions_car_filled_outlined),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${vehicle?.brand?.name}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.directions_car),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '${vehicle?.model?.name}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.confirmation_num),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${vehicle?.plate}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.attach_money_outlined),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'R\$${vehicle?.dailyRate},00',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          const Text(
                                            'Rent Information',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Initial Date: ${rent.initialDate.dateFormater()} ',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_today),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Final Date: ${rent.finalDate.dateFormater()}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.monetization_on),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                rent.price,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.calendar_month),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Total Days: ${rent.totalDays}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Text(
                                            'Manager ${customer.manager!.name}',
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons
                                                  .monetization_on_outlined),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Commission: ${rent.managerCommission}',
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              TextButton(
                                                onPressed: () async {
                                                  await createPdf(
                                                      customer, vehicle!, rent);
                                                },
                                                child: const Text(
                                                  'VIEW PDF DOCUMENT',
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        StandardDeleteDialog(
                                                      name:
                                                          'rent for ${customer.name}',
                                                      function: () async {
                                                        await state
                                                            .delete(rent);
                                                      },
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'EXCLUDE RENT',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
