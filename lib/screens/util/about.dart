import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:cross_slide/models/puzzles.dart';

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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context)
        ),
        title: Text('ABOUT CROSSWORD SLIDE', style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.black)),
      ),
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ListTile(
              title: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Cross Slide is a simple crossword meets a slide puzzle game brought to you by Kevin Marshall of ',
                      style: TextStyle(color: Colors.black)
                    ),
                    TextSpan(
                      text: 'Dig Down Labs LLC',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                      text: '. For more information about the game and our other projects, please visit our website at ',
                      style: TextStyle(color: Colors.black)
                    ),
                    TextSpan(
                      text: 'www.digdownlabs.com',
                      style: TextStyle(color: Colors.orange[200]),
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
