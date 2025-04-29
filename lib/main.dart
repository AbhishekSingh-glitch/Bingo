import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class Data {
  // Variables
  List bingoMap = [], lineColor = [], lineNumber = [], hrz = [], vrt = [];

  var bingo = '', bingoCount = 0, rtd = 0, lfd = 0;
  int step = 0, ln = 0;

  Data() {
    bingoMap = generateUniqueRandomNumbers(25, 1, 25);
    lineColor = List.filled(25, Colors.transparent);
    lineNumber = List.filled(12, 0);
    hrz = List.filled(5, 0);
    vrt = List.filled(5, 0);
    bingo = '';
    bingoCount = 0;
    rtd = 0;
    lfd = 0;
  }

  // backend functions

  List<int> generateUniqueRandomNumbers(int count, int min, int max) {
    if (count > (max - min + 1)) {
      throw Exception('Range too small for unique numbers');
    }

    Random random = Random();
    Set<int> uniqueNumbers = {};

    while (uniqueNumbers.length < count) {
      uniqueNumbers.add(random.nextInt(max - min + 1) + min);
    }

    return uniqueNumbers.toList();
  }

  void assignBingo() {
    switch (bingoCount) {
      case 0:
        bingo = 'B';
        break;
      case 1:
        bingo = 'BI';
        break;
      case 2:
        bingo = 'BIN';
        break;
      case 3:
        bingo = 'BING';
        break;
      case 4:
        bingo = 'BINGO';
        break;
      default:
        break;
    }
  }

  int assignAt(number, Color? clr) {
    for (int i = 0; i < 25; i++) {
      if (bingoMap[i] == number) {
        lineColor[i] = clr;
        return i;
      }
    }
    return 0;
  }

  void lineCheck(int lineIdx, int side, int start, int end, int plus) {
    for (int i = start; i < end; i += plus) {
      if (lineColor[i] != Colors.transparent) {
        side++;
      }
    }

    if (side == 5 && lineNumber[lineIdx] == 0) {
      assignBingo();
      bingoCount++;
      lineNumber[lineIdx] = 1;
    }

    side = 0;
  }

  void check(int i) {
    int row = i ~/ 5;
    int col = i % 5;

    if (lineNumber.length > 11 && hrz.length > row && vrt.length > col) {
      if (i % 4 == 0 || i % 6 == 0) {
        lineCheck(0, rtd, 4, 21, 4);
        lineCheck(1, lfd, 0, 25, 6);
      }

      lineCheck(2 + row, hrz[row], (row * 5), ((row * 5) + 5), 1);
      lineCheck(7 + col, vrt[col], col, (col + 21), 5);
    }
  }

  bool uDone() {
    return (bingoCount >= 5);
  }

  // Levels
  setLevel(int level, int number) {
    switch (level) {
      case 1: // Easy
        return easy();

      case 2: // medium
        return medium();

      case 3: // Hard
        return hard();

      case 4:
        return expert();

      default:
        break;
    }
    return 0;
  }

  easy() {
    int index;
    List temp = [];

    for (int i = 0; i < 25; i++) {
      if (lineColor[i] == Colors.transparent) {
        temp.add(i);
      }
    }

    index = temp[Random().nextInt(temp.length)];
    return bingoMap[index];
  }

  medium() {
    for (int i = 0; i < 5; i++) {
      if (lineColor[i] != Colors.transparent) {
        for (int j = (i + 5); j < (i + 22); j += 5) {
          if (lineColor[j] == Colors.transparent) {
            return bingoMap[j];
          }
        }
      } else {
        return bingoMap[i];
      }
    }
  }

  int hard() {
    // Step 1: Check all possible lines
    List<List<int>> lines = [
      // Horizontal lines
      [0, 1, 2, 3, 4],
      [5, 6, 7, 8, 9],
      [10, 11, 12, 13, 14],
      [15, 16, 17, 18, 19],
      [20, 21, 22, 23, 24],

      // Vertical lines
      [0, 5, 10, 15, 20],
      [1, 6, 11, 16, 21],
      [2, 7, 12, 17, 22],
      [3, 8, 13, 18, 23],
      [4, 9, 14, 19, 24],

      // Diagonals
      [0, 6, 12, 18, 24],
      [4, 8, 12, 16, 20],
    ];

    // Priority: line with 4 marked and 1 transparent
    for (var line in lines) {
      int marked = 0;
      int emptyIndex = -1;

      for (var idx in line) {
        if (lineColor[idx] != Colors.transparent) {
          marked++;
        } else {
          emptyIndex = idx;
        }
      }

      if (marked == 4 && emptyIndex != -1) {
        return bingoMap[emptyIndex];
      }
    }

    // Step 2: Pick from a line with 3 marks
    for (var line in lines) {
      int marked = 0;
      List<int> unmarked = [];

      for (var idx in line) {
        if (lineColor[idx] != Colors.transparent) {
          marked++;
        } else {
          unmarked.add(idx);
        }
      }

      if (marked == 3 && unmarked.isNotEmpty) {
        return bingoMap[unmarked.first];
      }
    }

    // Step 3: Fallback to random transparent number
    List<int> options = [];
    for (int i = 0; i < 25; i++) {
      if (lineColor[i] == Colors.transparent) {
        options.add(i);
      }
    }

    if (options.isNotEmpty) {
      return bingoMap[options[Random().nextInt(options.length)]];
    }

    // If no transparent found (shouldn't happen), return -1
    return -1;
  }

  int expert() {
    List<List<int>> lines = [
      // Horizontal
      [0, 1, 2, 3, 4],
      [5, 6, 7, 8, 9],
      [10, 11, 12, 13, 14],
      [15, 16, 17, 18, 19],
      [20, 21, 22, 23, 24],
      // Vertical
      [0, 5, 10, 15, 20],
      [1, 6, 11, 16, 21],
      [2, 7, 12, 17, 22],
      [3, 8, 13, 18, 23],
      [4, 9, 14, 19, 24],
      // Diagonals
      [0, 6, 12, 18, 24],
      [4, 8, 12, 16, 20],
    ];

    Color myColor = Colors.red;
    Color oppColor = Colors.blue;

    // Step 1: Win if possible
    for (var line in lines) {
      int myMarks = 0;
      int emptyIdx = -1;

      for (var idx in line) {
        if (lineColor[idx] == myColor) {
          myMarks++;
        } else if (lineColor[idx] == Colors.transparent) {
          emptyIdx = idx;
        }
      }

      if (myMarks == 4 && emptyIdx != -1) {
        return bingoMap[emptyIdx];
      }
    }

    // Step 2: Block opponent if they are about to win
    for (var line in lines) {
      int oppMarks = 0;
      int emptyIdx = -1;

      for (var idx in line) {
        if (lineColor[idx] == oppColor) {
          oppMarks++;
        } else if (lineColor[idx] == Colors.transparent) {
          emptyIdx = idx;
        }
      }

      if (oppMarks == 4 && emptyIdx != -1) {
        return bingoMap[emptyIdx];
      }
    }

    // Step 3: Advance own line with 3 marks
    for (var line in lines) {
      int myMarks = 0;
      List<int> emptyList = [];

      for (var idx in line) {
        if (lineColor[idx] == myColor) {
          myMarks++;
        } else if (lineColor[idx] == Colors.transparent) {
          emptyList.add(idx);
        }
      }

      if (myMarks == 3 && emptyList.isNotEmpty) {
        return bingoMap[emptyList.first];
      }
    }

    // Step 4: Pick any safe move
    List<int> options = [];
    for (int i = 0; i < 25; i++) {
      if (lineColor[i] == Colors.transparent) {
        options.add(i);
      }
    }

    if (options.isNotEmpty) {
      return bingoMap[options[Random().nextInt(options.length)]];
    }

    return -1; // No move possible
  }
}

