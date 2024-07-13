import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
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

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('SS AUTOMÓVEIS',
                style: const pw.TextStyle(fontSize: 40, color: PdfColors.blue)),
            pw.Divider(),
            pw.Text('Dados do cliente:',
                style: const pw.TextStyle(fontSize: 20, color: PdfColors.blue)),
            pw.Row(
              children: [
                pw.Row(
                  children: [
                    pw.Text('Name: ', style: _styleBold),
                    pw.Text(customer.name),
                  ],
                ),
                pw.SizedBox(
                  width: 20,
                ),
                pw.Row(
                  children: [
                    pw.Text('CNPJ: ', style: _styleBold),
                    pw.Text(customer.cnpj),
                  ],
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Row(
                  children: [
                    pw.Text('City: ', style: _styleBold),
                    pw.Text(customer.city)
                  ],
                ),
                pw.SizedBox(
                  width: 20,
                ),
                pw.Row(
                  children: [
                    pw.Text('State: ', style: _styleBold),
                    pw.Text(
                      customer.state.sgEstado,
                    )
                  ],
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('Phone: ', style: _styleBold),
                pw.Text(customer.phone)
              ],
            ),
            pw.Text(
              'Vehicle:',
              style: const pw.TextStyle(fontSize: 20, color: PdfColors.blue),
            ),
            pw.Wrap(
              direction: pw.Axis.horizontal,
              children: [
                for (final image in imagesFile)
                  pw.Padding(
                    padding: pw.EdgeInsets.all(4),
                    child: pw.Image(
                      height: 100,
                      width: 100,
                      pw.MemoryImage(image),
                    ),
                  )
              ],
            ),
            pw.Row(
              children: [
                pw.Text('Type: ', style: _styleBold),
                pw.Text(vehicle.type ?? 'type'),
              ],
            ),
            pw.Row(
              children: [
                pw.Row(
                  children: [
                    pw.Text('Brand: ', style: _styleBold),
                    pw.Text(vehicle.brand?.name ?? 'brand')
                  ],
                ),
                pw.SizedBox(
                  width: 20,
                ),
                pw.Row(
                  children: [
                    pw.Text('Model: ', style: _styleBold),
                    pw.Text(vehicle.model?.name ?? 'model')
                  ],
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('Plate: ', style: _styleBold),
                pw.Text(vehicle.plate)
              ],
            ),
            pw.Row(
              children: [
                pw.Text('Year: ', style: _styleBold),
                pw.Text(vehicle.year?.name ?? 'name'),
              ],
            ),
            pw.Row(
              children: [
                pw.Text('Daily rate: ', style: _styleBold),
                pw.Text(vehicle.dailyRate)
              ],
            ),
            pw.Text('Rent:',
                style: const pw.TextStyle(fontSize: 20, color: PdfColors.blue)),
            pw.Row(
              children: [
                pw.Text('Days: ', style: _styleBold),
                pw.Text('${rent.totalDays}')
              ],
            ),
            pw.Row(
              children: [
                pw.Text('Manager Commission: ', style: _styleBold),
                pw.Text('${rent.managerCommission}')
              ],
            ),
            pw.Row(
              children: [
                pw.Row(
                  children: [
                    pw.Text('Initial data: ', style: _styleBold),
                    pw.Text(rent.initialDate.dateFormater())
                  ],
                ),
                pw.SizedBox(width: 20),
                pw.Row(
                  children: [
                    pw.Text('Final data: ', style: _styleBold),
                    pw.Text(rent.finalDate.dateFormater())
                  ],
                ),
              ],
            ),
            pw.Text('Price: ${rent.price}',
                style: const pw.TextStyle(fontSize: 20),),
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
