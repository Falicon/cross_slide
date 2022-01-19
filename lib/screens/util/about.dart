import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:scross_slide/models/data_store.dart';

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
        title: Text('KAZIT: THE AUDIO GUESSING GAME.', style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white)),
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
                      text: 'Kazit is a quick, fun, game to see how many brands you can guess correctly based on just the audio they use.\n\n',
                      style: TextStyle(color: Colors.white)
                    ),
                    TextSpan(
                      text: 'There are four different game modes that can be played:\n\n',
                      style: TextStyle(color: Colors.white)
                    ),
                    TextSpan(
                      text: '1. Guess the audio',
                      style: TextStyle(color: Color(0xff6610f2)),
                      recognizer: new TapGestureRecognizer()..onTap = () {
                        Navigator.pushReplacementNamed(context, '/guess/game');
                      }
                    ),
                    TextSpan(
                      text: ' - Listen to the audio and try to guess the brand.\n\n',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: '2. Choose the audio',
                      style: TextStyle(color: Color(0xfffd7e14)),
                      recognizer: new TapGestureRecognizer()..onTap = () {
                        Navigator.pushReplacementNamed(context, '/choice/game');
                      }
                    ),
                    TextSpan(
                      text: ' - Listen to the audio and pick the brand from the available choices.\n\n',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: '3. Two Minute Mode',
                      style: TextStyle(color: Color(0xffffc107)),
                      recognizer: new TapGestureRecognizer()..onTap = () async {
                        Map<String, dynamic> temp = { 'game_mode': 'timed' };
                        DataStorage.writeData(temp);
                        Navigator.pushReplacementNamed(context, '/timed/game');
                      }
                    ),
                    TextSpan(
                      text: ' - How many brands can you correctly guess within a two minute time limit?\n\n',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextSpan(
                      text: '4. Timed Mode',
                      style: TextStyle(color: Color(0xff20c997)),
                      recognizer: new TapGestureRecognizer()..onTap = () async {
                        Map<String, dynamic> temp = { 'game_mode': 'time_per_pick' };
                        DataStorage.writeData(temp);
                        Navigator.pushReplacementNamed(context, '/timed/game');
                      }
                    ),
                    TextSpan(
                      text: ' - Guess the brand within a specified period of time (time gets shorter as your streak gets longer).\n',
                      style: TextStyle(color: Colors.white),
                    ),
                  ]
                )
              )
            ),
            ListTile(
              title: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Kazit is an audio guessing game brought to you by the team at ',
                      style: TextStyle(color: Colors.white)
                    ),
                    TextSpan(
                      text: 'Veritonic',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                      text: '. For more information about the game and all the audio intelligence Veritonic can provide you, please visit our website at ',
                      style: TextStyle(color: Colors.white)
                    ),
                    TextSpan(
                      text: 'www.veritonic.com',
                      style: TextStyle(color: Color(0xeeFFFF00)),
                      recognizer: new TapGestureRecognizer()..onTap = () => launch('https://www.veritonic.com')
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
