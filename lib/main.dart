import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:uaws/core/utils/app_logger.dart';
import 'package:uaws/modules/dashboard/screens/admin_dashboard_screen.dart';
import 'package:uaws/modules/dashboard/screens/field_dashboard_screen.dart';
import 'package:uaws/modules/dashboard/screens/municipal_dashboard_screen.dart';
import 'package:uaws/modules/auth/screens/sign_up_screen.dart';
import 'package:uaws/modules/dashboard/screens/supervisor_dashboard_screen.dart';
import 'package:uaws/modules/sterilization/screens/sterilization_list_screen.dart';
import 'package:uaws/modules/rabies/screens/rabies_list_screen.dart';
import 'package:uaws/modules/education/screens/education_list_screen.dart';
import 'package:uaws/modules/quarantine/screens/quarantine_list_screen.dart';
import 'package:uaws/modules/quarantine/screens/quarantine_detail_screen.dart';
import 'modules/dashboard/controllers/admin_dashboard_controller.dart';
import 'modules/dashboard/controllers/field_dashboard_controller.dart';
import 'modules/dashboard/controllers/municipal_dashboard_controller.dart';
import 'modules/dashboard/controllers/supervisor_dashboard_controller.dart';
import 'modules/sterilization/controllers/sterilization_controller.dart';
import 'modules/rabies/controllers/rabies_controller.dart';
import 'modules/education/controllers/education_controller.dart';
import 'modules/quarantine/controllers/quarantine_controller.dart';
import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/media_services_initializer.dart';
import 'modules/auth/services/auth_service.dart';
import 'modules/auth/services/dummy_data_service.dart';
import 'translations/app_translations.dart';
import 'modules/auth/screens/login_screen.dart';
import 'modules/auth/controllers/login_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDisplayMode.setHighRefreshRate().catchError((e) {
    AppLogger.w('Error setting the High Refresh Rate.');
  });

  // Initialize Hive for local storage
  await Hive.initFlutter();

  await DummyDataService.loadDummyData();
  await initServices();

  runApp(const MyApp());
}

Future<void> initServices() async {
  AppLogger.i('🚀 Starting UAWS services...');

  try {
    await Get.putAsync(() => StorageService().init());
    Get.put(AuthService());

    // Initialize media services (camera, location, storage, sync)
    await MediaServicesInitializer.initializeServices();

    // Pre-initialize LoginController to avoid lag
    Get.lazyPut(() => LoginController());

    AppLogger.i('🎉 All UAWS services started successfully!');
  } catch (e) {
    AppLogger.e('❌ Error initializing services', e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UAWS Animal Welfare App',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Localization Configuration
      translations: AppTranslations(),
      locale: _getInitialLocale(),
      fallbackLocale: const Locale('en', 'US'),

      // Routes
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
          transition: Transition.fadeIn,
          binding: BindingsBuilder(() {
            Get.lazyPut(() => LoginController());
          }),
        ),
        GetPage(
          name: '/signup',
          page: () => const SignupScreen(),
          transition: Transition.rightToLeft,
        ),
        // GetPage(
        //   name: '/dashboard',
        //   page: () => const TemporaryDashboard(),
        //   transition: Transition.cupertino,
        // ),
        //
        // GetPage(
        //   name: '/dashboard',
        //   page: () => const TemporaryDashboard(),
        //   transition: Transition.cupertino,
        // ),
        // Add Field Dashboard Route
        GetPage(
          name: '/supervisor-dashboard',
          page: () => const SupervisorDashboardScreen(),
          transition: Transition.cupertino,
          binding: BindingsBuilder(() {
            Get.lazyPut(() => SupervisorDashboardController());
          }),
        ),

        // Add to the routes section in main.dart
        GetPage(
          name: '/municipal-dashboard',
          page: () => const MunicipalDashboardScreen(),
          transition: Transition.cupertino,
          binding: BindingsBuilder(() {
            Get.lazyPut(() => MunicipalDashboardController());
          }),
        ),

        // Add to the routes section in main.dart
        GetPage(
          name: '/admin-dashboard',
          page: () => const AdminDashboardScreen(),
          transition: Transition.cupertino,
          binding: BindingsBuilder(() {
            Get.lazyPut(() => AdminDashboardController());
          }),
        ),

        GetPage(
          name: '/field-dashboard',
          page: () => const FieldDashboardScreen(),
          transition: Transition.cupertino,
          binding: BindingsBuilder(() {
            Get.lazyPut(() => FieldDashboardController());
          }),
        ),

        // Sterilization Module Routes
        GetPage(
          name: '/sterilization',
          page: () => const SterilizationListScreen(),
          transition: Transition.cupertino,
          binding: BindingsBuilder(() {
            Get.lazyPut(() => SterilizationController());
          }),
        ),

        // Rabies Module Routes
        GetPage(
          name: '/rabies',
          page: () => const RabiesListScreen(),
          transition: Transition.cupertino,
          binding: BindingsBuilder(() {
            Get.lazyPut(() => RabiesController());
          }),
        ),

        // Education Module Routes
        GetPage(
          name: '/education',
          page: () => const EducationListScreen(),
          transition: Transition.cupertino,
          binding: BindingsBuilder(() {
            Get.lazyPut(() => EducationController());
          }),
        ),

        // Quarantine Module Routes
        GetPage(
          name: '/quarantine',
          page: () => const QuarantineListScreen(),
          transition: Transition.cupertino,
          binding: BindingsBuilder(() {
            Get.lazyPut(() => QuarantineController());
          }),
        ),
        GetPage(
          name: '/quarantine/detail',
          page: () => const QuarantineDetailScreen(),
          transition: Transition.cupertino,
        ),
      ],

      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Locale _getInitialLocale() {
    try {
      final savedLanguage = Get.find<StorageService>().getLanguageSync();
      return savedLanguage == 'मराठी'
          ? const Locale('mr', 'IN')
          : const Locale('en', 'US');
    } catch (e) {
      return const Locale('en', 'US');
    }
  }
}

// ... rest of the dashboard code remains the same
