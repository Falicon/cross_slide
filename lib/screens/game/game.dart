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
  late List _boxes = [
    [
      {'top': 0.0, 'left': 0.0, 'letter': 'A'},
      {'top': 0.0, 'left': 55.0, 'letter': 'B'},
      {'top': 0.0, 'left': 110.0, 'letter': 'C'}
    ],

    [
      {'top': 55.0, 'left': 0.0, 'letter': 'D'},
      {'top': 55.0, 'left': 55.0, 'letter': 'E'},
      {'top': 55.0, 'left': 110.0, 'letter': 'F'}
    ],

    [
      {'top': 110.0, 'left': 0.0, 'letter': 'G'},
      {'top': 110.0, 'left': 55.0, 'letter': 'H'},
      {'top': 110.0, 'left': 110.0, 'letter': ''}
    ]
  ];

  int _animation_speed = 500;

  double _box_size = 50.0;
  double _padding = 5.0;
  double _column_count = 3;
  double _game_size = 400.0;
  double _row_count = 3;

  @override
  void initState() {
    super.initState();
  }

  void changePosition(int row, int column) {
    // if user clicked empty square; don't move anything
    if (_boxes[row][column]['letter'] != '') {
      // this is a letter box; determine where the empty box is in the grid (row, column)
      List empty_slot = [];
      for (var r = 0; r < _boxes.length; r++) {
        for (var c = 0; c < _boxes[r].length; c++) {
          if (_boxes[r][c]['letter'] == '') {
            empty_slot = [r, c];
          }
        }
      }

      // empty slot has to be in the same column or row of the clicked box to allow for a move
      if (empty_slot[0] == row || empty_slot[1] == column) {
        // we can move boxes! So determine what direction we should move
        if (empty_slot[0] == row) {
          // we need to move right or left (determine which)
          num boxes_to_move = column - empty_slot[1];

          // int boxes_to_move = row - empty_slot[1];
          if (boxes_to_move < 0) {
            // move boxes left (empty space right)
            boxes_to_move *= -1;

            // move the letters that need moved
            int _slot = 0;
            for (var x = 1; x <= boxes_to_move; x++) {
              _slot = empty_slot[1] - x;
              if (_slot < 0) {
                _slot = _boxes[row].length - 1;
              }
              _boxes[row][_slot]['left'] += (_box_size + _padding);
            }

            // reset the order on this row
            List temp = new List.from(_boxes[row]);

            // move empty slot to clicked location
            _boxes[row][column] = temp[empty_slot[1]];

            // move the letter boxes
            for (int x = 0; x < boxes_to_move; x++) {
              num slot = column + x;
              if (slot >= _boxes[row].length) {
                slot -= _boxes[row].length;
              }
              _boxes[row][slot + 1] = temp[slot.toInt()];
            }

          } else {
            // move the letters that need moved
            int _slot = 0;
            for (var x = 1; x <= boxes_to_move; x++) {
              _slot = empty_slot[1] + x;
              if (_slot > _boxes[row].length) {
                _slot = 0;
              }
              _boxes[row][_slot]['left'] -= (_box_size + _padding);
            }

            // reset the order on this row
            List temp = new List.from(_boxes[row]);

            // move empty slot to clicked location
            _boxes[row][column] = temp[empty_slot[1]];

            // move the letter boxes
            for (int x = 0; x < boxes_to_move; x++) {
              num slot = column - x;
              if (slot < 0) {
                slot -= _boxes[row].length;
              }
              _boxes[row][slot - 1] = temp[slot.toInt()];
            }

          }

        } else {
          // we need to move up or down
          print('move up or down');
        }

        // move all the boxes (and white space) that need moved
      } else {
        print('no move');
      }

    } else {
      print('no move');

    }

    setState(() { });
  }

  List<Widget> _buildBoxes() {
    List<AnimatedPositioned> _tiles = [];
    for (var row = 0; row < _boxes.length; row++) {
      for (var column = 0; column < _boxes[row].length; column++) {
        Color _background_color = Color(0xffFFFFFF);
        if (_boxes[row][column]['letter'] == '') {
          _background_color = Color(0xff000000);
        }
        if (_boxes[row][column]['letter'] != '') {
          _tiles.add(
            AnimatedPositioned(
              top: _boxes[row][column]['top'],
              left: _boxes[row][column]['left'],
              duration: Duration(milliseconds: _animation_speed),
              child: InkWell(
                onTap: () => changePosition(row, column),
                child: Container(
                  alignment: Alignment.center,
                  width: _box_size,
                  height: _box_size,
                  child: Text(_boxes[row][column]['letter'], style: TextStyle(color: Color(0xff000000))),
                  color: _background_color
                )
              )
            )
          );
        }
      }
    }
    return _tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cross Puzzle')
      ),
      body: SizedBox(
        height: _game_size,
        width: _game_size,
        child: Stack(
          children: _buildBoxes()
        )
      )
    );
  }
}