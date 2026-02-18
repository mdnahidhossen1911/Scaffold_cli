import 'package:path/path.dart' as p;
import 'project_generator.dart';
import 'file_helpers.dart';

class FeatureFirstProviderGenerator implements StructureGenerator {
  @override
  Future<void> generate(String projectPath, String projectName) async {
    final lib = p.join(projectPath, 'lib');

    final dirs = [
      'core/constants',
      'core/theme',
      'core/utils',
      'core/widgets',
      'core/network',
      'features/home/data/models',
      'features/home/data/repositories',
      'features/home/data/sources',
      'features/home/presentation/providers',
      'features/home/presentation/views',
      'app/routes',
    ];
    for (final d in dirs) await mkDir(p.join(lib, d));

    await writeFile(p.join(lib, 'main.dart'), _mainDart(projectName));
    await writeFile(p.join(lib, 'app/routes/app_router.dart'), _appRouter());
    await writeFile(p.join(lib, 'core/theme/app_theme.dart'), _appTheme());
    await writeFile(p.join(lib, 'core/constants/app_constants.dart'), _constants());
    await writeFile(p.join(lib, 'core/network/dio_client.dart'), _dioClient());
    await writeFile(p.join(lib, 'features/home/data/repositories/home_repository.dart'), _homeRepo());
    await writeFile(p.join(lib, 'features/home/data/sources/home_remote_source.dart'), _homeRemote());
    await writeFile(p.join(lib, 'features/home/presentation/providers/home_provider.dart'), _homeProvider());
    await writeFile(p.join(lib, 'features/home/presentation/views/home_view.dart'), _homeView());
  }

  String _mainDart(String name) => '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/providers/home_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
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
import '../../features/home/presentation/views/home_view.dart';

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
        colorSchemeSeed: Colors.orange,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
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

  String _dioClient() => '''
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
  }
}
''';

  String _homeRepo() => '''
import '../sources/home_remote_source.dart';

class HomeRepository {
  final HomeRemoteSource _remote;
  HomeRepository(this._remote);
}
''';

  String _homeRemote() => '''
class HomeRemoteSource {
  // Remote data source methods
}
''';

  String _homeProvider() => '''
import 'package:flutter/foundation.dart';

class HomeProvider extends ChangeNotifier {
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
import '../providers/home_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<HomeProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: Text('Count: \${prov.count}')),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<HomeProvider>().increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';

  String _pascal(String s) =>
      s.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();
}
