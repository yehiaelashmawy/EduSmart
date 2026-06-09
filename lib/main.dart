import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:school_system/core/helper/localization_helper.dart';
import 'package:school_system/core/helper/on_generate_route.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/features/splash/presentation/views/splash_view.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_system/core/widgets/messages/manager/messages_cubit.dart';
import 'package:school_system/core/widgets/messages/data/messages_repo.dart';
import 'package:school_system/core/utils/theme_manager.dart';

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsHelper.init();

  // Allow self-signed localhost HTTPS certificates in debug/profile.
  // This matches the Dio client behavior and fixes NetworkImage handshake errors.
  if (!kReleaseMode && !kIsWeb) {
    HttpOverrides.global = _DevHttpOverrides();
  }

  runApp(const SchoolSystemApp());
}

class SchoolSystemApp extends StatelessWidget {
  const SchoolSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MessagesCubit(MessagesRepo())..fetchMessagesConversations(),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeManager.themeNotifier,
        builder: (_, themeMode, _) {
          return ValueListenableBuilder<Locale>(
            valueListenable: LocalizationHelper.localeNotifier,
            builder: (_, locale, _) {
              return MaterialApp(
                key: const ValueKey('school_system_app'),
                themeMode: themeMode,
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                locale: locale,
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                onGenerateRoute: onGenerateRoute,
                initialRoute: SplashView.routeName,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
