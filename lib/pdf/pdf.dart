import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/customers_model.dart';
import '../../models/rents_model.dart';
import '../../models/vehicles_model.dart';

Future<void> createPdf(
    CustomerModel customer, VehiclesModels vehicle, RentsModel rent) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.SizedBox(height: 20),
            pw.Text('name: ${customer.name}'),
            pw.Text('phone: ${customer.phone}'),
            pw.Text('vehicle: ${vehicle.model?.name}'),
            pw.Text('days: ${rent.totalDays}'),
          ],
        );
      },
    ),
  );

  final temporaryDirectory = await getTemporaryDirectory();
  final file = File('${temporaryDirectory.path}/rent_details.pdf');
  await file.writeAsBytes(await pdf.save());

  await OpenFile.open(file.path);
}
