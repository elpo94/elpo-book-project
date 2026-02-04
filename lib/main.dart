
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/services/project_store.dart';
import 'package:sabujak_application/services/timer_setting_service.dart';
import 'package:sabujak_application/view_models/home/timer_vm.dart';
import 'package:sabujak_application/view_models/project/project_create_vm.dart';
import 'package:sabujak_application/view_models/project/project_vm.dart';
import 'package:sabujak_application/view_models/schedule/schedule_vm.dart';

import 'view_models/home/home_vm.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

//파이어베이스
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:sabujak_application/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  final authService = AuthService();
  await authService.signInAnonymously();
  final settingService = SettingService();

  runApp(
    MultiProvider(
      providers: [
        //로그인
        Provider(create: (_) => authService),

        // 서류함
        ChangeNotifierProvider(create: (_) => ProjectStore()),

        //todo: jh ProxyProvider사용법 잘못됐음.
        ChangeNotifierProxyProvider<ProjectStore, HomeViewModel>(
          create: (context) => HomeViewModel(context.read<ProjectStore>()),
          update: (context, store, previous) => previous ?? HomeViewModel(store),
        ),

        ChangeNotifierProxyProvider<ProjectStore, ProjectViewModel>(
          create: (context) => ProjectViewModel(context.read<ProjectStore>()),
          update: (context, store, previous) => previous ?? ProjectViewModel(store),
        ),

        ChangeNotifierProxyProvider<ProjectStore, ScheduleVM>(
          create: (context) => ScheduleVM(context.read<ProjectStore>()),
          update: (context, store, previous) => previous ?? ScheduleVM(store),
        ),

        ChangeNotifierProvider(create: (_) => TimerViewModel(settingService)),
        ChangeNotifierProvider(create: (_) => ProjectCreateViewModel()),
      ],
      child: const SabujakApp(),
    ),
  );
}

class SabujakApp extends StatelessWidget {
  const SabujakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: '사부작',
      theme: appTheme,
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
    );
  }
}

