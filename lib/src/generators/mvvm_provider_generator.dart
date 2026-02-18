import 'package:path/path.dart' as p;
import 'project_generator.dart';
import 'file_helpers.dart';

/// lib/
///   app/
///     routes/
///   core/
///     constants/
///     theme/
///     utils/
///     widgets/
///   data/
///     models/
///     providers/
///     repositories/
///   viewmodels/
///   views/
///     home/
///   main.dart
class MvvmProviderGenerator implements StructureGenerator {
  @override
  Future<void> generate(String projectPath, String projectName) async {
    final lib = p.join(projectPath, 'lib');

    final dirs = [
      'app/routes',
      'core/constants',
      'core/theme',
      'core/utils',
      'core/widgets',
      'data/models',
      'data/providers',
      'data/repositories',
      'viewmodels',
      'views/home',
    ];
    for (final d in dirs) await mkDir(p.join(lib, d));

    await writeFile(p.join(lib, 'main.dart'), _mainDart(projectName));
    await writeFile(p.join(lib, 'app/routes/app_router.dart'), _appRouter());
    await writeFile(p.join(lib, 'core/theme/app_theme.dart'), _appTheme());
    await writeFile(p.join(lib, 'core/constants/app_constants.dart'), _constants());
    await writeFile(p.join(lib, 'viewmodels/home_viewmodel.dart'), _homeVM());
    await writeFile(p.join(lib, 'views/home/home_view.dart'), _homeView());
    await writeFile(p.join(lib, 'data/repositories/base_repository.dart'), _baseRepo());
  }

  String _mainDart(String name) => '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'viewmodels/home_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: MaterialApp.router(
        title: '${_pascal(name)}',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
''';

  String _appRouter() => '''
import 'package:go_router/go_router.dart';
import '../../views/home/home_view.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
      ),
    ],
  );
}
''';

  String _appTheme() => '''
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      );
}
''';

  String _constants() => '''
abstract class AppConstants {
  static const appName = 'My App';
  static const baseUrl = 'https://api.example.com';
}
''';

  String _homeVM() => '''
import 'package:flutter/foundation.dart';

class HomeViewModel extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }
}
''';

  String _homeView() => '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: Text('Count: \${vm.count}')),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<HomeViewModel>().increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';

  String _baseRepo() => '''
abstract class BaseRepository {}
''';

  String _pascal(String s) =>
      s.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();
}
