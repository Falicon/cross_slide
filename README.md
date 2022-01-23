# cross_slide

A Flutter project for the flutter hack dev post challenge [ https://flutterhack.devpost.com/ ].

## Slide Puzzle Idea
  - Pick a 3+ character word 
    - give cross word hint to the user
    - randomly determine if it should be solved across (right to left) or down (top to bottom)
    - randomly determine which row or column the solution should be in

  - Generate a puzzle using letters (answer is either a row or column; shuffle);
    - YxY grid depending on word character length
    - two-dimensional array contains locations
    - two-dimensional array controls animations
    - last slot is white space (for sliding)

    - initial state has row or column correct (and fills in rest of grid with extra letters)
    - sort slides pieces around in random order for X amount of slides

    - a character in the wrong slot has a white background
    - a character in the right row or column (whichever is the solve direction) but wrong slot will have yellow background
    - a character in the right slot will have a green background

  - Solved puzzle has the word in the right column or row
    - rest of letters/puzzle can be in any order

### Demo & Code Walkthrough

  - https://www.youtube.com/watch?v=3W1dEKeMsTY

### How To Install & Run

1. Install Flutter [ https://flutter.dev/ ]
2. Clone this repo to your local system
2. From the root folder of this project
  A. for the web version simply run "flutter run"
  B. for a mobilve version, launch a mobile emulator, then "flutter run"

### Game Options
  - How many can you solve
    - tradditional
    - work through all puzzles
    - each level makes it a bit harder

  - How fast can you solve a puzzle (timed mode)

### TODO
  - number the grid (for across/down help)
  - play sound on click (during animation)

### Dev Resources/Inspiration

Flutter Hack Dev Post

  - https://flutterhack.devpost.com/

Sample Slide Puzzle:

  - https://github.com/VGVentures/slide_puzzle

Wordle

  - https://www.powerlanguage.co.uk/wordle/

AnimatedPositioned

  - https://github.com/flutter/samples/blob/master/animations/lib/src/misc/animated_positioned.dart

InkWell

  - https://api.flutter.dev/flutter/material/InkWell-class.html

