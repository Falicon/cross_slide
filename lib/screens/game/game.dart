import 'dart:math';

import 'package:flutter/material.dart';

import 'package:cross_slide/models/config_settings.dart';

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
  List _solved = [];

  int _animation_speed = 250;
  int _solve_slot = 0;

  double _box_size = 50.0;
  double _padding = 5.0;
  double _column_count = 0;
  double _game_size = 400.0;
  double _row_count = 0;

  String _word = '';
  String _clue = '';

  Map _letter_mappings = {};
  Map<String, dynamic> _words = words;

  @override
  void initState() {
    _build_puzzle();
    super.initState();
  }

  /****************************************
  BUILD PUZZLE
  ****************************************/
  void _build_puzzle() {
    // get the solve word
    Iterable _word_set = _words.keys;

    List<String> _keys = [];

    // remove the _solved keys
    for (var key in _word_set) {
      if (!_solved.contains(key.toUpperCase())) {
        _keys.add(key.toUpperCase());
      }
    }

    if (_keys.length > 0) {
      // pick from the remaining list
      String _random_key = _keys.elementAt(new Random().nextInt(_keys.length));

      _word = _random_key.toUpperCase();
      _clue = _words[_random_key.toLowerCase()];

      // set the size of our playing grid
      _column_count = _word.length.toDouble();
      _row_count = _word.length.toDouble();

      // define the initial empty slot (last row; last character)
      _empty_slot = [_row_count - 1, _column_count - 1];

      // pick a random row user needs to solve for (never last row b/c of empty space)
      _solve_slot = new Random().nextInt(_row_count.toInt() - 1);
      double _top = 0.0;
      double _left = 0.0;

      // build our boxes control
      int _id = 0;
      for (int i = 0; i < _row_count; i++) {
        List _rec = [];
        if (i == _solve_slot) {
          // fill this row with our letters
          _word.runes.forEach((int rune) {
            var _character = new String.fromCharCode(rune);
            _id++;
            Map _letter = {
              'top': _top,
              'left': _left,
              'letter': _character.toUpperCase(),
              'id': _id.toString(),
              'background': Color(0xffFFFFFF),
              'foreground': Color(0xff000000)
            };
            _letter_mappings[_id.toString()] = _character.toUpperCase();
            _rec.add(_letter);
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
                'id': '',
                'background': Color(0xff000000),
                'foreground': Color(0xff000000)
              };
              _letter_mappings[''] = '';
            } else {
              // TODO generate a random letter (ideally not in solution)
              num _char_code = 65 + Random().nextInt(91 - 65);
              var _char = new String.fromCharCode(_char_code.toInt());
              _id++;
              _letter = {
                'top': _top,
                'left': _left,
                'letter': _char.toUpperCase(),
                'id': _id.toString(),
                'background': Color(0xffFFFFFF),
                'foreground': Color(0xff000000)
              };
              _letter_mappings[_id.toString()] = _char.toUpperCase();
            }
            _rec.add(_letter);
            _left += (_box_size + _padding);
          }
        }
        _boxes.add(_rec);
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

      // finally shuffle the board
      _shuffle_boxes();
    }

  }

  /****************************************
  CHANGE POSITION
  ****************************************/
  void _change_position(String _id) {
    // now get the actual spot this id is currently in
    int _row = 0;
    int _column = 0;
    for (var i = 0; i < _controls.length; i++) {
      for (var j = 0; j < _controls[i].length; j++) {
        if (_controls[i][j] == _id) {
          _row = i;
          _column = j;
        }
      }
    }

    // if user clicked that spot that contains the empty square; don't move anything
    if (_controls[_row][_column] != '') {
      // empty slot has to be in the same _column or _row of the clicked box to allow for a move
      if (_empty_slot[0] == _row || _empty_slot[1] == _column) {
        // we can move boxes! So determine what direction we should move
        if (_empty_slot[0] == _row) {
          // we need to move right or left (determine which)
          num _boxes_to_move = _column - _empty_slot[1];

          // update our controls to shift empty space _boxes_to_move
          int _space = _controls[_row].indexOf('');

          // remove the _space
          _controls[_row].remove('');

          if (_boxes_to_move < 0) {
            // move boxes left (empty space right)
            _boxes_to_move *= -1;

            // inject a new space to _space - _boxes_to_move
            _controls[_row].insert(_space - _boxes_to_move, "");
          } else {
            // move boxes right (empty space left)
            // inject a new space to _space - _boxes_to_move
            _controls[_row].insert(_space + _boxes_to_move, "");
          }
        } else {
          // we need to move up or down
          num _boxes_to_move = _row - _empty_slot[0];

          // prepare the holder for shifting values
          Map _shifting_values = {};

          if (_boxes_to_move < 0) {
            // move boxes down (empty space up)
            _boxes_to_move *= -1;
            // we need to shift _column values down
            num _slot = 0;
            for (int i = 0; i < _controls.length; i++) {
              if (i >= _row && i <= _empty_slot[0]) {
                if (_controls[i][_column] == '') {
                  // we need to shif this up to the _row clicked
                  _slot = _row;
                } else {
                  // we need to shift this down
                  _slot = i + 1;
                  if (_slot >= _controls.length) {
                    _slot -= _controls.length;
                  }
                }
                _shifting_values[_controls[i][_column]] = [_slot, _column];
              }
            }
          } else {
            // we need to shift _column values up
            num _slot = 0;
            for (int i = 0; i < _controls.length; i++) {
              if (i <= _row && i >= _empty_slot[0]) {
                if (_controls[i][_column] == '') {
                  // we need to shif this down to the _row clicked
                  _slot = _row;
                } else {
                  // we need to shift this up
                  _slot = i - 1;
                  if (_slot < 0) {
                    _slot = _controls.length - 1;
                  }
                }
                _shifting_values[_controls[i][_column]] = [_slot, _column];
              }
            }
          }
          // now put each shifted value into the proper spot in _controls
          _shifting_values.forEach((k, v) {
            _controls[v[0]][v[1]] = k;
          });
        }

        // track where the empty slot moved to
        _empty_slot = [_row, _column];

        // actually animate the box movements
        double _top = 0.0;
        double _left = 0.0;
        for (int i = 0; i < _controls.length; i++) {
          for (int j = 0; j < _controls[_row].length; j++) {
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
      }
    }
  }

  /****************************************
  CHECK SOLUTION
  TODO: check that solution is in the right row
  ****************************************/
  void _check_solution() {
    // check if the proper letters are in the correct slots
    for (var i = 0; i < _controls.length; i++) {
      String _check = '';
      for (var j = 0; j < _controls[i].length; j++) {
        _check += _letter_mappings[_controls[i][j]];
      }
      if (_check == _word) {
        _solved.add(_word);
        // print('PUZZLED SOLVED!');
        // turn boxes in this row to green
        for (var j = 0; j < _controls[i].length; j++) {
          for (var x = 0; x < _boxes.length; x++) {
            for (var y = 0; y < _boxes[x].length; y++) {
              if (_boxes[x][y]['id'] == _controls[i][j]) {
                _boxes[x][y]['background'] = Colors.green;
                _boxes[x][y]['foreground'] = Colors.white;
              }
            }
          }
        }
      }
    }
  }

  /****************************************
  SHUFFLE BOXES
  TODO: potentially shuffle depth based on the level
  ****************************************/
  void _shuffle_boxes() {
    for (var x = 0; x < 100; x++) {
      // randomly decide between clicking a row or a column
      int _choice = new Random().nextInt(2);
      int _row = _empty_slot[0];
      int _column = _empty_slot[1];
      if (_choice == 0) {
        // click a random column (that contains the _empty_slot)
        _row = new Random().nextInt(_row_count.toInt());
        if (_row == _empty_slot[0]) {
          while (_row == _empty_slot[0]) {
            _row = new Random().nextInt(_row_count.toInt());
          }
        }
      } else {
        // click a random row (that contains the _empty_slot)
        _column = new Random().nextInt(_column_count.toInt());
        if (_column == _empty_slot[1]) {
          while (_column == _empty_slot[1]) {
            _column = new Random().nextInt(_column_count.toInt());
          }
        }
      }
      String _id = _boxes[_row][_column]['id'];
      _change_position(_id);
    }
  }

  /****************************************
  BUILD BOXES
  ****************************************/
  List<Widget> _buildBoxes() {
    List<AnimatedPositioned> _tiles = [];
    for (var _row = 0; _row < _boxes.length; _row++) {
      for (var _column = 0; _column < _boxes[_row].length; _column++) {
        if (_boxes[_row][_column]['letter'] != '') {
          _tiles.add(
            AnimatedPositioned(
              top: _boxes[_row][_column]['top'],
              left: _boxes[_row][_column]['left'],
              duration: Duration(milliseconds: _animation_speed),
              child: InkWell(
                onTap: () {
                  // move the box to the proper spot
                  _change_position(_boxes[_row][_column]['id']);
                  // check if this solves the puzzle
                  _check_solution();
                  // re-redner the view
                  setState(() { });
                },
                child: Container(
                  alignment: Alignment.center,
                  width: _box_size,
                  height: _box_size,
                  child: Text(
                    _boxes[_row][_column]['letter'],
                    style: TextStyle(color: _boxes[_row][_column]['foreground'])
                  ),
                  color: _boxes[_row][_column]['background']
                )
              )
            )
          );
        }
      }
    }
    return _tiles;
  }

  /****************************************
  BUILD GUI
  ****************************************/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cross Puzzle')
      ),
      body: Column(
        children: [
          Text(
            _clue,
            style: TextStyle(
              color: Color(0xffFFFFFF),
              fontWeight: FontWeight.bold,
              fontSize: 25
            )
          ),
          SizedBox(
            height: _game_size,
            width: _game_size,
            child: Stack(
              children: _buildBoxes()
            )
          )
        ]
      )
    );
  }
}