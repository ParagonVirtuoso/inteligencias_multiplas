import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';
import 'navigation/rotas.dart';
import 'screens/loginPage/login_page.dart';
import 'utils/cores.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    try {
      const fbAppId = DefaultFirebaseOptions.facebookAppId;
      if (fbAppId.isNotEmpty && fbAppId != 'YOUR_FACEBOOK_APP_ID') {
        await FacebookAuth.instance.webAndDesktopInitialize(
          appId: fbAppId,
          cookie: true,
          xfbml: true,
          version: 'v15.0',
        );
      }
    } catch (e) {
      debugPrint('Erro ao inicializar FacebookAuth no Web: $e');
    }
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final bool isWebOverride;

  const MyApp({super.key, this.isWebOverride = kIsWeb});

  /// Limite recomendado para conteúdos internos adaptáveis em telas desktop web
  static const double kMaxWebWidth = 1000.0;

  @override
  Widget build(BuildContext context) {
    if (!isWebOverride) {
      // No Mobile (Android e iOS), o comportamento original não pode ser afetado em nada
      return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            routes: {
              ...Rotas.routes,
              '/': (context) => LoginPage(isWebOverride: isWebOverride),
            },
            theme: ThemeData(
              primaryColor: Cores.kPrimaryColor,
              primarySwatch: Colors.lightBlue,
            ),
          );
        },
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth > 0
            ? constraints.maxWidth
            : 360.0;
        final availableHeight = constraints.maxHeight > 0 &&
                constraints.maxHeight != double.infinity
            ? constraints.maxHeight
            : 900.0;
        final isDesktopWeb = availableWidth > 600;

        final windowView = View.maybeOf(context);
        final rawMq = windowView != null
            ? MediaQueryData.fromView(windowView)
            : (MediaQuery.maybeOf(context) ?? const MediaQueryData());

        final effectiveMq = rawMq.copyWith(
          size: Size(availableWidth, availableHeight),
        );

        double customFontSizeResolver(num fontSize, ScreenUtil instance) {
          if (isDesktopWeb) {
            // Em desktop/tablet web, mantém tamanhos de fonte equilibrados e confortáveis
            final double webScale =
                (availableWidth / 1080 * 0.42).clamp(0.36, 0.44);
            return fontSize * webScale;
          }
          return FontSizeResolvers.width(fontSize, instance);
        }

        return MediaQuery(
          data: effectiveMq,
          child: ScreenUtilInit(
            designSize: const Size(1080, 1920),
            minTextAdapt: true,
            useInheritedMediaQuery: true,
            fontSizeResolver: customFontSizeResolver,
            builder: (context, child) {
              ScreenUtil.configure(
                data: effectiveMq,
                fontSizeResolver: customFontSizeResolver,
              );
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                routes: {
                  ...Rotas.routes,
                  '/': (context) => LoginPage(isWebOverride: isWebOverride),
                },
                theme: ThemeData(
                  primaryColor: Cores.kPrimaryColor,
                  primarySwatch: Colors.lightBlue,
                ),
                builder: (context, child) {
                  ScreenUtil.configure(
                    data: effectiveMq,
                    fontSizeResolver: customFontSizeResolver,
                  );
                  return MediaQuery(
                    data: effectiveMq,
                    child: child ?? const SizedBox.shrink(),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
