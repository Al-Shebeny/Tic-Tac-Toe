import 'package:flutter/material.dart';
import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String resulte = '';
  Game game = Game();
  bool isSwitch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [...firstBlok(), _expanded(context), ...lastBlok()],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...firstBlok(),
                        const SizedBox(
                          height: 20,
                        ),
                        ...lastBlok(),
                      ],
                    ),
                  ),
                  _expanded(context),
                ],
              ),
      ),
    );
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: gameOver ? null : () => _onTap(index),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  Player.playerX.contains(index)
                      ? 'X'
                      : Player.playerO.contains(index)
                          ? 'O'
                          : '',
                  style: TextStyle(
                    color: Player.playerX.contains(index)
                        ? Colors.blue
                        : Colors.pink,
                    fontSize: 52,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List firstBlok() {
    return [
      SwitchListTile.adaptive(
        value: isSwitch,
        onChanged: (newValue) {
          setState(() {
            isSwitch = newValue;
          });
        },
        title: const Text(
          'Turn on/off two player',
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      Text(
        'It\'s $activePlayer Turn'.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
        ),
        textAlign: TextAlign.center,
      )
    ];
  }

  List<Widget> lastBlok() {
    return [
      Text(
        resulte,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 42,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerO = [];
            Player.playerX = [];
            activePlayer = 'X';
            gameOver = false;
            turn = 0;
            resulte = '';
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text(
          'Repeat the game',
        ),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).splashColor),
        ),
      )
    ];
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
      if (!isSwitch && !gameOver && turn != 9) {
        await game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    return setState(() {
      turn++;
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      String wennerPlayer = game.checkWinner();
      if (wennerPlayer != '') {
        gameOver = true;
        resulte = '$wennerPlayer is the wenner';
      } else if (!gameOver && turn == 9) {
        resulte = 'It\'s Drow!';
      }
    });
  }
}
