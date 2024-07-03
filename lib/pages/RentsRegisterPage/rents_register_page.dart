import 'package:dropdown_search/dropdown_search.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../controllers/database.dart';
import '../../models/customers_model.dart';
import '../../models/vehicles_model.dart';
import '../../theme.dart';

class RentsRegisterState extends ChangeNotifier {

  RentsRegisterState(this.vehicle) {
    load();
  }

  final VehiclesModels vehicle;
  List<String> customerNames = [];
  List<CustomerModel> customers = [];
  int totalDays = 0;
  double price = 0.0;
  double managerComission = 0.0;

  final controller = CustomerController();

  CustomerModel? _selectedCustomer;
  TextEditingController initialDateController = TextEditingController();
  TextEditingController finalDateController = TextEditingController();

  CustomerModel? get selectedCustomer => _selectedCustomer;

  Future<void> load() async {
    customers = await controller.select();
    customerNames = customers.map((pickName) => pickName.name).toList();
    notifyListeners();
  }

  Future<void> selectInitialDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      initialDateController.text = picked.toString().split(' ')[0];
    }
    calculateDays();
    calculatePrice();
    notifyListeners();
  }

  Future<void> selectFinalDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      finalDateController.text = picked.toString().split(' ')[0];
    }
    calculateDays();
    calculatePrice();
    calculateManagerComission();
    notifyListeners();
  }

  void calculateDays() {
    if (initialDateController.text.isNotEmpty &&
        finalDateController.text.isNotEmpty) {
      //convertendo as stringds para datetime
      DateTime initialDate = DateTime.parse(initialDateController.text);
      DateTime finalDate = DateTime.parse(finalDateController.text);
      Duration totalNumbersOfDay = finalDate.difference(initialDate);
      totalDays = totalNumbersOfDay.inDays;

      notifyListeners();
    }
  }

  void calculatePrice() {
    double dailyRate = double.parse(vehicle.dailyRate);
    double totalDaysDouble = totalDays.toDouble();
    price = totalDaysDouble * dailyRate;
    notifyListeners();
  }

  void calculateManagerComission() {
    if (_selectedCustomer != null && _selectedCustomer!.manager != null) {
      double comission = double.parse(_selectedCustomer!.manager!.comission);
      double formattedComission = comission / 100;
      managerComission = price * formattedComission;
    } else {
      managerComission = 0.0;
    }
    notifyListeners();
  }

  void updateCustomer(String customerName) {
    _selectedCustomer = customers.firstWhere((customer) => customer.name == customerName);
    calculateManagerComission();
    notifyListeners();
  }
}

class RentsRegisterPage extends StatelessWidget {
  const RentsRegisterPage({super.key, required this.vehicle});

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
              automaticallyImplyLeading: false,
              toolbarHeight: 60,
            ),
            backgroundColor: Colors.blue,
            body: SingleChildScrollView(
              child: Form(
                // key: state.vehicleKey,
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
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: state.initialDateController,
                                onTap: () {
                                  state.selectInitialDate(context);
                                },
                                decoration: decorationForm('Initial Date'),
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                controller: state.finalDateController,
                                onTap: () {
                                  state.selectFinalDate(context);
                                },
                                decoration: decorationForm('Final Date'),
                                readOnly: true,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (state.totalDays != 0 && state.price != 0)
                          Text('Total numbers of days: ${state.totalDays}'),
                        if (state.totalDays != 0 && state.price != 0)
                          Text('Price: R\$${state.price}'),
                        Text(
                            'Manager Commission: R\$${state.managerComission} \n ${state.selectedCustomer!.manager!.name}'),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: EdgeInsets.symmetric(horizontal: 80),
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
