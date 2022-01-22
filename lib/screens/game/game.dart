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
  List _boxes = [];
  List _controls = [];

  List _empty_slot = [];

  int _animation_speed = 500;

  double _box_size = 50.0;
  double _padding = 5.0;
  double _column_count = 0;
  double _game_size = 400.0;
  double _row_count = 0;

  @override
  void initState() {
    _buildPuzzle();
    super.initState();
  }

  void _buildPuzzle() {
    // get the solve word
    String _word = 'CAT';

    // set the size of our playing grid
    _column_count = _word.length.toDouble();
    _row_count = _word.length.toDouble();

    // define the initial empty slot (last row; last character)
    _empty_slot = [_row_count - 1, _column_count - 1];

    // pick a random row user needs to solve for (never last row b/c of empty space)
    int _solve_row = new Random().nextInt(_row_count.toInt() - 1);
    double _top = 0.0;
    double _left = 0.0;

    // build our boxes control
    int _id = 0;
    for (int i = 0; i < _row_count; i++) {
      List rec = [];
      if (i == _solve_row) {
        // fill this row with our letters
        _word.runes.forEach((int rune) {
          var character = new String.fromCharCode(rune);
          _id++;
          Map _letter = {
            'top': _top,
            'left': _left,
            'letter': character.toUpperCase(),
            'id': _id.toString()
          };
          rec.add(_letter);
          _left += (_box_size + _padding);
        });
      } else {
        // fill this row with random letters
        for (int j = 0; j < _column_count; j++) {
          Map _letter = {};
          if (i == (_row_count - 1) && j == (_column_count - 1)) {
            // last box in puzzle; should be empty to start
            _letter = {
              'top': _top,
              'left': _left,
              'letter': '',
              'id': ''
            };
          } else {
            // TODO generate a random letter (ideally not in solution)
            String _char = 'W';
            _id++;
            _letter = {
              'top': _top,
              'left': _left,
              'letter': _char,
              'id': _id.toString()
            };
          }
          rec.add(_letter);
          _left += (_box_size + _padding);
        }
      }
      _boxes.add(rec);
      _top += (_box_size + _padding);
      _left = 0.0;
    }

    // build our control list
    for (int i = 0; i < _boxes.length; i++) {
      List _temp = [];
      for (int j = 0; j < _boxes[i].length; j++) {
        _temp.add(_boxes[i][j]['id']);
      }
      _controls.add(_temp);
    }

  }

  void changePosition(String _id) {
    // now get the actual spot this id is currently in
    int row = 0;
    int column = 0;
    for (var i = 0; i < _controls.length; i++) {
      for (var j = 0; j < _controls[i].length; j++) {
        if (_controls[i][j] == _id) {
          row = i;
          column = j;
        }
      }
    }

    // if user clicked that spot that contains the empty square; don't move anything
    if (_controls[row][column] != '') {

      // empty slot has to be in the same column or row of the clicked box to allow for a move
      if (_empty_slot[0] == row || _empty_slot[1] == column) {
        // we can move boxes! So determine what direction we should move
        if (_empty_slot[0] == row) {
          // we need to move right or left (determine which)
          num boxes_to_move = column - _empty_slot[1];

          // update our controls to shift empty space boxes_to_move
          int _space = _controls[row].indexOf('');
          // remove the _space
          _controls[row].remove('');

          if (boxes_to_move < 0) {
            /***** LEFT *****/
            // move boxes left (empty space right)
            boxes_to_move *= -1;
            // inject a new space to _space - boxes_to_move
            _controls[row].insert(_space - boxes_to_move, "");

          } else {
            /***** RIGHT *****/
            // inject a new space to _space - boxes_to_move
            _controls[row].insert(_space + boxes_to_move, "");

          }

        } else {
          // we need to move up or down
          num boxes_to_move = row - _empty_slot[0];

          if (boxes_to_move < 0) {
            /***** DOWN *****/
            // move boxes down (empty space up)
            boxes_to_move *= -1;
            // we need to shift column values down
            Map _shifting_values = {};
            num _slot = 0;
            for (int i = 0; i < _controls.length; i++) {
              if (i >= row && i <= _empty_slot[0]) {
                if (_controls[i][column] == '') {
                  // we need to shif this up to the row clicked
                  _slot = row;
                } else {
                  // we need to shift this down
                  _slot = i + 1;
                  if (_slot >= _controls.length) {
                    _slot -= _controls.length;
                  }
                }
                _shifting_values[_controls[i][column]] = [_slot, column];
              }
            }

            _shifting_values.forEach((k, v) {
              _controls[v[0]][v[1]] = k;
            });

            // now put each shifted value into the proper row

          } else {
            /***** UP *****/
            // we need to shift column values up
            Map _shifting_values = {};
            num _slot = 0;
            for (int i = 0; i < _controls.length; i++) {
              if (i <= row && i >= _empty_slot[0]) {
                if (_controls[i][column] == '') {
                  // we need to shif this down to the row clicked
                  _slot = row;
                } else {
                  // we need to shift this up
                  _slot = i - 1;
                  if (_slot < 0) {
                    _slot = _controls.length - 1;
                  }
                }
                _shifting_values[_controls[i][column]] = [_slot, column];
              }
            }

            _shifting_values.forEach((k, v) {
              _controls[v[0]][v[1]] = k;
            });

          }

        }

        // track where the empty slot moved to
        _empty_slot = [row, column];

        double _top = 0.0;
        double _left = 0.0;
        for (int i = 0; i < _controls.length; i++) {
          for (int j = 0; j < _controls[row].length; j++) {
            for (int x = 0; x < _boxes.length; x++) {
              for (int y = 0; y < _boxes[x].length; y++) {
                if (_boxes[x][y]['id'] == _controls[i][j]) {
                  _boxes[x][y]['top'] = _top;
                  _boxes[x][y]['left'] = _left;
                }
              }
            }
            _left += (_box_size + _padding);
          }
          _top += (_box_size + _padding);
          _left = 0.0;
        }

      } else {
        print('no move');
      }

    } else {
      print('no move');

    }

    // print('#####');
    // print(_boxes[0]);
    // print(_boxes[1]);
    // print(_boxes[2]);
    // print(_empty_slot);
    // print(_controls);
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
                onTap: () => changePosition(_boxes[row][column]['id']),
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