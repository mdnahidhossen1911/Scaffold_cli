import 'base_command.dart';
import '../logger.dart';
import '../structure_selector.dart';

class ListCommand extends CliCommand {
  @override
  String get name => 'list';

  @override
  String get description => 'List all available folder structures and their details.';

  @override
  String get usage => '''
  scaffold list [options]

  Options:
    --detail, -d    Show folder tree for each structure
    --help, -h      Show this help

  Examples:
    scaffold list
    scaffold list --detail
''';

  @override
  Future<void> run(List<String> args) async {
    if (args.contains('--help') || args.contains('-h')) {
      Logger.info(usage);
      return;
    }

    final showDetail = args.contains('--detail') || args.contains('-d');

    Logger.info('\n📁  Available Folder Structures\n');
    Logger.info('─' * 50);

    final structures = [
      _StructureInfo(
        number: 1,
        name: 'MVVM + GetX',
        stateManagement: 'GetX (Reactive .obs)',
        bestFor: 'Medium–large apps, reactive state, minimal boilerplate',
        tree: '''
lib/
├── app/
│   ├── bindings/        # Global GetX bindings
│   └── routes/          # GetPage route definitions
├── core/
│   ├── constants/       # App-wide constants
│   ├── theme/           # ThemeData
│   ├── utils/           # Helpers / extensions
│   └── widgets/         # Shared widgets
├── data/
│   ├── models/          # Data models / DTOs
│   ├── providers/       # API / local data providers
│   └── repositories/    # Repository pattern layer
└── modules/
    └── home/
        ├── bindings/    # Feature-level bindings
        ├── controllers/ # GetxController (ViewModel)
        └── views/       # UI screens''',
      ),
      _StructureInfo(
        number: 2,
        name: 'MVVM + Provider',
        stateManagement: 'Provider (ChangeNotifier)',
        bestFor: 'Apps preferring Flutter-native state, testable ViewModels',
        tree: '''
lib/
├── app/routes/          # GoRouter config
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── data/
│   ├── models/
│   ├── providers/
│   └── repositories/
├── viewmodels/          # ChangeNotifier ViewModels
└── views/
    └── home/            # UI screens''',
      ),
      _StructureInfo(
        number: 3,
        name: 'MVC + GetX',
        stateManagement: 'GetX (Reactive .obs)',
        bestFor: 'Simple apps, quick prototypes, familiar MVC pattern',
        tree: '''
lib/
├── app/
│   ├── bindings/
│   └── routes/
├── controllers/         # GetxControllers (C in MVC)
├── models/              # Data models (M in MVC)
├── views/               # UI screens (V in MVC)
│   └── home/
├── services/            # API / business services
└── core/
    ├── constants/
    ├── theme/
    ├── utils/
    └── widgets/''',
      ),
      _StructureInfo(
        number: 4,
        name: 'MVC + Provider',
        stateManagement: 'Provider (ChangeNotifier)',
        bestFor: 'Simple apps with Flutter-native state management',
        tree: '''
lib/
├── app/routes/
├── controllers/         # ChangeNotifier Controllers
├── models/
├── views/
│   └── home/
├── services/
└── core/
    ├── constants/
    ├── theme/
    ├── utils/
    └── widgets/''',
      ),
      _StructureInfo(
        number: 5,
        name: 'Feature-First + GetX',
        stateManagement: 'GetX (Reactive .obs)',
        bestFor: 'Large teams, scalable architecture, feature isolation',
        tree: '''
lib/
├── core/
│   ├── constants/
│   ├── network/         # Dio client setup
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   └── home/
│       ├── data/
│       │   ├── models/
│       │   ├── repositories/
│       │   └── sources/  # Remote / local data sources
│       └── presentation/
│           ├── bindings/
│           ├── controllers/
│           └── views/
└── app/
    ├── bindings/
    └── routes/''',
      ),
      _StructureInfo(
        number: 6,
        name: 'Feature-First + Provider',
        stateManagement: 'Provider (ChangeNotifier)',
        bestFor: 'Large apps, clean architecture, Flutter-native state',
        tree: '''
lib/
├── core/
│   ├── constants/
│   ├── network/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   └── home/
│       ├── data/
│       │   ├── models/
│       │   ├── repositories/
│       │   └── sources/
│       └── presentation/
│           ├── providers/
│           └── views/
└── app/routes/''',
      ),
    ];

    for (final s in structures) {
      Logger.info('\n  \x1B[36m${s.number}.\x1B[0m \x1B[1m${s.name}\x1B[0m');
      Logger.info('     State : ${s.stateManagement}');
      Logger.info('     Best  : ${s.bestFor}');
      if (showDetail) {
        Logger.info('');
        for (final line in s.tree.split('\n')) {
          Logger.info('     \x1B[2m$line\x1B[0m');
        }
      }
    }

    Logger.info('\n─' * 50);
    Logger.dim('\n  Use: scaffold create <project> --structure <1-6>');
    Logger.dim('  Or:  scaffold create <project>   (interactive menu)\n');
  }
}

class _StructureInfo {
  final int number;
  final String name;
  final String stateManagement;
  final String bestFor;
  final String tree;

  _StructureInfo({
    required this.number,
    required this.name,
    required this.stateManagement,
    required this.bestFor,
    required this.tree,
  });
}
