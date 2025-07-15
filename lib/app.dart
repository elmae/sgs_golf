import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sgs_golf/core/navigation/app_router.dart';
import 'package:sgs_golf/core/theme/app_theme.dart';
import 'package:sgs_golf/data/models/practice_session.dart';
import 'package:sgs_golf/data/repositories/practice_repository.dart';
import 'package:sgs_golf/features/analysis/analysis_screen.dart';
import 'package:sgs_golf/features/auth/login_screen.dart';
import 'package:sgs_golf/features/dashboard/dashboard_screen.dart';
import 'package:sgs_golf/features/dashboard/providers/dashboard_provider.dart';
import 'package:sgs_golf/features/demo/routes.dart';
import 'package:sgs_golf/features/export/export_screen.dart';
import 'package:sgs_golf/features/practice/practice_screen.dart';
import 'package:sgs_golf/features/practice/providers/practice_provider.dart';

/// Aplicación principal SGS Golf
class SGSGolfApp extends StatelessWidget {
  const SGSGolfApp({super.key});

  @override
  Widget build(BuildContext context) {
    final practiceRepository = PracticeRepository(
      Hive.box<PracticeSession>('practiceSessions'),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(practiceRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => PracticeProvider(practiceRepository),
        ),
        // Otros providers de la aplicación
      ],
      child: MaterialApp(
        title: 'SGS Golf',
        theme: appTheme,
        initialRoute: AppRoutes
            .dashboard, // Cambia a login cuando esté listo el flujo de autenticación
        routes: {
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.dashboard: (context) => const DashboardScreen(),
          AppRoutes.practice: (context) => const PracticeScreen(),
          AppRoutes.analysis: (context) => const AnalysisScreen(),
          AppRoutes.export: (context) => const ExportScreen(),
          // Rutas para páginas de demostración
          ...DemoRoutes.routes(),
        },
      ),
    );
  }
}
