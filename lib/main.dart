import 'package:flutter/material.dart';
import "dart:async";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text('Conway\'s Game of Life')),
      body: Container(
        margin: const EdgeInsets.all(30),
        // decoration: const BoxDecoration(boxShadow: [
        //   BoxShadow(
        //     color: Color.fromARGB(7, 255, 0, 0),
        //     blurRadius: 10.0,
        //     spreadRadius: 20.0,
        //     offset: Offset(5.0, 5.0),
        //   )
        // ]
        // ),
        child: Board(),
      ),
    ));
  }
}

class Board extends StatefulWidget {
  Board();

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  final int dimension = 10;
  var squares = List<bool>.generate(10 * 10, (_) => false);
  var isRunning = false;

  step() {
    setState(() {
      squares = squares.asMap().entries.map((entry) {
        final int index = entry.key;
        final bool isAlive = entry.value;

        final int numberOfAliveNeighbors = (squares[
                    (index - dimension - 1) % (dimension * dimension)]
                ? 1
                : 0) +
            (squares[(index - dimension) % (dimension * dimension)] ? 1 : 0) +
            (squares[(index - dimension + 1) % (dimension * dimension)]
                ? 1
                : 0) +
            (squares[(index - 1) % (dimension * dimension)] ? 1 : 0) +
            (squares[(index + 1) % (dimension * dimension)] ? 1 : 0) +
            (squares[(index + dimension - 1) % (dimension * dimension)]
                ? 1
                : 0) +
            (squares[(index + dimension) % (dimension * dimension)] ? 1 : 0) +
            (squares[(index + dimension + 1) % (dimension * dimension)]
                ? 1
                : 0);

        if (!isAlive) {
          return numberOfAliveNeighbors == 3;
        }

        if (numberOfAliveNeighbors < 2) {
          return false;
        }

        if (numberOfAliveNeighbors > 3) {
          return false;
        }

        if (numberOfAliveNeighbors == 2 || numberOfAliveNeighbors == 3) {
          return true;
        }

        return false;
      }).toList();
    });
  }

  Future run() {
    return Future.delayed(Duration(milliseconds: 85)).then((_) {
      if (isRunning) {
        step();
        run();
      }
    });
  }

// Future.delayed(const Duration(seconds: 1), () {
//   print('One second has passed.'); // Prints after 1 second.
// });

// Future.delayed(const Duration(milliseconds: 100), () {
//       if (isRunning) {
//         step();
//       }
//     });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GridView.count(
        shrinkWrap: true,
        crossAxisCount: dimension,
        children: squares.asMap().entries.map((entry) {
          return OutlinedButton(
            style: OutlinedButton.styleFrom(
                backgroundColor:
                    squares[entry.key] ? Colors.black : Colors.white),
            onPressed: () {
              setState(() {
                squares[entry.key] = !squares[entry.key];
              });
            },
            child: const Text(''),
            // child: Container(
            //   width: double.infinity,
            //   color: squares[entry.key] ? Colors.black : Colors.green,
            // ),
            // decoration:
            //     BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          );
        }).toList(),
      ),
      OutlinedButton(
          onPressed: () => setState(() {
                run();
                isRunning = true;
              }),
          child: const Text('Run')),
      OutlinedButton(
          onPressed: () => setState(() {
                isRunning = false;
              }),
          child: const Text('Stop')),
      OutlinedButton(onPressed: step, child: const Text('Step')),
      OutlinedButton(
          onPressed: () => setState(() {
                isRunning = false;
                squares = List<bool>.generate(10 * 10, (_) => false);
              }),
          child: const Text('Clear')),
    ]);
  }
}
