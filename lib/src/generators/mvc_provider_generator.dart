import 'package:path/path.dart' as p;
import 'project_generator.dart';
import 'file_helpers.dart';

class MvcProviderGenerator implements StructureGenerator {
  @override
  Future<void> generate(String projectPath, String projectName) async {
    final lib = p.join(projectPath, 'lib');

    final dirs = [
      'app/routes',
      'controllers',
      'models',
      'views/home',
      'services',
      'core/constants',
      'core/theme',
      'core/utils',
      'core/widgets',
    ];
    for (final d in dirs) await mkDir(p.join(lib, d));

    await writeFile(p.join(lib, 'main.dart'), _mainDart(projectName));
    await writeFile(p.join(lib, 'app/routes/app_router.dart'), _appRouter());
    await writeFile(p.join(lib, 'core/theme/app_theme.dart'), _appTheme());
    await writeFile(p.join(lib, 'core/constants/app_constants.dart'), _constants());
    await writeFile(p.join(lib, 'controllers/home_controller.dart'), _homeController());
    await writeFile(p.join(lib, 'views/home/home_view.dart'), _homeView());
    await writeFile(p.join(lib, 'models/base_model.dart'), _baseModel());
    await writeFile(p.join(lib, 'services/api_service.dart'), _apiService());
  }

  String _mainDart(String name) => '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'controllers/home_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
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
        colorSchemeSeed: Colors.green,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
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

  String _homeController() => '''
import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
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
import '../../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<HomeController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: Text('Count: \${ctrl.count}')),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<HomeController>().increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';

  String _baseModel() => '''
abstract class BaseModel {
  Map<String, dynamic> toJson();
}
''';

  String _apiService() => '''
import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));
  }

  Future<Response> get(String path) => _dio.get(path);
  Future<Response> post(String path, {dynamic data}) => _dio.post(path, data: data);
}
''';

  String _pascal(String s) =>
      s.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();
}
