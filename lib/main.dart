import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uaws/screens/admin_dashboard_screen.dart';
import 'package:uaws/screens/field_dashboard_screen.dart';
import 'package:uaws/screens/municipal_dashboard_screen.dart';
import 'package:uaws/screens/sign_up_screen.dart';
import 'package:uaws/screens/supervisor_dashboard_screen.dart';
import 'controllers/admin_dashboard_controller.dart';
import 'controllers/field_dashboard_controller.dart';
import 'controllers/municipal_dashboard_controller.dart';
import 'controllers/supervisor_dashboard_controller.dart';
import 'core/theme/app_theme.dart';
import 'services/storage_service.dart';
import 'services/auth_service.dart';
import 'services/dummy_data_service.dart';
import 'translations/app_translations.dart';
import 'screens/login_screen.dart';
import 'controllers/login_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DummyDataService.loadDummyData();
  await initServices();

  runApp(MyApp());
}

Future<void> initServices() async {
  print('🚀 Starting UAWS services...');

  try {
    await Get.putAsync(() => StorageService().init());
    Get.put(AuthService());

    // Pre-initialize LoginController to avoid lag
    Get.lazyPut(() => LoginController());

    print('🎉 All UAWS services started successfully!');
  } catch (e) {
    print('❌ Error initializing services: $e');
  }
}

class MyApp extends StatelessWidget {
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
