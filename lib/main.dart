import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'constants.dart';
import 'data/gallery_options.dart';
import 'layout/letter_spacing.dart';
import 'modules/home/view/home.dart';
import 'modules/login/view/login.dart';
import 'routes.dart' as routes;

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const RallyApp());
}

class RallyApp extends StatelessWidget {
  const RallyApp({
    super.key,
    this.initialRoute,
    this.isTestMode = false,
  });

  final String? initialRoute;
  final bool isTestMode;

  ThemeData _buildRallyTheme() {
    final base = ThemeData.dark();
    return ThemeData(
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: RallyColors.primaryBackground,
        elevation: 0,
      ),
      scaffoldBackgroundColor: RallyColors.primaryBackground,
      primaryColor: RallyColors.primaryBackground,
      focusColor: RallyColors.focusColor,
      textTheme: _buildRallyTextTheme(base.textTheme),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: RallyColors.gray,
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: RallyColors.inputBackground,
        focusedBorder: InputBorder.none,
      ),
      visualDensity: VisualDensity.standard,
    );
  }

  TextTheme _buildRallyTextTheme(TextTheme base) {
    return base
        .copyWith(
          bodyMedium: GoogleFonts.robotoCondensed(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: letterSpacingOrNone(0.5),
          ),
          bodyLarge: GoogleFonts.eczar(
            fontSize: 40,
            fontWeight: FontWeight.w400,
            letterSpacing: letterSpacingOrNone(1.4),
          ),
          labelLarge: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.w700,
            letterSpacing: letterSpacingOrNone(2.8),
          ),
          headlineSmall: GoogleFonts.eczar(
            fontSize: 40,
            fontWeight: FontWeight.w600,
            letterSpacing: letterSpacingOrNone(1.4),
          ),
        )
        .apply(
          displayColor: Colors.white,
          bodyColor: Colors.white,
        );
  }

  static const String loginRoute = routes.loginRoute;
  static const String homeRoute = routes.homeRoute;
  final sharedZAxisTransitionBuilder = const SharedAxisPageTransitionsBuilder(
    fillColor: RallyColors.primaryBackground,
    transitionType: SharedAxisTransitionType.scaled,
  );

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTestMode: isTestMode,
      ),
      child: Builder(
        builder: (context) {
          final options = GalleryOptions.of(context);
          return MaterialApp(
            //key: Get.key,
            restorationScopeId: 'rally_app',
            title: 'ADMIN',
            debugShowCheckedModeBanner: false,
            theme: _buildRallyTheme().copyWith(
              platform: GalleryOptions.of(context).platform,
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  for (var type in TargetPlatform.values)
                    type: sharedZAxisTransitionBuilder,
                },
              ),
            ),
            locale: GalleryOptions.of(context).locale,
            initialRoute: loginRoute,
            routes: <String, WidgetBuilder>{
              homeRoute: (context) => const HomePage(),
              loginRoute: (context) => const LoginPage(),
            },
          );
        },
      ),
    );
  }
}
