#!/usr/bin/env dart

import 'dart:io';
import 'package:scaffold_cli/src/cli_runner.dart';

Future<void> main(List<String> arguments) async {
  final runner = CliRunner();
  await runner.run(arguments);
}
