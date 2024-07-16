import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class GameScreen extends StatefulWidget {
  final String player1Name;
  final String player2Name;

  GameScreen({required this.player1Name, required this.player2Name});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<List<String>> gameBoard;
  late String currentPlayer;
  late bool gameOver;
  int player1Wins = 0;
  int player2Wins = 0;

  static const Color boardBackgroundColor = Color(0xFF1D1F33);
  static const Color cellBackgroundColor = Color(0xFF0A0E21);
  static const Color xTextColor = Colors.white;
  static const Color oTextColor = Colors.blue;
  static const Color resetButtonColor = Colors.green;
  static const Color resetButtonTextColor = Colors.white;
  static const Color containerBackgroundColor1 = Colors.pinkAccent;
  static const Color containerBackgroundColor2 = Color(0xFF1D1F33);

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    gameBoard = List.generate(3, (_) => List.generate(3, (_) => ""));
    currentPlayer = "X";
    gameOver = false;
  }

  void handleMove(int row, int col) {
    if (gameBoard[row][col] != "" || gameOver) {
      return;
    }
    setState(() {
      gameBoard[row][col] = currentPlayer;
      checkForWinner();
      currentPlayer = currentPlayer == "X" ? "O" : "X";
    });
  }

  void checkForWinner() {
    if (_checkWinConditions() || _isBoardFull()) {
      showResultDialog();
    }
  }

  bool _checkWinConditions() {
    for (int i = 0; i < 3; i++) {
      if (_checkRow(i) || _checkColumn(i)) {
        return true;
      }
    }
    return _checkDiagonals();
  }

  bool _checkRow(int row) {
    return gameBoard[row][0] != "" &&
        gameBoard[row][0] == gameBoard[row][1] &&
        gameBoard[row][1] == gameBoard[row][2];
  }

  bool _checkColumn(int col) {
    return gameBoard[0][col] != "" &&
        gameBoard[0][col] == gameBoard[1][col] &&
        gameBoard[1][col] == gameBoard[2][col];
  }

  bool _checkDiagonals() {
    return (gameBoard[0][0] != "" &&
        gameBoard[0][0] == gameBoard[1][1] &&
        gameBoard[1][1] == gameBoard[2][2]) ||
        (gameBoard[0][2] != "" &&
            gameBoard[0][2] == gameBoard[1][1] &&
            gameBoard[1][1] == gameBoard[2][0]);
  }

  bool _isBoardFull() {
    return gameBoard.every((row) => row.every((cell) => cell.isNotEmpty));
  }

  void showResultDialog() {
    String message;
    if (_isBoardFull()) {
      message = "The game ended in a draw!";
    } else {
      message = "$currentPlayer is the winner!";
      updateWins();
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.leftSlide,
      title: message,
      btnOkText: "Play Again",
      btnOkOnPress: resetGame,
    )..show();
  }

  void resetGame() {
    setState(() {
      initializeGame();
    });
  }

  void updateWins() {
    if (currentPlayer == "X") {
      player1Wins++;
    } else {
      player2Wins++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: Color(0xFF0A0E21),
        elevation: 0,
        title: Text(
          "TIC TAC TOE",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Add your action here
            },
            icon: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildPlayerContainer(widget.player1Name, player1Wins, "X"),
                buildPlayerContainer(widget.player2Name, player2Wins, "O"),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: boardBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: 9,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => handleMove(row, col),
                    child: Container(
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: cellBackgroundColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          gameBoard[row][col],
                          style: TextStyle(
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            color: gameBoard[row][col] == "X" ? xTextColor : oTextColor,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: resetGame,
              child: Container(
                decoration: BoxDecoration(
                  color: resetButtonColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                child: Text(
                  "Reset Game",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: resetButtonTextColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPlayerContainer(String playerName, int wins, String playerSymbol) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(20),
        height: 120,
        decoration: BoxDecoration(
          color: currentPlayer == playerSymbol ? containerBackgroundColor1 : containerBackgroundColor2,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              playerName,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: playerSymbol == "X" ? xTextColor : Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Wins: $wins",
              style: TextStyle(
                fontSize: 18,
                color: playerSymbol == "X" ? xTextColor : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
