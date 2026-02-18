import 'package:path/path.dart' as p;
import 'project_generator.dart';
import 'file_helpers.dart';

/// lib/
///   app/
///     bindings/
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
///   modules/
///     home/
///       bindings/
///       controllers/
///       views/
///   main.dart
class MvvmGetxGenerator implements StructureGenerator {
  @override
  Future<void> generate(String projectPath, String projectName) async {
    final lib = p.join(projectPath, 'lib');

    // ── Directories ──────────────────────────────────────────────────
    final dirs = [
      'app/bindings',
      'app/routes',
      'core/constants',
      'core/theme',
      'core/utils',
      'core/widgets',
      'data/models',
      'data/providers',
      'data/repositories',
      'modules/home/bindings',
      'modules/home/controllers',
      'modules/home/views',
    ];
    for (final d in dirs) await mkDir(p.join(lib, d));

    // ── Files ────────────────────────────────────────────────────────
    await writeFile(p.join(lib, 'main.dart'), _mainDart(projectName));
    await writeFile(p.join(lib, 'app/routes/app_pages.dart'), _appPages());
    await writeFile(p.join(lib, 'app/routes/app_routes.dart'), _appRoutes());
    await writeFile(p.join(lib, 'app/bindings/initial_binding.dart'), _initialBinding());
    await writeFile(p.join(lib, 'core/theme/app_theme.dart'), _appTheme());
    await writeFile(p.join(lib, 'core/constants/app_constants.dart'), _constants());
    await writeFile(p.join(lib, 'modules/home/controllers/home_controller.dart'), _homeController());
    await writeFile(p.join(lib, 'modules/home/views/home_view.dart'), _homeView());
    await writeFile(p.join(lib, 'modules/home/bindings/home_binding.dart'), _homeBinding());
    await writeFile(p.join(lib, 'data/repositories/base_repository.dart'), _baseRepo());
  }

  String _mainDart(String name) => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '${_pascal(name)}',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
''';

  String _appRoutes() => '''
abstract class Routes {
  static const home = '/home';
}
''';

  String _appPages() => '''
import 'package:get/get.dart';
import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';
import 'app_routes.dart';

abstract class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
''';

  String _initialBinding() => '''
import 'package:get/get.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register global dependencies here
  }
}
''';

  String _appTheme() => '''
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
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
import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  void increment() => count++;
}
''';

  String _homeView() => '''
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Obx(() => Text('Count: \${controller.count}')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
''';

  String _homeBinding() => '''
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
''';

  String _baseRepo() => '''
abstract class BaseRepository {
  // Common repository methods
}
''';

  String _pascal(String s) =>
      s.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();
}
