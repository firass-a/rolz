import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'shared/mock/mock_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MockData.init();
  runApp(const ProviderScope(child: KastRolzApp()));
}

/// Root widget for KAST-ROLZ — a dark-only, cinematic casting platform.
/// Wires the shared [AppTheme] into a `MaterialApp.router` driven by
/// [appRouterProvider], so navigation stays fully reactive to auth state.
class KastRolzApp extends ConsumerWidget {
  const KastRolzApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'KAST-ROLZ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
