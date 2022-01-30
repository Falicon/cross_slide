import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '/models/config_settings.dart';

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
  Color _black = Color(0xff000000);
  Color _grey = Color(0xff6c757d);
  Color _green = Color(0xff90EE90);
  Color _white = Color(0xffFFFFFF);
  Color _yellow = Color(0xffffffe0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _grey),
          onPressed: () => Navigator.pop(context)
        ),
        title: Text('ABOUT CROSSWORD SLIDE', style: Theme.of(context).textTheme.headline6?.copyWith(color: _grey)),
      ),
      backgroundColor: _white,
      body: Container(
        color: _white,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ListTile(
              title: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Cross Slide is a simple crossword meets a slide puzzle game brought to you by Kevin Marshall of ',
                      style: TextStyle(color: _grey)
                    ),
                    TextSpan(
                      text: 'Dig Down Labs LLC',
                      style: TextStyle(color: _black, fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                      text: '. For more information about the game and our other projects, please visit our website at ',
                      style: TextStyle(color: _grey)
                    ),
                    TextSpan(
                      text: 'www.digdownlabs.com',
                      style: TextStyle(color: _green),
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
