import 'dart:io';
import 'package:flutter/material.dart';

import '/screens/game/game.dart';
import '/screens/util/about.dart';
import '/theme/style.dart';

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
