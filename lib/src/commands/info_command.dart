import 'dart:io';
import 'base_command.dart';
import '../logger.dart';

class InfoCommand extends CliCommand {
  @override
  String get name => 'info';

  @override
  String get description =>
      'Show detailed info about a specific folder structure.';

  @override
  String get usage => '''
  scaffold info <1-6>

  Examples:
    scaffold info 1    Show details for MVVM + GetX
    scaffold info 5    Show details for Feature-First + GetX
''';

  static const _structures = [
    {
      'name': 'MVVM + GetX',
      'state': 'GetX (Reactive .obs, GetxController)',
      'pattern': 'MVVM',
      'bestFor': [
        'Medium to large scale apps',
        'Reactive UI with minimal boilerplate',
        'Teams familiar with GetX ecosystem',
      ],
      'packages': ['get', 'dio', 'get_it', 'go_router', 'equatable'],
      'pros': [
        'Minimal boilerplate via .obs + Obx()',
        'Built-in navigation, DI, and snackbars',
        'Fast development cycle',
      ],
      'cons': [
        'GetX is opinionated — harder to migrate later',
        'Less standard than Provider/Riverpod',
      ],
      'tree': '''lib/
├── app/
│   ├── bindings/        ← Global GetX Bindings
│   └── routes/          ← AppPages + Routes
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── data/
│   ├── models/
│   ├── providers/
│   └── repositories/
└── modules/
    └── home/
        ├── bindings/    ← HomeBinding
        ├── controllers/ ← HomeController (GetxController)
        └── views/       ← HomeView (GetView<HomeController>)''',
    },
    {
      'name': 'MVVM + Provider',
      'state': 'Provider (ChangeNotifier + Consumer/watch)',
      'pattern': 'MVVM',
      'bestFor': [
        'Flutter-native state management preference',
        'Teams coming from React/ViewModel background',
        'Apps needing easy testing of ViewModels',
      ],
      'packages': ['provider', 'go_router', 'dio', 'get_it', 'equatable'],
      'pros': [
        'Flutter-official recommended approach',
        'Easy to unit test ViewModels',
        'Familiar to most Flutter developers',
      ],
      'cons': [
        'More verbose than GetX for simple cases',
        'Requires MultiProvider setup at root',
      ],
      'tree': '''lib/
├── app/routes/          ← GoRouter config
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── data/
│   ├── models/
│   ├── providers/
│   └── repositories/
├── viewmodels/          ← HomeViewModel (ChangeNotifier)
└── views/
    └── home/            ← HomeView (Consumer<HomeViewModel>)''',
    },
    {
      'name': 'MVC + GetX',
      'state': 'GetX (Reactive .obs, GetxController)',
      'pattern': 'MVC',
      'bestFor': [
        'Simple to medium apps',
        'Quick prototypes',
        'Developers familiar with MVC from other frameworks',
      ],
      'packages': ['get', 'dio', 'get_it', 'go_router', 'equatable'],
      'pros': [
        'Simple, flat structure — easy to navigate',
        'Great for small teams or solo devs',
        'GetX handles routing + DI + state in one',
      ],
      'cons': [
        'Can get messy at scale without feature isolation',
        'Controllers folder grows large in big apps',
      ],
      'tree': '''lib/
├── app/
│   ├── bindings/        ← InitialBinding
│   └── routes/          ← AppPages
├── controllers/         ← HomeController (GetxController)
├── models/              ← Data models
├── views/
│   └── home/            ← HomeView
├── services/            ← ApiService (Dio)
└── core/
    ├── constants/
    ├── theme/
    ├── utils/
    └── widgets/''',
    },
    {
      'name': 'MVC + Provider',
      'state': 'Provider (ChangeNotifier)',
      'pattern': 'MVC',
      'bestFor': [
        'Simple apps with Flutter-native state',
        'Small teams preferring standard Flutter patterns',
        'Apps that may evolve slowly over time',
      ],
      'packages': ['provider', 'go_router', 'dio', 'get_it', 'equatable'],
      'pros': [
        'Very clean and understandable',
        'Uses Flutter-official packages only',
        'Low learning curve',
      ],
      'cons': [
        'No built-in DI or routing — need separate setup',
        'Can grow unwieldy without feature isolation',
      ],
      'tree': '''lib/
├── app/routes/          ← GoRouter
├── controllers/         ← HomeController (ChangeNotifier)
├── models/
├── views/
│   └── home/            ← HomeView
├── services/            ← ApiService
└── core/
    ├── constants/
    ├── theme/
    ├── utils/
    └── widgets/''',
    },
    {
      'name': 'Feature-First + GetX',
      'state': 'GetX (Reactive .obs, GetxController)',
      'pattern': 'Feature-First (Clean Architecture inspired)',
      'bestFor': [
        'Large apps with many features',
        'Multiple developers / teams working in parallel',
        'Apps needing clear separation by domain/feature',
      ],
      'packages': ['get', 'dio', 'get_it', 'go_router', 'equatable'],
      'pros': [
        'Maximum scalability — features are self-contained',
        'Easy to add/remove features without side effects',
        'Clear data / presentation boundary',
      ],
      'cons': [
        'More initial setup and boilerplate',
        'Can be overkill for small apps',
      ],
      'tree': '''lib/
├── core/
│   ├── constants/
│   ├── network/         ← DioClient
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   └── home/
│       ├── data/
│       │   ├── models/
│       │   ├── repositories/ ← HomeRepository
│       │   └── sources/      ← HomeRemoteSource
│       └── presentation/
│           ├── bindings/     ← HomeBinding
│           ├── controllers/  ← HomeController
│           └── views/        ← HomeView
└── app/
    ├── bindings/        ← InitialBinding
    └── routes/          ← AppPages''',
    },
    {
      'name': 'Feature-First + Provider',
      'state': 'Provider (ChangeNotifier)',
      'pattern': 'Feature-First (Clean Architecture inspired)',
      'bestFor': [
        'Large apps with Flutter-native state preference',
        'Teams following Clean Architecture strictly',
        'Projects with strong testing requirements',
      ],
      'packages': ['provider', 'go_router', 'dio', 'get_it', 'equatable'],
      'pros': [
        'Best scalability + testability combination',
        'Each feature is fully independent',
        'Provider makes dependencies explicit',
      ],
      'cons': [
        'Most verbose setup of all options',
        'Requires discipline to maintain boundaries',
      ],
      'tree': '''lib/
├── core/
│   ├── constants/
│   ├── network/         ← DioClient
│   ├── theme/
│   ├── utils/
│   └── widgets/
├── features/
│   └── home/
│       ├── data/
│       │   ├── models/
│       │   ├── repositories/ ← HomeRepository
│       │   └── sources/      ← HomeRemoteSource
│       └── presentation/
│           ├── providers/    ← HomeProvider (ChangeNotifier)
│           └── views/        ← HomeView
└── app/routes/          ← GoRouter''',
    },
  ];

