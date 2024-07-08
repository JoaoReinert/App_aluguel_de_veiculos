class RentsModel {
  late int? id;
  int vehicleId;
  final String price;
  final int totalDays;
  final double managerCommission;
  int customerId;
  final DateTime initialDate;
  final DateTime finalDate;

  RentsModel({
     this.id,
    required this.vehicleId,
    required this.price,
    required this.totalDays,
    required this.managerCommission,
    required this.customerId,
    required this.initialDate,
    required this.finalDate,
  });}