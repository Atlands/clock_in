import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frequency/page/home.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:frequency/provider/home_provider.dart';
import 'package:frequency/utils/color_utils.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => ApplicationProvider())],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('zh'),
          Locale('en')
          // const Locale('ar'),
          // const Locale('ja'),
        ],
        locale: const Locale('zh'),
        title: 'Frequency',
        themeMode: ThemeMode.system,
        theme: ThemeData(
            platform: TargetPlatform.iOS,
            scaffoldBackgroundColor: lightScaffoldBackgroundColor,
            appBarTheme: AppBarTheme(
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.dark
                    .copyWith(statusBarColor: lightScaffoldBackgroundColor),
                iconTheme:
                    const IconThemeData(color: Colors.black, opacity: 0.7),
                centerTitle: false,
                titleTextStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                backgroundColor: lightScaffoldBackgroundColor)),
        darkTheme: ThemeData(
            appBarTheme: AppBarTheme(
                elevation: 0,
                centerTitle: false,
                systemOverlayStyle: SystemUiOverlayStyle.light
                    .copyWith(statusBarColor: darkScaffoldBackgroundColor),
                backgroundColor: darkScaffoldBackgroundColor),
            platform: TargetPlatform.iOS,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: darkScaffoldBackgroundColor),
        builder: hideKeyboardBuilder,
        home: FutureBuilder(
            future: context.read<ApplicationProvider>().initConfigure(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  Jiffy.locale("zh_cn");
                  return ChangeNotifierProvider(
                      create: (context) => HomeProvider(), child: const Home());
                } else {
                  return Container();
                }
              } else {
                // 请求未结束，显示loading
                return Center(
                  child: Image.asset('assets/image/logo.png'),
                );
              }
            })));
  }

  Widget hideKeyboardBuilder(context, child) => Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: child,
        ),
      );
}
