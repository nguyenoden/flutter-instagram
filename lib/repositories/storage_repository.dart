import 'dart:io';

import 'package:flutter_clb_tinhban_ui_app/provider/storage_provider.dart';
import 'package:flutter_clb_tinhban_ui_app/repositories/base_repository.dart';

class StorageRepository extends BaseRepository {
  StorageProvider storageProvider = StorageProvider();

  Future<String> uploadFile(File file, String path) =>
      storageProvider.uploadFile(file, path);


  @override
  void dispose() {
   storageProvider.dispose();
  }
}
