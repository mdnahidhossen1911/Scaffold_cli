import 'dart:io';
import 'package:path/path.dart' as p;

/// Creates a directory (and parents) if it doesn't exist.
Future<Directory> mkDir(String path) async {
  final dir = Directory(path);
  if (!dir.existsSync()) await dir.create(recursive: true);
  return dir;
}

/// Writes [content] to [filePath], creating parent dirs as needed.
Future<void> writeFile(String filePath, String content) async {
  await mkDir(p.dirname(filePath));
  await File(filePath).writeAsString(content);
}
