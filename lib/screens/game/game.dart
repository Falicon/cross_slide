import 'dart:math';

import 'package:flutter/material.dart';

// ########################################
// GAME STATEFUL
// ########################################
class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

// ########################################
// GAME STATE
// ########################################
class _GameState extends State<Game> {
  // Set up the initial tiles 
  late List boxes = [
    {'top': 0.0, 'left': 0.0, 'letter': 'A'},
    {'top': 0.0, 'left': 55.0, 'letter': 'B'},
    {'top': 0.0, 'left': 110.0, 'letter': 'C'},

    {'top': 55.0, 'left': 0.0, 'letter': 'D'},
    {'top': 55.0, 'left': 55.0, 'letter': 'E'},
    {'top': 55.0, 'left': 110.0, 'letter': 'F'},

    {'top': 110.0, 'left': 0.0, 'letter': 'G'},
    {'top': 110.0, 'left': 55.0, 'letter': 'H'},
    {'top': 110.0, 'left': 110.0, 'letter': ''}
  ];

  int _animation_speed = 500;

  @override
  void initState() {
    super.initState();
  }

  void changePosition(int box_slot) {
    if (box_slot == 0) {
      boxes[0]['left'] = 55.0;
      boxes[1]['left'] = 110.0;
    } else {
      // we know what box was clicked; 
      // so determine it's location in the grid;
      // determine where the empty box is in the grid
      // determine direction we need to move
      // move all the proper boxes the correct amounts
      boxes[box_slot]['top'] = 55.0;
    }
    setState(() { });
  }

  List<Widget> _buildBoxes() {
    List<AnimatedPositioned> _tiles = [];
    for (var i = 0; i < boxes.length; i++) {
      _tiles.add(
        AnimatedPositioned(
          top: boxes[i]['top'],
          left: boxes[i]['left'],
          duration: Duration(milliseconds: _animation_speed),
          child: InkWell(
            onTap: () => changePosition(i),
            child: Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              child: Text(boxes[i]['letter'], style: TextStyle(color: Color(0xff000000))),
              color: Color(0xffFFFFFF)
            )
          )
        )
      );
    }
    return _tiles;
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const Text('AnimatedPositioned'));
    final topPadding = MediaQuery.of(context).padding.top;

    // AnimatedPositioned animates changes to a widget's position within a Stack
    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        height: 400,
        width: 400,
        child: Stack(
          children: _buildBoxes()
        )
      )
    );
  }
}