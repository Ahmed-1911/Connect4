import 'package:flutter/material.dart';

void main() {
  runApp(const ConnectFourApp());
}

class ConnectFourApp extends StatelessWidget {
  const ConnectFourApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Connect Four',
      home: ConnectFourScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConnectFourScreen extends StatefulWidget {
  const ConnectFourScreen({super.key});

  @override
  _ConnectFourScreenState createState() => _ConnectFourScreenState();
}

class _ConnectFourScreenState extends State<ConnectFourScreen> {
  static const int rows = 6;
  static const int cols = 7;
  static const double tileSize = 60.0;

  List<List<int>> board = List.generate(rows, (_) => List.filled(cols, 0));
  int currentPlayer = 1;
  int winner = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Four'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Current Player ",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.circle,
                  color: currentPlayer == 1 ? Colors.yellow : Colors.red,
                  size: 30,
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTapDown: (details) => _handleTap(details),
              child: CustomPaint(
                painter: ConnectFourPainter(board, winner),
                size: const Size(cols * tileSize, rows * tileSize),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: winner != 0
          ? FloatingActionButton(
              backgroundColor: Colors.teal,
              child: const Icon(Icons.refresh),
              onPressed: () => _reset(),
            )
          : null,
    );
  }

  void _handleTap(TapDownDetails details) {
    if (winner == 0) {
      int col = (details.localPosition.dx ~/ tileSize).toInt();
      if (board[0][col] == 0) {
        for (int row = rows - 1; row >= 0; row--) {
          if (board[row][col] == 0) {
            board[row][col] = currentPlayer;
            if (_isWinner(currentPlayer, row, col)) {
              setState(() {
                winner = currentPlayer;
              });
            } else {
              setState(() {
                currentPlayer = currentPlayer == 1 ? 2 : 1;
              });
            }
            break;
          }
        }
      }
    }
  }

  bool _isWinner(int player, int row, int col) {
    // Check horizontal
    int count = 0;
    for (int c = 0; c < cols; c++) {
      if (board[row][c] == player) {
        count++;
        if (count == 4) {
          return true;
        }
      } else {
        count = 0;
      }
    }

    // Check vertical
    count = 0;
    for (int r = 0; r < rows; r++) {
      if (board[r][col] == player) {
        count++;
        if (count == 4) {
          return true;
        }
      } else {
        count = 0;
      }
    }

    // Check diagonal up
    count = 0;
    int r = row + 1;
    int c = col - 1;
    while (r < rows && c >= 0 && board[r][c] == player) {
      count++;
      r++;
      c--;
    }
    r = row - 1;
    c = col + 1;
    while (r >= 0 && c < cols && board[r][c] == player) {
      count++;
      r--;
      c++;
    }
    if (count >= 3) {
      return true;
    }

    // Check diagonal down
    count = 0;
    r = row - 1;
    c = col - 1;
    while (r >= 0 && c >= 0 && board[r][c] == player) {
      count++;
      r--;
      c--;
    }
    r = row + 1;
    c = col + 1;
    while (r < rows && c < cols && board[r][c] == player) {
      count++;
      r++;
      c++;
    }
    if (count >= 3) {
      return true;
    }

    return false;
  }

  void _reset() {
    setState(() {
      board = List.generate(rows, (_) => List.filled(cols, 0));
      currentPlayer = 1;
      winner = 0;
    });
  }
}

class ConnectFourPainter extends CustomPainter {
  final List<List<int>> board;
  final int winner;
  static const int rows = 6;
  static const int cols = 7;
  static const double tileSize = 60.0;

  ConnectFourPainter(this.board, this.winner);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white);

    // Draw board
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        double x = col * tileSize;
        double y = row * tileSize;
        canvas.drawRect(Rect.fromLTWH(x, y, tileSize - 1, tileSize - 1),
            Paint()..color = Colors.teal);
        if (board[row][col] == 1) {
          canvas.drawCircle(Offset(x + tileSize / 2, y + tileSize / 2),
              tileSize / 3, Paint()..color = Colors.yellow);
        } else if (board[row][col] == 2) {
          canvas.drawCircle(Offset(x + tileSize / 2, y + tileSize / 2),
              tileSize / 3, Paint()..color = Colors.red);
        }
      }
    }

    // Draw winner message
    if (winner != 0) {
      TextSpan span = TextSpan(
        text: 'Player $winner wins!',
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: winner == 1 ? Colors.yellow : Colors.red,
        ),
      );
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas,
          Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
