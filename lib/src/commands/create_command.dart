import 'dart:io';
import 'package:path/path.dart' as p;
import 'base_command.dart';
import '../logger.dart';
import '../flutter_detector.dart';
import '../structure_selector.dart';
import '../generators/project_generator.dart';

class CreateCommand extends CliCommand {
  @override
  String get name => 'create';

  @override
  String get description => 'Create a new Flutter project with a chosen folder structure.';

  @override
  String get usage => '''
  scaffold create <project_name> [options]

  Options:
    --structure, -s <1-6>   Skip the menu and pick structure by number
    --org <com.example>     Set the org prefix (default: com.example)
    --help, -h              Show this help

  Examples:
    scaffold create my_app
    scaffold create my_app --structure 1
    scaffold create my_app -s 5 --org com.mycompany
''';

  @override
  Future<void> run(List<String> args) async {
    if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
      Logger.info(usage);
      return;
    }

    final projectName = args.first;

    if (!_isValidProjectName(projectName)) {
      Logger.error(
          'Invalid project name "$projectName". Use lowercase letters, digits and underscores only.');
      exit(1);
    }

    final projectDir = Directory(p.join(Directory.current.path, projectName));
    if (projectDir.existsSync()) {
      Logger.error('Directory "$projectName" already exists.');
      exit(1);
    }

    // Parse --structure / -s flag
    FolderStructure? preSelectedStructure;
    String org = 'com.example';

    for (var i = 1; i < args.length; i++) {
      if ((args[i] == '--structure' || args[i] == '-s') && i + 1 < args.length) {
        final n = int.tryParse(args[i + 1]);
        if (n != null && n >= 1 && n <= FolderStructure.values.length) {
          preSelectedStructure = FolderStructure.values[n - 1];
        } else {
          Logger.error('--structure must be a number between 1 and ${FolderStructure.values.length}');
          exit(1);
        }
      }
      if (args[i] == '--org' && i + 1 < args.length) {
        org = args[i + 1];
      }
    }

    // Detect Flutter
    final detector = FlutterDetector();
    final flutterInfo = await detector.detect();
    Logger.success('Flutter ${flutterInfo.version} (${flutterInfo.channel}) via ${flutterInfo.tool}');

    // Choose structure
    final structure = preSelectedStructure ?? StructureSelector.select();

    Logger.info('\nCreating Flutter project "$projectName"…\n');

    final generator = ProjectGenerator(
      projectName: projectName,
      projectDir: projectDir,
      structure: structure,
      flutterInfo: flutterInfo,
      org: org,
    );
    await generator.generate();

    Logger.success('\n✅  Project "$projectName" created successfully!');
    Logger.dim('   cd $projectName && flutter run');
  }

  bool _isValidProjectName(String name) =>
      RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name);
}
