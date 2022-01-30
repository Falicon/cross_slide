import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '/models/config_settings.dart';

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

  bool _log_time = false;

  int _animation_speed = 250;
  int _box_size = 75;
  int _click_count = 0;
  int _column_count = 0;
  int _game_size = 400;
  int _level = 0;
  int _padding = 5;
  int _row_count = 0;
  int _solve_slot = 0;
  int _start = 0;

  String _word = '';
  String _clue = '';
  String _solve_direction = '';

  Map _letter_mappings = {};
  Map<String, dynamic> _words = words;

  // define some colors we'll use throughout the game
  Color _black = Color(0xff000000);
  Color _grey = Color(0xff6c757d);
  Color _green = Color(0xff90EE90);
  Color _white = Color(0xffFFFFFF);
  Color _yellow = Color(0xffffffe0);

  // prepare a timer we'll use to track seconds game is played
  Timer? _timer;

  /****************************************
  INIT STATE
    - Buid our initial puzzle
    - Start the game timer
  ****************************************/
  @override
  void initState() {
    _build_puzzle();
    _log_time = true;
    _start_timer();
    super.initState();
  }

  /****************************************
  DISPOSE
  ****************************************/
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /****************************************
  BUILD PUZZLE
    - Reset some game control variables & state
    - Get a random word at the current level (no more words avail means game is complete)
    - Set the initial position of the empty slot (last row/column combination)
    - Determine the size of the game board and number of boxes this round (use the word length and box + padding sizes)
    - Randomly decide if the solution should be in a row or a column (and which one in the grid)
    - Build a two-dimensional list of box details with initial position, letter, and colors for each box (used for animation around the board)
    - Build our two-dimenional control list (ids for boxes; used to track proper movement around the board)
  ****************************************/
  void _build_puzzle() {
    // make sure to clear out any pre-existing values
    _boxes = [];
    _controls = [];
    _word = '';
    _clue = '';
    List _used_chars = [];

    // determine the current level (for every 5 solved puzzles we move up a level)
    if (_solved.length % 5 == 0) {
      _level++;
    }

    // get the word set we can build puzzles from
    Iterable _word_set = _words.keys;

    List<String> _keys = [];

    // remove the _solved keys (and any words above our current level)
    for (var key in _word_set) {
      if (!_solved.contains(key.toUpperCase()) && _words[key]['level'] == _level) {
        _keys.add(key.toUpperCase());
      }
    }

    if (_keys.length > 0) {
      // pick from the remaining list
      String _random_key = _keys.elementAt(new Random().nextInt(_keys.length));

      // actually assign the word and clue for this round
      _word = _random_key.toUpperCase();
      _clue = _words[_random_key.toLowerCase()]['clue'];

      // calculate the _game_size (game board size)
      _game_size = (_box_size + _padding) * _word.length;

      // set the size of our playing grid
      _column_count = _word.length;
      _row_count = _word.length;

      // define the initial empty slot (last row; last character)
      _empty_slot = [_row_count - 1, _column_count - 1];

      // determine if solution should be across or down (and in what slot)
      int _temp = new Random().nextInt(2);
      if (_temp == 0) {
        // solution will be for ACROSS this round
        _solve_direction = 'across';
        // pick a random row user needs to solve for (remember index lists start at 0)
        _solve_slot = new Random().nextInt(_row_count.toInt() - 1);
        // format our clue to include the row number and Across information
        _clue = 'Across:\n' + (_solve_slot + 1).toString() + '.) ' + _clue;
      } else {
        // solution will be for DOWN this round
        _solve_direction = 'down';
        // pick a random column user needs to solve for (remember index lists start at 0)
        _solve_slot = new Random().nextInt(_column_count.toInt() - 1);
        // format our clue to include the column number and Down information
        _clue = 'Down:\n' + (_solve_slot + 1).toString() + '.) ' + _clue;
      }
      _clue += '\n';

      // initialize our spots for the grid
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
              'background': _white,
              'foreground': _grey
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
                'background': _black,
                'foreground': _black
              };
              _letter_mappings[''] = '';
            } else {
              // generate a random letter (ensure that letters from solution aren't repeated)
              bool _char_avail = false;
              String _char = '';
              while (!_char_avail) {
                num _char_code = 65 + Random().nextInt(91 - 65);
                _char = new String.fromCharCode(_char_code.toInt());
                if (!_word.contains(_char) && !_used_chars.contains(_char)) {
                  _char_avail = true;
                  _used_chars.add(_char);
                }
              }
              _id++;
              _letter = {
                'top': _top,
                'left': _left,
                'letter': _char.toUpperCase(),
                'id': _id.toString(),
                'background': _white,
                'foreground': _grey
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
    - Get the current location of the box the user clicked on
    - Ignore click if it's the empty box
    - Ensure that the box clicked on is in a row or column with the empty space (ignore other clicks)
    - Determine direction the box(es) need to move (left, right, up, or down)
    - Determine how many boxes need to be moved
    - Update our controls list with the new locations for each box
    - Update the location of the empty slot
    - Update the locations for each box in our animated list (triggers actual animation/visual movement)
  ****************************************/
  void _change_position(String _id) {
    // we know the id of the box the user clicked on, get the actual spot this id is currently in (within our controls list)
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
            int _slot = 0;
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
            int _slot = 0;
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
    - Use our controls list to build words from rows or columns (depends on _solve_direction value)
    - Check if any letters from the solution are in the right spot (or at a min in the right row/column)
    - Turn boxes to correct colors (green, yellow, or white)
    - If there is a match for the solution in the right spot
      - pause the timer
      - show an AlertDialog that puzzle was solved (clicking next will start the next round)
  ****************************************/
  void _check_solution() {
    bool _correct = false;
    List _greens = [];
    List _yellows = [];

    if (_solve_direction == 'across') {

      // check if the proper letters are in the correct slots within this row
      // build a word from the characters in the solve slots
      String _check = '';
      for (var i = 0; i < _controls.length; i++) {
        _check += _letter_mappings[_controls[_solve_slot][i]];
        // check if right letter; right spot
        if (_word[i] == _letter_mappings[_controls[_solve_slot][i]]) {
          _greens.add(_controls[_solve_slot][i]);
        }
        // check if right letter; wrong spot
        if (_word.contains(_letter_mappings[_controls[_solve_slot][i]])) {
          _yellows.add(_controls[_solve_slot][i]);
        }
      }
      // check that word against what we are looking for
      if (_check == _word) {
        _correct = true;
        _solved.add(_word);
      }

    } else {

      // check if the proper letters are in the correct slots within this column
      // build a word from the characters in the solve slots
      String _check = '';
      for (var i = 0; i < _controls.length; i++) {
        _check += _letter_mappings[_controls[i][_solve_slot]];
        // check if right letter; right spot
        if (_word[i] == _letter_mappings[_controls[i][_solve_slot]]) {
          _greens.add(_controls[i][_solve_slot]);
        }
        // check if right letter; wrong spot
        if (_word.contains(_letter_mappings[_controls[i][_solve_slot]])) {
          _yellows.add(_controls[i][_solve_slot]);
        }
      }
      // check that word against what we are looking for
      if (_check == _word) {
        _correct = true;
        _solved.add(_word);
      }

    }

    // turn box colors as needed
    for (var i = 0; i < _controls.length; i++) {
      for (var j = 0; j < _controls[i].length; j++) {
        for (var x = 0; x < _boxes.length; x++) {
          for (var y = 0; y < _boxes[x].length; y++) {
            if (_boxes[x][y]['id'] == _controls[i][j] && _greens.contains(_controls[i][j])) {
              _boxes[x][y]['background'] = _green;
              _boxes[x][y]['foreground'] = _grey;
            } else if (_boxes[x][y]['id'] == _controls[i][j] && _yellows.contains(_controls[i][j])) {
              _boxes[x][y]['background'] = _yellow;
              _boxes[x][y]['foreground'] = _grey;
            } else if (_boxes[x][y]['id'] == _controls[i][j]) {
              _boxes[x][y]['background'] = _white;
              _boxes[x][y]['foreground'] = _grey;
            }
          }
        }
      }
    }

    if (_correct) {
      _log_time = false;
      // show the popup before moving to next round
      String _solve_string = 'You have solved ' + _solved.length.toString() + ' puzzle';
      if (_solved.length != 1) {
        _solve_string += 's';
      }
      _solve_string += ' in this game!\n';
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'PUZZLE SOLVED!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _grey
            )
          ),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _solve_string,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _grey
                      )
                    ),
                  ]
                ),
              )
            ]
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                // start a new round (with a new puzzle)
                _build_puzzle();
                _log_time = true;
                setState(() {});
              },
              textColor: _grey,
              child: const Text('Next'),
            ),
          ],
        )
      );
    }
  }

  /****************************************
  SHUFFLE BOXES
    - Mimic random-ish clicks to mix up the puzzle
  ****************************************/
  void _shuffle_boxes() {
    for (var x = 0; x < 50; x++) {
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
  START TIMER
    - Start a timer for tracking seconds game is played
    - Use boolean to determine if time should be counting or not
  ****************************************/
  void _start_timer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      if (_log_time) {
        _start++;
        setState(() {});
      }
    });
  }

  /****************************************
  BUILD BOXES
    - Build a widget list of AnimatedPosition boxes (what the user will actually see)
    - If our _boxes list is empty, show a "game complete" message instead
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
                child: Container(
                  alignment: Alignment.center,
                  width: _box_size.toDouble(),
                  height: _box_size.toDouble(),
                  child: Text(
                    _boxes[_row][_column]['letter'],
                    style: TextStyle(color: _boxes[_row][_column]['foreground'])
                  ),
                  // color: _boxes[_row][_column]['background'],
                  decoration: BoxDecoration(
                    border: Border.all(color: _grey),
                    borderRadius: BorderRadius.circular(10),
                    color: _boxes[_row][_column]['background']
                  ),
                ),
                onTap: () {
                  // increment our click counter
                  _click_count++;
                  // move the box to the proper spot
                  _change_position(_boxes[_row][_column]['id']);
                  // check if this solves the puzzle
                  _check_solution();
                  // re-redner the view
                  setState(() { });
                }
              )
            )
          );
        }
      }
    }

    if (_boxes.length == 0) {
      // no puzzle to load; show the thank you message
      _log_time = false;
      return [
        Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                width: 3,
                color: _grey,
                style: BorderStyle.solid
              )
            ),
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "CONGRATULATIONS THE GAME IS COMPLETE!\n\nYou have solved all the puzzles available in this demo version of Cross Slide.\n\nIf you like what you've seen, please let @falicon know on Twitter!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _grey
                        )
                      ),
                    ]
                  ),
                ),
              ]
            )
          )
        )
      ];
    } else {
      return _tiles;
    }

  }

  /****************************************
  BUILD GUI
  ****************************************/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _white,
        elevation: 0,
        centerTitle: true,
        title: Text('CROSSWORD SLIDE PUZZLE', style: TextStyle(color: _grey)),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: _grey),
            iconSize: 40,
            onPressed: () async {
              Navigator.pushNamed(context, '/about');
            }
          )
        ]
      ),
      body: ListView(
        children: [
          // Slide Puzzle Section
          Container(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: _game_size.toDouble(),
              width: _game_size.toDouble(),
              child: Stack(
                children: _buildBoxes()
              )
            )
          ),
          // Clue Section
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
            child: Text(
              _clue,
              style: TextStyle(
                color: _grey,
                fontWeight: FontWeight.bold,
              )
            )
          ),
          // Game Stats & How To Play Section
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 15.0),
            child: Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              decoration: BoxDecoration(
                color: _yellow,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: _grey)
              ),
              child: Column(
                children: [
                  // Game Stats
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "LEVEL: " + _level.toString() + "    SOLVED: " + _solved.length.toString() + "    CLICKS: " + _click_count.toString() + "\n\nSECONDS PLAYED: " + _start.toString() + "\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _grey
                          )
                        ),
                      ]
                    ),
                    textAlign: TextAlign.center
                  ),
                  // How to Play
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "HOW TO PLAY:\n\n 1. Tap or Click a letter to slide boxes around the puzzle.\n\n2. Spell the word that is the answer to the clue given.\n\n3. Make sure it's in the right column or row as defined by the clue.\n\n4. Difficulty increases with very 5 puzzles you solve.\n\nNote: Green boxes are letters in the right spot, yellow boxes are letters in the answer, but in the wrong spot.\n\n",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _grey
                          )
                        )
                      ]
                    ),
                  ),
                ]
              )
            )
          )
        ]
      )
    );
  }
}