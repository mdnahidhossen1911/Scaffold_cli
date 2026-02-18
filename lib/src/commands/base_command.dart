import 'dart:io';
import '../logger.dart';

abstract class CliCommand {
  String get name;
  String get description;
  String get usage;

  Future<void> run(List<String> args);
}
