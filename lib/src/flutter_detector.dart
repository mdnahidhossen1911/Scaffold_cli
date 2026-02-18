import 'dart:io';
import 'logger.dart';

class FlutterInfo {
  final String tool;    // 'flutter' or 'fvm'
  final String version;
  final String channel;
  final String command; // actual command to run flutter

  FlutterInfo({
    required this.tool,
    required this.version,
    required this.channel,
    required this.command,
  });
}

class FlutterDetector {
  Future<FlutterInfo> detect() async {
    Logger.info('🔍 Detecting Flutter installation…');

    // 1. Try FVM first
    final fvmInfo = await _tryFvm();
    if (fvmInfo != null) return fvmInfo;

    // 2. Fallback to global Flutter
    final flutterInfo = await _tryFlutter();
    if (flutterInfo != null) return flutterInfo;

    Logger.error('Flutter not found. Please install Flutter or FVM.');
    exit(1);
  }

  Future<FlutterInfo?> _tryFvm() async {
    try {
      final result = await Process.run('fvm', ['flutter', '--version'],
          runInShell: true);
      if (result.exitCode == 0) {
        return _parseVersionOutput(result.stdout.toString(), 'fvm', 'fvm flutter');
      }
    } catch (_) {}
    return null;
  }

  Future<FlutterInfo?> _tryFlutter() async {
    try {
      final result =
          await Process.run('flutter', ['--version'], runInShell: true);
      if (result.exitCode == 0) {
        return _parseVersionOutput(
            result.stdout.toString(), 'flutter', 'flutter');
      }
    } catch (_) {}
    return null;
  }

  FlutterInfo _parseVersionOutput(
      String output, String tool, String command) {
    // Flutter 3.x.x • channel stable • …
    final versionMatch =
        RegExp(r'Flutter\s+([\d.]+)').firstMatch(output);
    final channelMatch =
        RegExp(r'channel\s+(\w+)').firstMatch(output);

    return FlutterInfo(
      tool: tool,
      command: command,
      version: versionMatch?.group(1) ?? 'unknown',
      channel: channelMatch?.group(1) ?? 'unknown',
    );
  }
}
