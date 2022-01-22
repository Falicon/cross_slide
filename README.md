# cross_slide

A new Flutter project for the flutter hack dev post challenge.

## Slide Puzzle Idea
  - Pick a 3 to 5 character word (give cross word hint to the user; for the word)

  - Generate a puzzle using letters (answer is either a row or column; shuffle);
    - 3x3, 4x4, or 5x5 depending on word character length
    - two-dimensional array contains locations
    - last slot is white space (for sliding)
    - initial state has row or column correct (and fills in rest of grid with extra letters)
    - sort slides pieces around in random order for X amount of slides (determined by level?)

    - a character in the wrong slot has a white background
    - a character in the right row or column (whichever is the solve direction) but wrong slot will have yellow background
    - a character in the right slot will have a green background

  - Solved puzzle has the word in the right column or row (rest of letters/puzzle can be in any order)

### Game Options
  - How many can you solve (tradditional; work through all puzzles; each level makes it a bit harder)
  - How fast can you solve a puzzle (timed mode)

  - How many words can you build in a given slide puzzle? (would ignore the solve state)

### Dev Resources/Inspiration

Flutter Hack Dev Post

  - https://flutterhack.devpost.com/

Sample Slide Puzzle:

  - https://github.com/VGVentures/slide_puzzle

AnimatedPositioned

  - https://github.com/flutter/samples/blob/master/animations/lib/src/misc/animated_positioned.dart

InkWell

  - https://api.flutter.dev/flutter/material/InkWell-class.html

