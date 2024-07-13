import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../controllers/customers_table.dart';
import '../../controllers/rents_table.dart';
import '../../models/customers_model.dart';
import '../../models/rents_model.dart';
import '../../models/vehicles_model.dart';
import '../../theme.dart';
import '../HomePage/home_page.dart';

///extensao para adicionar funcionalidades ao datetime
extension DateExtension on DateTime {
  ///funcao para formatar a data ao brasileiro
  String dateFormater() {
    return "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
  }
}

///criacao do state da tela de registro de alugueis
class RentsRegisterState extends ChangeNotifier {
  ///instancia para carregar sempre que a tela for carregada
  RentsRegisterState(this.vehicle) {
    load();
  }

  ///key para o formulario de aluguel
  final rentsKey = GlobalKey<FormState>();

  ///variavel de veiculo para pegar informacoes do veiculo
  final VehiclesModels vehicle;

  ///lista de nomes de todos os cliente
  List<String> customerNames = [];

  ///lista de todos os clientes para pegar a comissao do seu
  ///gerente responsavel
  List<CustomerModel> customers = [];

  ///variavel de dias totais do aluguel
  int totalDays = 0;

  ///variavel para preço do aluguel
  double price = 0.0;

  ///variavel para a comissao do gerente
  double managerComission = 0.0;

  ///controlador de cliente
  final controller = CustomerController();

  ///controlador de aluguel
  final controllerRent = RentsController();

  CustomerModel? _selectedCustomer;

  ///armazena a data incial do alguel
  TextEditingController initialDateController = TextEditingController();

  ///armazena a data final do alguel
  TextEditingController finalDateController = TextEditingController();

  ///armazena o cliente selecionado no elevanted button
  CustomerModel? get selectedCustomer => _selectedCustomer;

  ///funcao para ser chamada toda vez que a pagina for carregada
  Future<void> load() async {
    customers = await controller.select();
    customerNames = customers.map((pickName) => pickName.name).toList();
    notifyListeners();
  }

  ///funcao para inserir o aluguel na tabela de alguel do banco de dados
  Future<void> insert() async {
    if (vehicle.id == null || _selectedCustomer == null) {
      return;
    }

    final rent = RentsModel(
        vehicleId: vehicle.id!,
        price: price.toString(),
        totalDays: totalDays,
        managerCommission: managerComission,
        customerId: selectedCustomer!.id!,
        initialDate: date(initialDateController.text),
        finalDate: date(finalDateController.text));

    await controllerRent.insert(rent);
    await load();

    price = 0.0;
    managerComission = 0.0;
    totalDays = 0;
    _selectedCustomer = null;
    initialDateController.clear();
    finalDateController.clear();
  }

  ///funcao para formatar a data
  DateTime date(String date) {
    final barrier = date.split('/');
    return DateTime(
        int.parse(barrier[2]), int.parse(barrier[1]), int.parse(barrier[0]));
  }

  ///funcao para pegar a data inicial do aluguel
  Future<void> selectInitialDate(BuildContext context) async {
    var picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      initialDateController.text = picked.dateFormater();
      finalDateController.clear();
    }
    calculateDays();
    calculatePrice();
    notifyListeners();
  }

  ///funcao para pegar a data final do aluguel de acordo com a data inicial
  Future<void> selectFinalDate(BuildContext context) async {
    var picked = await showDatePicker(
      context: context,
      initialDate: initialDateController.text.isEmpty
          ? DateTime.now()
          : date(initialDateController.text),
      firstDate: initialDateController.text.isEmpty
          ? DateTime.now()
          : date(initialDateController.text),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      finalDateController.text = picked.dateFormater();
    }
    calculateDays();
    calculatePrice();
    calculateManagerComission();
    notifyListeners();
  }

  ///funcao para calcular quantos dias vai dar o aluguel
  void calculateDays() {
    if (initialDateController.text.isNotEmpty &&
        finalDateController.text.isNotEmpty) {
      //convertendo as stringds para datetime
      var initialDate = DateTime.parse(
          initialDateController.text.split('/').reversed.join('-'));
      var finalDate = DateTime.parse(
          finalDateController.text.split('/').reversed.join('-'));
      var totalNumbersOfDay = finalDate.difference(initialDate);
      totalDays = totalNumbersOfDay.inDays;

      notifyListeners();
    }
  }

  ///funcao para calcular o preço do aluguel
  void calculatePrice() {
    var dailyRate = double.parse(vehicle.dailyRate);
    var totalDaysDouble = totalDays.toDouble();
    price = totalDaysDouble * dailyRate;
    notifyListeners();
  }

  ///funcao para calcular a comissao do gerente daquele alguel
  void calculateManagerComission() {
    if (_selectedCustomer != null && _selectedCustomer!.manager != null) {
      var comission = double.parse(_selectedCustomer!.manager!.comission);
      var formattedComission = comission / 100;
      managerComission = price * formattedComission;
    } else {
      managerComission = 0.0;
    }
    notifyListeners();
  }

  ///funcao para pegar o cliente com o elevanted button
  void updateCustomer(String customerName) {
    _selectedCustomer =
        customers.firstWhere((customer) => customer.name == customerName);
    calculateManagerComission();
    notifyListeners();
  }
}

///criacao da tela
class RentsRegisterPage extends StatelessWidget {
  ///construtor
  const RentsRegisterPage({super.key, required this.vehicle});

  ///variavel do veiculo do aluguel
  final VehiclesModels vehicle;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RentsRegisterState(vehicle),
      child: Consumer<RentsRegisterState>(
        builder: (_, state, __) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.blueAccent,
              title: const Text('Vehicle Registration'),
              centerTitle: true,
              automaticallyImplyLeading: true,
              toolbarHeight: 60,
            ),
            backgroundColor: Colors.blue,
            body: SingleChildScrollView(
              child: Form(
                key: state.rentsKey,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          vehicle.model!.name!,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownSearch<String>(
                          enabled: true,
                          dropdownDecoratorProps:
                              dropdownDecoration('Customer'),
                          popupProps: PopupProps.menu(
                            searchFieldProps: searchFieldDecoration(),
                            menuProps: menuPropsDecoration(),
                            showSearchBox: true,
                          ),
                          items: state.customerNames,
                          onChanged: (value) {
                            if (value != null) {
                              state.updateCustomer(value);
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Select customer';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (state.selectedCustomer?.name != null)
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: state.initialDateController,
                                  onTap: () {
                                    state.selectInitialDate(context);
                                  },
                                  decoration: decorationForm('Initial Date'),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required date';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: state.finalDateController,
                                  onTap: () {
                                    state.selectFinalDate(context);
                                  },
                                  decoration: decorationForm('Final Date'),
                                  readOnly: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required date';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (state.totalDays != 0 && state.price != 0)
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  const Text(
                                    'Total days',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${state.totalDays}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )),
                              Expanded(
                                  child: Column(
                                children: [
                                  const Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'R\$${state.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              )),
                            ],
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (state.totalDays != 0 && state.price != 0)
                          Column(
                            children: [
                              Text(
                                'Manager Commission, ${state._selectedCustomer!.manager!.name}',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'R\$${state.managerComission.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (state.rentsKey.currentState!.validate()) {
                              state.insert();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/homePage',
                                (route) => false,
                                arguments: 3,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'SAVE RENT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
