import 'dart:io';
import 'package:path/path.dart' as p;
import '../logger.dart';
import '../flutter_detector.dart';
import '../structure_selector.dart';
import 'mvvm_getx_generator.dart';
import 'mvvm_provider_generator.dart';
import 'mvc_getx_generator.dart';
import 'mvc_provider_generator.dart';
import 'feature_first_getx_generator.dart';
import 'feature_first_provider_generator.dart';

abstract class StructureGenerator {
  Future<void> generate(String projectPath, String projectName);
}

class ProjectGenerator {
  final String projectName;
  final Directory projectDir;
  final FolderStructure structure;
  final FlutterInfo flutterInfo;
  final String org;

  ProjectGenerator({
    required this.projectName,
    required this.projectDir,
    required this.structure,
    required this.flutterInfo,
    this.org = 'com.example',
  });

  Future<void> generate() async {
    await _runFlutterCreate();

    Logger.step('Generating ${structure.label} folder structure…');
    final generator = _getGenerator();
    await generator.generate(projectDir.path, projectName);

    Logger.step('Updating pubspec.yaml with dependencies…');
    await _updatePubspec();

    Logger.step('Running flutter pub get…');
    await _runCommand(
        flutterInfo.command.split(' ').first,
        [...flutterInfo.command.split(' ').skip(1), 'pub', 'get'],
        projectDir.path);
  }

  Future<void> _runFlutterCreate() async {
    Logger.step('Running flutter create…');
    final parts = flutterInfo.command.split(' ');
    final exe = parts.first;
    final extraArgs = parts.skip(1).toList();

    await _runCommand(
      exe,
      [...extraArgs, 'create', '--org', org, projectName],
      Directory.current.path,
    );
  }

  Future<void> _runCommand(
      String exe, List<String> args, String workingDir) async {
    final result = await Process.run(exe, args,
        workingDirectory: workingDir, runInShell: true);
    if (result.exitCode != 0) {
      Logger.error('Command failed: $exe ${args.join(' ')}');
      Logger.error(result.stderr.toString());
      exit(1);
    }
  }

  StructureGenerator _getGenerator() {
    switch (structure) {
      case FolderStructure.mvvmGetx:
        return MvvmGetxGenerator();
      case FolderStructure.mvvmProvider:
        return MvvmProviderGenerator();
      case FolderStructure.mvcGetx:
        return MvcGetxGenerator();
      case FolderStructure.mvcProvider:
        return MvcProviderGenerator();
      case FolderStructure.featureFirstGetx:
        return FeatureFirstGetxGenerator();
      case FolderStructure.featureFirstProvider:
        return FeatureFirstProviderGenerator();
    }
  }

  Future<void> _updatePubspec() async {
    final pubspecFile = File(p.join(projectDir.path, 'pubspec.yaml'));
    var content = await pubspecFile.readAsString();

    final deps = _getDependencies();
    final marker = '  flutter:\n    sdk: flutter';
    final insertion = '$marker\n\n${deps.map((d) => '  $d').join('\n')}';
    content = content.replaceFirst(marker, insertion);
    await pubspecFile.writeAsString(content);
  }

  List<String> _getDependencies() {
    final isGetx = structure.stateManagement == 'getx';
    return [
      if (isGetx) 'get: ^4.6.6' else 'provider: ^6.1.2',
      'equatable: ^2.0.5',
      'dio: ^5.4.3+1',
      'get_it: ^7.6.7',
      'go_router: ^14.2.7',
      'flutter_svg: ^2.0.10+1',
      'cached_network_image: ^3.3.1',
      'shared_preferences: ^2.2.3',
      'logger: ^2.4.0',
    ];
  }
}
