///modelo de aluguel
class RentsModel {
  ///id para identificar o aluguel
  late int? id;
  ///id do veiculo para identificar qual veiculo do aluguel
  int vehicleId;
  ///preço do aluguel
  final String price;
  ///dias totais do aluguel
  final int totalDays;
  ///comissao do gerente responsavel por aquele aluguel
  final double managerCommission;
  ///id do cliente para identificar qual cliente do aluguel
  int customerId;
  ///data inicial do aluguel
  final DateTime initialDate;
  ///data final do aluguel
  final DateTime finalDate;

  ///construtor
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