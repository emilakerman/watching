// file_operations.dart
export 'file_operations_stub.dart'
    if (dart.library.html) 'file_operations_html.dart'
    if (dart.library.io) 'file_operations_io.dart';
