import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';

// ########################################
// ABOUT STATEFUL
// ########################################
class About extends StatefulWidget {
  About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

// ########################################
// ABOUT STATE
// ########################################
class _AboutState extends State<About> {
  Color _background_color = Color(0xff6c757d);

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _background_color,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context)
        ),
        title: Text('Cross Slide: The crossword slide puzzle game.', style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white)),
      ),
      backgroundColor: _background_color,
      body: Container(
        color: _background_color,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ListTile(
              title: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Cross Slide is a simple crossword meets a slide puzzle game brought to you by Kevin Marshall of ',
                      style: TextStyle(color: Colors.white)
                    ),
                    TextSpan(
                      text: 'Dig Down Labs LLC',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                      text: '. For more information about the game and our other projects, please visit our website at ',
                      style: TextStyle(color: Colors.white)
                    ),
                    TextSpan(
                      text: 'www.digdownlabs.com',
                      style: TextStyle(color: Color(0xeeFFFF00)),
                      recognizer: new TapGestureRecognizer()..onTap = () => launch('https://www.digdownlabs.com')
                    ),
                  ]
                )
              )
            )
          ]
        )
      )
    );
  }
}
