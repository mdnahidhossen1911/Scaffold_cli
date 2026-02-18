import 'package:path/path.dart' as p;
import 'project_generator.dart';
import 'file_helpers.dart';

/// lib/
///   core/
///     constants/
///     theme/
///     utils/
///     widgets/
///     network/
///   features/
///     home/
///       data/
///         models/
///         repositories/
///         sources/
///       presentation/
///         bindings/
///         controllers/
///         views/
///   app/
///     routes/
///     bindings/
///   main.dart
class FeatureFirstGetxGenerator implements StructureGenerator {
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
      'features/home/presentation/bindings',
      'features/home/presentation/controllers',
      'features/home/presentation/views',
      'app/routes',
      'app/bindings',
    ];
    for (final d in dirs) await mkDir(p.join(lib, d));

    await writeFile(p.join(lib, 'main.dart'), _mainDart(projectName));
    await writeFile(p.join(lib, 'app/routes/app_pages.dart'), _appPages());
    await writeFile(p.join(lib, 'app/routes/app_routes.dart'), _appRoutes());
    await writeFile(p.join(lib, 'app/bindings/initial_binding.dart'), _initialBinding());
    await writeFile(p.join(lib, 'core/theme/app_theme.dart'), _appTheme());
    await writeFile(p.join(lib, 'core/constants/app_constants.dart'), _constants());
    await writeFile(p.join(lib, 'core/network/dio_client.dart'), _dioClient());
    await writeFile(p.join(lib, 'features/home/data/repositories/home_repository.dart'), _homeRepo());
    await writeFile(p.join(lib, 'features/home/data/sources/home_remote_source.dart'), _homeRemote());
    await writeFile(p.join(lib, 'features/home/presentation/controllers/home_controller.dart'), _homeController());
    await writeFile(p.join(lib, 'features/home/presentation/views/home_view.dart'), _homeView());
    await writeFile(p.join(lib, 'features/home/presentation/bindings/home_binding.dart'), _homeBinding());
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
import '../../features/home/presentation/bindings/home_binding.dart';
import '../../features/home/presentation/views/home_view.dart';
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
import '../../core/network/dio_client.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DioClient>(DioClient(), permanent: true);
  }
}
''';

  String _appTheme() => '''
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
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

  // Add your repository methods here
}
''';

  String _homeRemote() => '''
import 'package:get/get.dart';
import '../../../../core/network/dio_client.dart';

class HomeRemoteSource {
  final DioClient _client = Get.find<DioClient>();

  // Add your remote data source methods here
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
import '../../data/sources/home_remote_source.dart';
import '../../data/repositories/home_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRemoteSource>(() => HomeRemoteSource());
    Get.lazyPut<HomeRepository>(() => HomeRepository(Get.find()));
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
''';

  String _pascal(String s) =>
      s.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join();
}
