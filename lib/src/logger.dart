import 'dart:io';

class Logger {
  // ANSI color codes
  static const _reset = '\x1B[0m';
  static const _bold = '\x1B[1m';
  static const _cyan = '\x1B[36m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _dim = '\x1B[2m';
  static const _magenta = '\x1B[35m';

  static bool get _supportsColor => stdout.supportsAnsiEscapes;

  static String _c(String code, String text) =>
      _supportsColor ? '$code$text$_reset' : text;

  static void printBanner() {
    stdout.writeln(_c(_cyan + _bold, r'''
 ____     ____      _      _____   _____    ___    _       ____         ____   _       ___ 
/ ___|   / ___|    / \    |  ___| |  ___|  / _ \  | |     |  _ \       / ___| | |     |_ _|
\___ \  | |       / _ \   | |_    | |_    | | | | | |     | | | |     | |     | |      | | 
 ___) | | |___   / ___ \  |  _|   |  _|   | |_| | | |___  | |_| |     | |___  | |___   | | 
|____/   \____| /_/   \_\ |_|     |_|      \___/  |_____| |____/       \____| |_____| |___|
    '''));
    stdout.writeln(_c(_dim, '  Flutter Project Scaffolding CLI  v1.0.0\n'));
  }

  static void info(String msg) => stdout.writeln(msg);

  static void success(String msg) =>
      stdout.writeln(_c(_green, msg));

  static void warn(String msg) =>
      stdout.writeln(_c(_yellow, '⚠  $msg'));

  static void error(String msg) =>
      stderr.writeln(_c(_red, '✖  $msg'));

  static void dim(String msg) =>
      stdout.writeln(_c(_dim, msg));

  static void step(String msg) =>
      stdout.writeln(_c(_magenta, '  → $msg'));

  static void prompt(String msg) =>
      stdout.write(_c(_cyan + _bold, '? ') + msg + ' ');
}
