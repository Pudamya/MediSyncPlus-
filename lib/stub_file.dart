// lib/stub_file.dart
import 'dart:typed_data';

class File {
  final String path;
  File(this.path);
  Future<Uint8List> readAsBytes() async {
    throw UnsupportedError('File.readAsBytes is not supported on web. Use XFile.readAsBytes.');
  }
}