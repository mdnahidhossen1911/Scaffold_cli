import 'dart:io';
import 'base_command.dart';
import '../logger.dart';

class DoctorCommand extends CliCommand {
  @override
  String get name => 'doctor';

  @override
  String get description => 'Check your environment for scaffold_cli compatibility.';

  @override
  String get usage => '''
  scaffold doctor

  Checks:
    • Dart SDK version
    • Flutter installation (global)
    • FVM installation
    • PATH configuration for pub global bin

  Examples:
    scaffold doctor
''';

  @override
  Future<void> run(List<String> args) async {
    if (args.contains('--help') || args.contains('-h')) {
      Logger.info(usage);
      return;
    }

    Logger.info('\n🩺  scaffold doctor\n');
    Logger.info('─' * 50);

    int issues = 0;

    // ── Dart SDK ──────────────────────────────────────────────────────
    await _check(
      label: 'Dart SDK',
      command: 'dart',
      args: ['--version'],
      parse: (out) {
        final m = RegExp(r'Dart SDK version: ([\d.]+)').firstMatch(out);
        return m != null ? 'Dart ${m.group(1)}' : out.trim().split('\n').first;
      },
      onFail: () {
        issues++;
        Logger.error('  Dart SDK not found. Install from https://dart.dev/get-dart');
      },
    );

    // ── Flutter (global) ─────────────────────────────────────────────
    await _check(
      label: 'Flutter (global)',
      command: 'flutter',
      args: ['--version'],
      parse: (out) {
        final v = RegExp(r'Flutter ([\d.]+)').firstMatch(out);
        final c = RegExp(r'channel (\w+)').firstMatch(out);
        return 'Flutter ${v?.group(1) ?? '?'} • ${c?.group(1) ?? '?'} channel';
      },
      onFail: () {
        Logger.warn('  Flutter (global) not found — OK if using FVM.');
      },
    );

    // ── FVM ──────────────────────────────────────────────────────────
    await _check(
      label: 'FVM',
      command: 'fvm',
      args: ['--version'],
      parse: (out) => 'FVM ${out.trim()}',
      onFail: () {
        Logger.warn('  FVM not found — OK if using global Flutter.');
      },
    );

    // ── pub global bin in PATH ───────────────────────────────────────
    _checkPath();

    // ── Git ──────────────────────────────────────────────────────────
    await _check(
      label: 'Git',
      command: 'git',
      args: ['--version'],
      parse: (out) => out.trim().split('\n').first,
      onFail: () {
        issues++;
        Logger.warn('  Git not found. Needed for some Flutter commands.');
      },
    );

    Logger.info('\n─' * 50);
    if (issues == 0) {
      Logger.success('\n✅  Environment looks good! You\'re ready to scaffold.\n');
    } else {
      Logger.warn('\n⚠  $issues issue(s) found. Fix them before running scaffold.\n');
    }
  }

  Future<void> _check({
    required String label,
    required String command,
    required List<String> args,
    required String Function(String) parse,
    required void Function() onFail,
  }) async {
    stdout.write('  ${_pad(label)} ');
    try {
      final result =
          await Process.run(command, args, runInShell: true);
      if (result.exitCode == 0) {
        final combined = result.stdout.toString() + result.stderr.toString();
        Logger.success('✓  ${parse(combined)}');
      } else {
        onFail();
      }
    } catch (_) {
      onFail();
    }
  }

  void _checkPath() {
    stdout.write('  ${_pad('pub global bin in PATH')} ');
    final home = Platform.environment['HOME'] ??
        Platform.environment['USERPROFILE'] ??
        '';
    final pubCacheBin = '$home/.pub-cache/bin';
    final pathVar = Platform.environment['PATH'] ?? '';
    if (pathVar.contains(pubCacheBin) ||
        pathVar.contains('.pub-cache/bin')) {
      Logger.success('✓  Found in PATH');
    } else {
      Logger.warn(
          '⚠  Not found. Add this to your shell profile:\n'
          '       export PATH="\$PATH:$pubCacheBin"');
    }
  }

  String _pad(String s, [int width = 26]) =>
      s.padRight(width);
}