int opponent = 2, fill = 2, level = 2; // Easy   Medium   Hard

Color myBackground = Color.fromRGBO(0, 6, 21, 1.0);
Color textColor = Colors.white;
Data user = Data();
Data? comp = Data();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

// Animation classes
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: AnimatedHome());
  }
}

class AnimatedHome extends StatefulWidget {
  const AnimatedHome({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedHomeState();
  }
}

class _AnimatedHomeState extends State<AnimatedHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int numberOfBlocks = 20;
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    // Auto navigate after 1 minute
    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => BingoMap(),
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> generateBlocks(BuildContext context) {
    return List.generate(numberOfBlocks, (index) {
      double top = random.nextDouble() * MediaQuery.of(context).size.height;
      double left = random.nextDouble() * MediaQuery.of(context).size.width;
      double size = random.nextDouble() * 40 + 10;

      return Positioned(top: top, left: left, child: AnimatedBlock(size: size));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ...generateBlocks(context),
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => BingoMap(),
                      transitionDuration: Duration(milliseconds: 300),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                child: Text('Bingo', style: TextStyle(fontSize: 100)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBlock extends StatefulWidget {
  final double size;

  const AnimatedBlock({super.key, required this.size});

  @override
  State<StatefulWidget> createState() {
    return _AnimatedBlockState();
  }
}

class _AnimatedBlockState extends State<AnimatedBlock>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat(reverse: true);

    _scale = Tween(begin: 0.5, end: 1.2).animate(_controller);
    _opacity = Tween(begin: 0.2, end: 0.8).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

class FillType extends StatefulWidget {
  const FillType({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FillTypeState();
  }
}

class _FillTypeState extends State<FillType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBackground,
      body: Center(
        child: Stack(
          children: [
            Center(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: user.lineColor.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    color: Color.fromRGBO(255, 255, 255, 0.09019607843137255),
                    child: Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          '${user.bingoMap[index]}',
                          style: TextStyle(fontSize: 30, color: textColor),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment(-0.6, -0.8),
              child: Card(
                color: Colors.red,
                child: TextButton(
                  onPressed: () {
                    user = Data();
                    for (int i = 0; i < user.lineColor.length; i++) {
                      user.bingoMap[i] = i + 1;
                    }
                    setState(() {});
                  },
                  child: Text(
                    'Fill increasing',
                    style: TextStyle(color: textColor, fontSize: 15),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.6, -0.8),
              child: Card(
                color: Colors.red,
                child: TextButton(
                  onPressed: () {
                    user = Data();
                    for (int i = user.lineColor.length - 1; i >= 0; i--) {
                      user.bingoMap[24 - i] = i + 1;
                    }
                    setState(() {});
                  },
                  child: Text(
                    'Fill decreasing',
                    style: TextStyle(color: textColor, fontSize: 15),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(-0.6, 0.8),
              child: Card(
                color: Colors.red,
                child: TextButton(
                  onPressed: () {
                    for (int i = 0; i < user.lineColor.length; i++) {
                      user.bingoMap[i] = 0;
                    }
                    setState(() {});
                  },
                  child: Text(
                    'Clear',
                    style: TextStyle(color: textColor, fontSize: 15),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.6, 0.8),
              child: Card(
                color: Colors.red,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => BingoMap(),
                        transitionDuration: Duration(milliseconds: 300),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    'Set',
                    style: TextStyle(color: textColor, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BingoMap extends StatefulWidget {
  const BingoMap({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BingoMapState();
  }
}

class _BingoMapState extends State<BingoMap> {
  int randomNumberGiver() {
    int randomIndex = 0;
    List<int> whiteIndex = [];

    for (int i = 0; i < comp!.lineColor.length; i++) {
      if (comp!.lineColor[i] == Colors.transparent) {
        whiteIndex.add(i);
      }
    }
    if (whiteIndex.isNotEmpty) {
      randomIndex = whiteIndex[Random().nextInt(whiteIndex.length)];
    }

    return randomIndex;
  }

  showMessages(BuildContext context, who, action, till) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(who, textAlign: TextAlign.center)),
        action: SnackBarAction(
          label: action,
          onPressed: () {
            if (action == 'Play Again') {
              setState(() {
                user = Data();
                comp = Data();
              });
            }
          },
        ),
        duration: Duration(seconds: till),
      ),
    );
  }

  changed(newOpponent, newLevel) {
    user = Data();
    opponent = newOpponent;
    comp = (opponent == 2) ? Data() : null;
    level = newLevel;
    setState(() {});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // final h = size.height;
    final w = size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: myBackground,
          appBar: AppBar(
            title: Center(child: Text("BINGO")),
            bottom: TabBar(tabs: [Tab(text: 'Me'), Tab(text: 'Opponent')]),
          ),

          body: TabBarView(
            children: [
              // my
              Stack(
                children: [
                  // bingo block
                  Center(
                    child: SizedBox(
                      width: w * 0.95,
                      child: Stack(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            itemCount: 25,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color:
                                    (user.lineColor[index] == Colors.transparent)? Color.fromRGBO(255, 255, 255, 0.09019607843137255) : user.lineColor[index],
                                child: Center(
                                  child: TextButton(
                                    onPressed: () async {
                                      // Checks if the tapped index is tapped before or not
                                      if (user.lineColor[index] !=
                                          Colors.transparent) {
                                        showMessages(
                                          context,
                                          (user.lineColor[index] == Colors.red)
                                              ? 'Number is Used by you'
                                              : 'Number is Used by computer', '', 5,
                                        );
                                        return;
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).clearSnackBars();
                                      }

                                      if (user.uDone() && comp!.uDone()) {
                                        showMessages(
                                          context, 'The BINGO is completed With DRAW', 'Play Again', 5,
                                        );
                                        return;
                                      } else if (user.uDone()) {
                                        showMessages(context, 'The BINGO is completed YOU WON', 'Play Again', 5,
                                        );
                                        return;
                                      } else if (comp != null &&
                                          comp!.uDone()) {
                                        showMessages(context, 'The BINGO is completed COMPUTER WON', 'Play Again', 5,
                                        );
                                        return;
                                      }
                                      setState(() {});

                                      //User
                                      int number = user.bingoMap[index];

                                      user.lineColor[index] = Colors.red;

                                      int indexOfOpponent = 0;

                                      if (comp != null) {
                                        indexOfOpponent = comp!.assignAt(
                                          number,
                                          Colors.red,
                                        );
                                      }

                                      user.check(index);

                                      if (comp != null) {
                                        comp!.check(indexOfOpponent);
                                      }

                                      await Future.delayed(
                                        Duration(milliseconds: 100),
                                      );
                                      //-----------------------------Computer-----------------------------------------------------------------

                                      if (comp != null) {
                                        int randomNumber = comp!.setLevel(
                                          level,
                                          number,
                                        );

                                        int indexOfPc = 0;
                                        for (int i = 0; i < 25; i++) {
                                          if (comp!.bingoMap[i] ==
                                              randomNumber) {
                                            indexOfPc = i;
                                          }
                                        }
                                        comp!.lineColor[indexOfPc] =
                                            Colors.blue;

                                        indexOfOpponent = user.assignAt(
                                          comp!.bingoMap[indexOfPc],
                                          Colors.blue,
                                        );

                                        comp!.check(indexOfPc);
                                        user.check(indexOfOpponent);

                                        if (user.uDone() && comp!.uDone()) {
                                          showMessages(context, 'The BINGO is completed With DRAW', 'Play Again', 5,
                                          );
                                        } else if (user.uDone()) {
                                          showMessages(context, 'The BINGO is completed YOU WON', 'Play Again', 5,
                                          );
                                        } else if (comp!.uDone()) {
                                          showMessages(context, 'The BINGO is completed COMPUTER WON', 'Play Again', 5,);
                                        }
                                      }

                                      setState(() {});
                                    },
                                    child: Text(
                                      '${user.bingoMap[index]}',
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  //opponent and level
                  Align(
                    alignment: Alignment(-0.8, -0.8),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 18, color: Colors.black),
                        children: [
                          TextSpan(
                            text:
                                (opponent == 1) ? 'Vs Human' : 'Vs Computer\n',
                            style: TextStyle(fontSize: 30, color: textColor),
                          ),
                          TextSpan(
                            text:
                                (level == 1)
                                    ? '   Easy'
                                    : (level == 2)
                                    ? '   Medium'
                                    : (level == 3)
                                    ? '   Hard'
                                    : (level == 4)
                                    ? '   Expert 🤖'
                                    : '',
                            style: TextStyle(
                              color:
                                  (level == 1)
                                      ? Colors.green
                                      : (level == 2)
                                      ? Colors.orange
                                      : (level == 3)
                                      ? Colors.red
                                      : (level == 4)
                                      ? Colors.red
                                      : Colors.transparent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Reset button
                  Align(
                    alignment: Alignment(0.5, -0.8),
                    child: Builder(
                      builder: (context) {
                        return TextButton(
                          onPressed: () {
                            showMessages(context, 'Long press to reload map', '', 5,);
                          },

                          onLongPress: () {
                            setState(() {
                              // Full data refresh
                              user = Data();
                              if (opponent == 2) {
                                comp = Data();
                              }
                            });
                            showMessages(context, 'Bingo Refreshed', '', 5);
                          },

                          child: Icon(
                            Icons.refresh,
                            color: textColor,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),

                  // settings
                  Align(
                    alignment: Alignment(0.9, -0.8),
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder:
                              (context) => Container(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.tealAccent,
                                      ),
                                      child: Center(child: Text('Settings')),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        changed(1, 0);
                                      },
                                      child: Text('Change to Human'),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        changed(2, 1);
                                      },
                                      child: Text('Change to Computer'),
                                    ),

                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.tealAccent,
                                      ),
                                      child: Center(child: Text('Level')),
                                    ),

                                    GridView(
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 2.5,
                                          ),

                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            changed(2, 1);
                                          },
                                          child: Text('Easy'),
                                        ),

                                        TextButton(
                                          onPressed: () {
                                            changed(2, 2);
                                          },
                                          child: Text('Medium'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            changed(2, 3);
                                          },
                                          child: Text('Hard'),
                                        ),

                                        TextButton(
                                          onPressed: () {
                                            changed(2, 4);
                                          },
                                          child: Text('Expert'),
                                        ),
                                      ],
                                    ),

                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.tealAccent,
                                      ),
                                      child: Center(child: Text('Fill')),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(context, PageRouteBuilder(
                                            pageBuilder: (_, __, ___) => FillType(),
                                            transitionDuration: Duration(milliseconds: 300,),
                                            transitionsBuilder: (_, animation, __, child,) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Text('Fill Manually'),
                                    ),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              ),
                        );
                      },
                      child: Icon(Icons.settings, color: textColor, size: 30),
                    ),
                  ),

                  // BINGO
                  Align(
                    alignment: Alignment(0, -0.65),
                    child: Text(
                      user.bingo,
                      style: TextStyle(fontSize: 20, color: textColor),
                    ),
                  ),
                ],
              ),

              // pc
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'This is Computer\'s Bingo Map and is read only',
                            textAlign: TextAlign.center,
                          ),

                          duration: Duration(seconds: 5),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        if (opponent == 2 && (comp!.uDone() || user.uDone()))
                          Stack(
                            children: [
                              Center(
                                child: SizedBox(
                                  width: w * 0.95,
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: 25,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 5,
                                        ),
                                    itemBuilder: (
                                      BuildContext context,
                                      int index,
                                    ) {
                                      return Card(
                                        color: (comp!.lineColor[index] == Colors.transparent) ? Color.fromRGBO(255, 255, 255, 0.09019607843137255,) : comp!.lineColor[index],
                                        child: Center(
                                          child: Text(
                                            '${comp!.bingoMap[index]}',
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment(0, -0.65),
                                child: Text(
                                  comp!.bingo,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: textColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Center(
                            child: Text(
                              (opponent == 2)
                                  ? 'Game Not\nCompleted'
                                  : 'Opponent\nis Human',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: textColor, fontSize: 50),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
