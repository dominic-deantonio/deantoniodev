import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deantoniodev/speed/models/speedController.dart';
import 'package:deantoniodev/speed/widgets/cardPile.dart';

// Receives callbacks and variables to monitor from the controller.
class SpeedView extends StatelessWidget {
  final SpeedControllerState game;
  final centerPileText = 'Draw one';
  final myPileText = 'cards left';

  SpeedView({this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'Speed',
            style: Theme.of(context).textTheme.headline6,
          ),
          centerTitle: true,
          actions: [
            getPauseButton(),
            getEndGameButton("player"),
            getEndGameButton("opponent"),
          ],
        ),
        body: game.isPaused
            ? getPauseView()
            : game.getWinner() == null
                ? getGame()
                : getWinLoseScreen());
  }

  Widget getPauseButton() {
    if (game.getWinner() == null) {
      return Tooltip(
        message: game.isPaused ? 'Resume' : 'Pause',
        child: FlatButton(
          child: Icon(game.isPaused ? Icons.play_arrow : Icons.pause),
          onPressed: () => game.toggleGamePause(),
        ),
      );
    } else {
      return Container();
    }
  }

  // If using dev mode and the game is not over get the stop button
  Widget getEndGameButton(String winner) {
    if (game.widget.devModeOn && game.getWinner() == null) {
      return Tooltip(
        message: 'Ends the game with the $winner as the winner.',
        child: FlatButton(
          child: Icon(winner == "player" ? Icons.thumb_up : Icons.thumb_down),
          onPressed: () => game.winGame(winner),
        ),
      );
    } else {
      return Container();
    }
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
                Text(
                  'Opponent ${game.opponentRequestsCard ? ' (requesting card)' : ''}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Flexible(child: Container()),
                getCenterCards(constraints),
                Flexible(child: Container()),
                getPlayerCards(constraints),
                Text(
                  'You ${game.playerRequestsCard ? ' (requesting card)' : ''}',
                  style: Theme.of(context).textTheme.headline6,
                ),
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
          Flexible(child: CardPile(cards: game.playerPile, title: myPileText)),
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
              title: centerPileText,
              onPressed: () => game.toggleCardRequest(true, !game.playerRequestsCard), //toggles the request
            ),
          ),
          Flexible(child: game.receiverPileLeft[0]),
          Flexible(child: game.receiverPileRight[0]),
          Flexible(
            child: CardPile(
              cards: game.stuckPileRight,
              title: centerPileText,
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
          Flexible(child: CardPile(cards: game.opponentPile, title: myPileText)),
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
        return Card(
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Center(
              child: Text(
                'Paused',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline3,
              ),
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  game.getWinner() == 'player' ? 'You Win!' : 'You Lose!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Column(
                  children: [
                    Container(
                      width: 140,
                      child: RaisedButton(
                        onPressed: () => game.widget.startNewGame(),
                        child: Text('Play again'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 140,
                      child: MaterialButton(
                        onPressed: () => game.widget.backToSettings(),
                        child: Text('Change settings'),
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
