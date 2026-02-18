import 'dart:io';
import 'logger.dart';

enum FolderStructure {
  mvvmGetx,
  mvvmProvider,
  mvcGetx,
  mvcProvider,
  featureFirstGetx,
  featureFirstProvider,
}

extension FolderStructureLabel on FolderStructure {
  String get label {
    switch (this) {
      case FolderStructure.mvvmGetx:
        return 'MVVM + GetX';
      case FolderStructure.mvvmProvider:
        return 'MVVM + Provider';
      case FolderStructure.mvcGetx:
        return 'MVC + GetX';
      case FolderStructure.mvcProvider:
        return 'MVC + Provider';
      case FolderStructure.featureFirstGetx:
        return 'Feature-First + GetX';
      case FolderStructure.featureFirstProvider:
        return 'Feature-First + Provider';
    }
  }

  String get stateManagement {
    switch (this) {
      case FolderStructure.mvvmGetx:
      case FolderStructure.mvcGetx:
      case FolderStructure.featureFirstGetx:
        return 'getx';
      default:
        return 'provider';
    }
  }
}

class StructureSelector {
  static FolderStructure select() {
    stdout.writeln('\n📁 Choose a folder structure:\n');
    final options = FolderStructure.values;
    for (var i = 0; i < options.length; i++) {
      stdout.writeln('  ${i + 1}. ${options[i].label}');
    }
    stdout.writeln('');

    while (true) {
      Logger.prompt('Enter number (1-${options.length}):');
      final input = stdin.readLineSync()?.trim();
      final choice = int.tryParse(input ?? '');
      if (choice != null && choice >= 1 && choice <= options.length) {
        final selected = options[choice - 1];
        Logger.success('Selected: ${selected.label}');
        return selected;
      }
      Logger.warn('Please enter a number between 1 and ${options.length}.');
    }
  }
}
