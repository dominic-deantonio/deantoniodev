import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deantoniodev/speed/models/speedController.dart';
import 'package:deantoniodev/speed/widgets/cardPile.dart';
import 'package:deantoniodev/speed/widgets/gameCard.dart';

import '../../main.dart';

// Receives callbacks and variables to monitor from the controller.
class SpeedView extends StatelessWidget {
  final SpeedControllerState game;

  SpeedView({this.game});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                game.winGame('player');
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            backgroundColor: Colors.purple,
            title: Text('Speed'),
            centerTitle: true,
            actions: [
              game.getWinner() == null
                  ? Tooltip(
                      message: game.isPaused ? 'Resume' : 'Pause',
                      child: IconButton(
                        icon: Icon(game.isPaused ? Icons.play_arrow : Icons.pause),
                        onPressed: () => game.toggleGamePause(),
                      ),
                    )
                  : Container(),
              game.widget.devModeOn
                  ? Tooltip(
                      message: 'Ends the game with the player as the winner.',
                      child: IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: () => game.winGame("player"),
                      ),
                    )
                  : Container()
            ],
          ),
          body: game.isPaused
              ? getPauseView()
              : game.getWinner() == null
                  ? getGame()
                  : getWinLoseScreen()),
    );
  }

  Widget getGame() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                getOpponentCards(constraints),
                Text('Opponent ${game.opponentRequestsCard ? ' (requesting card)' : ''}'),
                Flexible(child: Container()),
                getCenterCards(constraints),
                Flexible(child: Container()),
                Text('Player ${game.playerRequestsCard ? ' (requesting card)' : ''}'),
                getPlayerCards(constraints),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getPlayerCards(BoxConstraints constraints) {
    return Flexible(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var card in game.playerHand) Flexible(child: card),
          SizedBox(width: constraints.maxWidth / 30),
          Flexible(
            child: CardPile(
              cards: game.playerPile,
              title: 'Player pile',
              onPressed: () => game.transferFromPileToHand(fromPile: game.playerPile, toPile: game.playerHand),
            ),
          ),
        ],
      ),
    );
  }

  Widget getCenterCards(BoxConstraints constraints) {
    return Flexible(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: CardPile(
            cards: game.stuckPileLeft,
            title: 'Click if stuck',
            onPressed: () => game.toggleCardRequest(true, !game.playerRequestsCard), //toggles the request
          )),
          Flexible(child: game.receiverPileLeft[0]),
          Flexible(child: game.receiverPileRight[0]),
          Flexible(
            child: CardPile(
              cards: game.stuckPileRight,
              title: 'Click if stuck',
              onPressed: () => game.toggleCardRequest(true, !game.playerRequestsCard), //toggles the request
            ),
          ),
        ],
      ),
    );
  }

  Widget getOpponentCards(BoxConstraints constraints) {
    return Flexible(
      flex: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: CardPile(
              cards: game.opponentPile,
              title: 'Opponent pile',
              onPressed: () {
                game.transferFromPileToHand(fromPile: game.opponentPile, toPile: game.opponentHand);
              },
            ),
          ),
          SizedBox(width: constraints.maxWidth / 30),
          for (var card in game.opponentHand) Flexible(child: card),
        ],
      ),
    );

    // Add a label
    // return output;
  }

  Widget getPauseView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: Colors.grey[900],
          child: Center(
            child: Text(
              'Paused',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
          ),
        );
      },
    );
  }

  Widget getWinLoseScreen() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: Colors.green,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  game.getWinner() == 'player' ? 'You Win!' : 'You Lose!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 40),
                ),
                Column(
                  children: [
                    Container(
                      width: 140,
                      child: MaterialButton(
                        onPressed: () => game.widget.startNewGame(),
                        child: Text('Play again'),
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 140,
                      child: MaterialButton(
                        onPressed: () => game.widget.backToSettings(),
                        child: Text('Change settings'),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
