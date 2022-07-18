import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman/path.dart';
import 'package:pacman/pixel.dart';
import 'package:pacman/player.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static int rowNum = 11;

  int numberOfSquares = rowNum * 17;
  int player = rowNum * 15 + 1;
  List<int> barriers = [
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    22,
    24,
    26,
    28,
    30,
    33,
    35,
    37,
    38,
    39,
    41,
    44,
    46,
    52,
    55,
    57,
    59,
    63,
    61,
    66,
    70,
    72,
    77,
    78,
    79,
    80,
    81,
    83,
    84,
    85,
    86,
    87,
    99,
    100,
    101,
    102,
    103,
    105,
    106,
    107,
    108,
    110,
    114,
    116,
    121,
    123,
    125,
    127,
    129,
    134,
    145,
    156,
    132,
    140,
    143,
    147,
    148,
    149,
    151,
    158,
    162,
    154,
    160,
    165,
    175,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    21,
    32,
    43,
    54,
    65,
    76,
    87,
    109,
    120,
    131,
    132,
    142,
    153,
    164
  ];
  List<int> food = [];
  String direction = "right";
  bool preGame = true;
  bool mouthClosed = false;
  int score = 0;
  bool paused = false;
  void restartGame() {
    preGame = false;
    mouthClosed = false;
    direction = "right";
    player = rowNum * 15;
    food.clear();
    getFood();
    score = 0;
    startGame();
  }

  void startGame() {
    if (preGame) {
      preGame = false;
      getFood();
      Duration duration = const Duration(seconds: 2);

      Timer.periodic(duration, (timer) {
        if (food.contains(player)) {
          setState(() {
            food.remove(player);
          });
          score = score + 10;
        }

        switch (direction) {
          case "left":
            moveLeft();
            break;
          case "right":
            moveRight();
            break;
          case "up":
            moveUp();
            break;
          case "down":
            moveDown();
            break;
        }
      });
    }
  }

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (!barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (!barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!barriers.contains(player - rowNum)) {
      setState(() {
        player -= rowNum;
      });
    }
  }

  void moveDown() {
    if (!barriers.contains(player + rowNum)) {
      setState(() {
        player += rowNum;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = "down";
                } else if (details.delta.dy < 0) {
                  direction = "up";
                }
                //        print(direction);
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = "right";
                } else if (details.delta.dx < 0) {
                  direction = "left";
                }
                //    print(direction);
              },
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: numberOfSquares,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowNum),
                itemBuilder: (BuildContext context, int index) {
                  if (player == index) {
                    switch (direction) {
                      case "left":
                        return Transform.rotate(
                          angle: pi,
                          child: const MyPlayer(),
                        );
                      case "right":
                        const MyPlayer();
                        break;
                      case "up":
                        return Transform.rotate(
                          angle: 3 * pi / 2,
                          child: const MyPlayer(),
                        );
                      case "down":
                        return Transform.rotate(
                          angle: pi / 2,
                          child: const MyPlayer(),
                        );
                      default:
                        return const MyPlayer();
                    }
                  } else if (barriers.contains(index)) {
                    return MyPixel(
                      innerColor: Colors.blue[800],
                      outerColor: Colors.blue[900],
                      //     child: Text(index.toString()),
                    );
                  } else if (preGame || food.contains(index)) {
                    return MyPixel(
                      innerColor: Colors.yellow,
                      outerColor: Colors.black,
                    );
                  } else {
                    return MyPath(
                      innerColor: Colors.black,
                      outerColor: Colors.black,
                      //     chilre\\d: Text(index.toString()),
                    );
                  }
                  return const MyPlayer();
                },
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'S C O R E : $score',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: startGame,
                  child: const Text(
                    'P L A Y',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: restartGame,
                  child: const Text(
                    'R E S T A R T',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
