import 'package:flutter/material.dart';
import 'package:school_system/core/helper/shared_prefs_helper.dart';

class ThemeManager {
  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier<ThemeMode>(
        SharedPrefsHelper.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      );

  static bool get isDarkMode => themeNotifier.value == ThemeMode.dark;

  static void forceAppRebuild(BuildContext context) {
    Element? rootElement;
    context.visitAncestorElements((element) {
      rootElement = element;
      return true;
    });

    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    if (rootElement != null) {
      rootElement!.markNeedsBuild();
      rootElement!.visitChildren(rebuild);
    } else {
      (context as Element).markNeedsBuild();
      // ignore: unnecessary_cast
      (context as Element).visitChildren(rebuild);
    }
  }
}
