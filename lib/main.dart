import 'package:flutter/material.dart';
import 'package:flutter_application_2/data/favorite_manager.dart';
import 'package:flutter_application_2/data/repo/auth_repository.dart';
import 'package:flutter_application_2/theme.dart';
import 'package:flutter_application_2/ui/root.dart';

void main()async {
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
        color: LightThemeColors.primaryTextColor, fontWeight: FontWeight.bold);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: LightThemeColors.secondaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:
                        LightThemeColors.primaryTextColor.withOpacity(0.1)))),
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: LightThemeColors.primaryTextColor,
            elevation: 0),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            extendedTextStyle: TextStyle(fontSize: 18),
            backgroundColor: LightThemeColors.secondaryColor),
        textTheme: TextTheme(
            bodyMedium: defaultTextStyle,
            bodySmall: defaultTextStyle.apply(
                color: LightThemeColors.secondaryTextColor),
            titleLarge: defaultTextStyle.copyWith(fontWeight: FontWeight.bold)),
        colorScheme: const ColorScheme.light(
            primary: LightThemeColors.primaryColor,
            secondary: LightThemeColors.secondaryColor,
            onSecondary: Colors.white,
            surfaceContainerHighest: Color(0xffF5F5F5)),
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: RootScreen()),
    );
  }
}
