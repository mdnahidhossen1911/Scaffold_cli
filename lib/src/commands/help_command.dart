import 'base_command.dart';
import '../logger.dart';

class HelpCommand extends CliCommand {
  final List<CliCommand> allCommands;

  HelpCommand(this.allCommands);

  @override
  String get name => 'help';

  @override
  String get description => 'Show help for scaffold_cli or a specific command.';

  @override
  String get usage => '  scaffold help [command]';

  @override
  Future<void> run(List<String> args) async {
    if (args.isNotEmpty) {
      // Show help for specific command
      final cmdName = args.first;
      final cmd = allCommands.where((c) => c.name == cmdName).firstOrNull;
      if (cmd != null) {
        Logger.info('\n\x1B[1m${cmd.name}\x1B[0m — ${cmd.description}\n');
        Logger.info(cmd.usage);
        return;
      } else {
        Logger.warn('Unknown command "$cmdName". Showing general help.\n');
      }
    }

    _printGeneralHelp();
  }

  void _printGeneralHelp() {
    Logger.info('''

\x1B[1mscaffold_cli\x1B[0m — Flutter project scaffolding tool

\x1B[36mUSAGE\x1B[0m
  scaffold <command> [arguments]

\x1B[36mGLOBAL OPTIONS\x1B[0m
  -h, --help       Show help
  -v, --version    Show version

\x1B[36mCOMMANDS\x1B[0m''');

    for (final cmd in allCommands) {
      if (cmd.name == 'help') continue;
      final padded = cmd.name.padRight(12);
      Logger.info('  \x1B[33m$padded\x1B[0m  ${cmd.description}');
    }

    Logger.info('''
\x1B[36mEXAMPLES\x1B[0m
  scaffold create my_app                  Interactive structure picker
  scaffold create my_app --structure 5    Feature-First + GetX (no prompt)
  scaffold list --detail                  Show full folder trees
  scaffold doctor                         Check your environment
  scaffold help create                    Help for the create command

\x1B[36mFLUTTER INTEGRATION\x1B[0m
  flutter pub global run scaffold_cli create my_app
  fvm flutter pub global run scaffold_cli create my_app
''');
  }
}
