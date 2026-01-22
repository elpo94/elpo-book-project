
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sabujak_application/services/project_store.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        // 1. 가장 먼저 중앙 서류함(Store)을 만듭니다.
        ChangeNotifierProvider(create: (_) => ProjectStore()),

        // 2. ProjectViewModel: Store를 주입받아 사용합니다.
        ChangeNotifierProxyProvider<ProjectStore, ProjectViewModel>(
          create: (context) => ProjectViewModel(context.read<ProjectStore>()),
          update: (context, store, previous) => previous ?? ProjectViewModel(store),
        ),

        // 3. ScheduleVM: 마찬가지로 Store를 주입받습니다.
        ChangeNotifierProxyProvider<ProjectStore, ScheduleVM>(
          create: (context) => ScheduleVM(context.read<ProjectStore>()),
          update: (context, store, previous) => previous ?? ScheduleVM(store),
        ),

        // 4. 나머지 독립적인 VM들은 기존처럼 유지 (중복된 구형 코드는 삭제하세요!)
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => TimerViewModel()),
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
