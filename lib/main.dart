import 'dart:io';
import 'package:flutter/material.dart';

import 'package:cross_slide/screens/game/game.dart';

import 'package:cross_slide/screens/util/about.dart';

import 'package:cross_slide/theme/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Widget _defaultHome = Game();

  runApp(MaterialApp(
    title: 'CROSSWORD SLIDE PUZZLE',
    theme: appTheme(),
    initialRoute: '/',
    routes: <String, WidgetBuilder>{
      "/": (BuildContext context) => _defaultHome,
      "/about": (BuildContext context) => About(),
    }
  ));
}
