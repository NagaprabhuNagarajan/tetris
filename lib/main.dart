// ignore_for_file: constant_identifier_names
import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tetris/gamer/gamer.dart';
import 'package:tetris/generated/l10n.dart';
import 'package:tetris/material/audios.dart';
import 'package:tetris/panel/page_portrait.dart';
import 'gamer/keyboard.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  _disableDebugPrint();
  runApp(const MyApp());
}

void _disableDebugPrint() {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  if (!debug) {
    debugPrint = (message, {wrapWidth}) {
      //disable log print when not in debug mode
    };
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Tetris',
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        navigatorObservers: [routeObserver],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen());
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                body: Sound(
                    child: Game(child: KeyboardController(child: _HomePage()))),
              ),
            )));
    super.initState();
  }

  static List<Color> colorizeColors = [
    Colors.green[900]!,
    Colors.blue[700]!,
    Colors.yellow[600]!,
    Colors.red[600]!,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    letterSpacing: 1.3,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/tetris.png',
                width: 130, height: 130, fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('Tetris',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                      speed: const Duration(milliseconds: 1500)),
                ],
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const SCREEN_BORDER_WIDTH = 3.0;

const BACKGROUND_COLOR = Color.fromARGB(255, 239, 193, 25);

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //only Android/iOS support land mode
    bool land = MediaQuery.of(context).orientation == Orientation.landscape;
    return land ? const PageLand() : const PagePortrait();
  }
}
