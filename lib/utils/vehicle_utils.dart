import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/vehicles_model.dart';

extension VehicleExtension on VehiclesModels {
  /// funcao para pegar a imagem daquele veiculo de acordo com a placa
  Future<List<String>> getImages() async {
    /// lista que armazena as imagens
    final imagesPath = <String>[];
    final appDocumentsDirectory = await getApplicationSupportDirectory();
    final images = '${appDocumentsDirectory.path}/images/vehicles/$plate';

    final directory = Directory(images);
    if (await directory.exists()) {
      var files = directory.listSync();

      for (var file in files) {
        if (file.path.contains('.png')) {
          imagesPath.add(file.path);
        }
      }
      return imagesPath;
    } else {
      return imagesPath;
    }
  }
}
