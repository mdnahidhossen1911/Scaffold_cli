import 'base_command.dart';
import '../logger.dart';

class VersionCommand extends CliCommand {
  @override
  String get name => 'version';

  @override
  String get description => 'Show scaffold_cli version information.';

  @override
  String get usage => '  scaffold version\n  scaffold --version\n  scaffold -v';

  @override
  Future<void> run(List<String> args) async {
    Logger.info('\n  scaffold_cli  \x1B[36mv1.0.0\x1B[0m');
    Logger.dim('  Dart CLI • Flutter project scaffolding tool');
    Logger.dim('  https://github.com/yourname/scaffold_cli\n');
  }
}
