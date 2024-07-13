import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../models/customers_model.dart';
import '../../models/rents_model.dart';
import '../../models/vehicles_model.dart';
import '../pages/RentsRegisterPage/rents_register_page.dart';
import '../utils/vehicle_utils.dart';

final _styleBold = pw.TextStyle(fontWeight: pw.FontWeight.bold);
const _styleTitle = pw.TextStyle(fontSize: 20, color: PdfColors.blue);

///formatacao do dinheiro
String formatMoney(double value) {
  final format = NumberFormat.simpleCurrency(locale: 'pt_BR');
  return format.format(value);
}

///funcao de criar o pdf
Future<void> createPdf(
  CustomerModel customer,
  VehiclesModels vehicle,
  RentsModel rent,
) async {
  final pdf = pw.Document();
  final images = await vehicle.getImages();

  final imagesFile = <Uint8List>[];

  for (var i = 0; i < images.length; i++) {
    final fileVehicle = File(images[i]);
    final bytes = await fileVehicle.readAsBytes();

    imagesFile.add(bytes);
  }

  final dateNow = DateTime.now();

  pdf.addPage(
    pw.Page(
      margin: const pw.EdgeInsets.all(32),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('SS AUTOMÓVEIS',
                    style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue)),
                pw.Column(children: [
                  pw.Text(
                    'Rental Report',
                    style:
                        const pw.TextStyle(fontSize: 18, color: PdfColors.grey),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(dateNow.dateFormater(),
                      style: const pw.TextStyle(color: PdfColors.black))
                ]),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text('Customer data', style: _styleTitle),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Name: ${customer.name}', style: _styleBold),
                pw.Text('CNPJ: ${customer.cnpj}', style: _styleBold),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('City: ${customer.city}', style: _styleBold),
                pw.Text('State: ${customer.state.sgEstado}', style: _styleBold),
              ],
            ),
            pw.Text('Phone: ${customer.phone}', style: _styleBold),
            pw.SizedBox(height: 10),
            pw.Text('Manager data', style: _styleTitle),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Name: ${customer.manager?.name}', style: _styleBold),
                pw.Text('CPF: ${customer.manager?.cpf}', style: _styleBold),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Phone: ${customer.manager?.phone}', style: _styleBold),
                pw.Text('State: ${customer.manager?.state.sgEstado}',
                    style: _styleBold),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text('Vehicle Data', style: _styleTitle),
            pw.SizedBox(height: 10),
            pw.Wrap(
              direction: pw.Axis.horizontal,
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final image in imagesFile)
                  pw.Container(
                    height: 100,
                    width: 100,
                    child: pw.Image(pw.MemoryImage(image)),
                  ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Type: ${vehicle.type ?? 'N/A'}', style: _styleBold),
                pw.Text('Brand: ${vehicle.brand?.name ?? 'N/A'}',
                    style: _styleBold),
                pw.Text('Model: ${vehicle.model?.name ?? 'N/A'}',
                    style: _styleBold),
              ],
            ),
            pw.Text('Plate: ${vehicle.plate}', style: _styleBold),
            pw.Text('Year: ${vehicle.year?.name ?? 'N/A'}', style: _styleBold),
            pw.Text(
                'Daily Rate: ${formatMoney(double.parse(vehicle.dailyRate))}',
                style: _styleBold),
            pw.SizedBox(height: 10),
            pw.Text('Rent Data', style: _styleTitle),
            pw.SizedBox(height: 10),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Days: ${rent.totalDays}', style: _styleBold),
                pw.Text(
                    'Manager Commission: ${formatMoney(
                      double.parse(customer.manager!.comission),
                    )}',
                    style: _styleBold),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Initial Data: ${rent.initialDate.dateFormater()}',
                    style: _styleBold),
                pw.Text('Final Data: ${rent.finalDate.dateFormater()}',
                    style: _styleBold),
              ],
            ),
            pw.Text('Price: ${formatMoney(double.parse(rent.price))}',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Divider(),
            pw.Text('SS Automóveis - All rights reserved',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
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
