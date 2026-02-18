import 'dart:io';
import 'logger.dart';
import 'commands/base_command.dart';
import 'commands/create_command.dart';
import 'commands/list_command.dart';
import 'commands/info_command.dart';
import 'commands/doctor_command.dart';
import 'commands/version_command.dart';
import 'commands/help_command.dart';

class CliRunner {
  late final List<CliCommand> _commands;

  CliRunner() {
    _commands = [
      CreateCommand(),
      ListCommand(),
      InfoCommand(),
      DoctorCommand(),
      VersionCommand(),
    ];
    _commands.add(HelpCommand(_commands));
  }

  Future<void> run(List<String> args) async {
    Logger.printBanner();

    if (args.isEmpty) {
      await HelpCommand(_commands).run([]);
      return;
    }

    final first = args.first;

    if (first == '--version' || first == '-v') {
      await VersionCommand().run([]);
      return;
    }
    if (first == '--help' || first == '-h') {
      await HelpCommand(_commands).run(args.skip(1).toList());
      return;
    }

    final cmd = _commands.where((c) => c.name == first).firstOrNull;

    if (cmd != null) {
      await cmd.run(args.skip(1).toList());
    } else if (RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(first)) {
      // Bare project name -> forward to create
      await CreateCommand().run(args);
    } else {
      Logger.error('Unknown command: "$first"');
      Logger.info('Run \x1B[1mscaffold help\x1B[0m to see available commands.');
      exit(1);
    }
  }
}