  @override
  Future<void> run(List<String> args) async {
    if (args.isEmpty || args.contains('--help') || args.contains('-h')) {
      Logger.info(usage);
      return;
    }

    final n = int.tryParse(args.first);
    if (n == null || n < 1 || n > _structures.length) {
      Logger.error('Please provide a number between 1 and ${_structures.length}.');
      exit(1);
    }

    final s = _structures[n - 1];

    Logger.info('\n\x1B[1m\x1B[36m$n. ${s['name']}\x1B[0m\n');
    Logger.info('  Pattern : ${s['pattern']}');
    Logger.info('  State   : ${s['state']}\n');

    Logger.info('\x1B[33m  Best for:\x1B[0m');
    for (final b in s['bestFor'] as List) {
      Logger.info('    • $b');
    }

    Logger.info('\n\x1B[32m  Pros:\x1B[0m');
    for (final p in s['pros'] as List) {
      Logger.info('    ✓ $p');
    }

    Logger.info('\n\x1B[31m  Cons:\x1B[0m');
    for (final c in s['cons'] as List) {
      Logger.info('    ✗ $c');
    }

    Logger.info('\n\x1B[36m  Included packages:\x1B[0m');
    Logger.info('    ${(s['packages'] as List).join(', ')}, logger, shared_preferences, cached_network_image, flutter_svg\n');

    Logger.info('\x1B[36m  Folder tree:\x1B[0m\n');
    for (final line in (s['tree'] as String).split('\n')) {
      Logger.dim('    $line');
    }

    Logger.info('\n  Use: \x1B[1mscaffold create <project> --structure $n\x1B[0m\n');
  }
}
