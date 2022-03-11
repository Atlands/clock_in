import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:frequency/home.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:frequency/provider/home_provider.dart';
import 'package:provider/provider.dart';

void main() {
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
            brightness: Brightness.light,
            appBarTheme: AppBarTheme(
                elevation: 0,
                iconTheme: IconThemeData(
                    color: Theme.of(context).textTheme.titleLarge?.color),
                titleTextStyle: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor)),
        darkTheme: ThemeData(
            platform: TargetPlatform.iOS, brightness: Brightness.dark),
        home: FutureBuilder(
            future: context.read<ApplicationProvider>().initDatabase(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return ChangeNotifierProvider(
                      create: (context) => HomeProvider(), child: const Home());
                } else {
                  return Container();
                }
              } else {
                // 请求未结束，显示loading
                return Container();
              }
            })));
  }
}
