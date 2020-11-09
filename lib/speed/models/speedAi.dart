import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:deantoniodev/speed/widgets/gameCard.dart';

import 'speedController.dart';

class SpeedAi {
  SpeedControllerState game;
  List<int> speeds = [10000, 8000, 4000, 3000, 1000];
  bool shouldStop = false;

  dispose() {
    shouldStop = true;
  }

  SpeedAi(SpeedControllerState game) {
    this.game = game;

    Duration duration = Duration(milliseconds: speeds[game.aiDifficultyIndex]);
    Timer.periodic(duration, (timer) {
      if (!shouldStop) {
        if (!game.isPaused && game.getWinner() == null) {
          play();
        }
      }else{
        timer.cancel();
//        print('Killed the AI');
      }
    });
  }

  void play() {
    // Is set to null if cant return anything
    List<Object> receiverAndCard = getValidReceiverAndCard();

    if (receiverAndCard == null) {
      if (!game.opponentRequestsCard) game.toggleCardRequest(false, true);
    } else {
      game.toggleCardRequest(false, false);
      List<GameCard> receiver = receiverAndCard[0];
      GameCard card = receiverAndCard[1];
      game.doAcceptCard(receiver, card);
    }
  }

  List<Object> getValidReceiverAndCard() {
    GameCard right = game.receiverPileRight[0];
    GameCard left = game.receiverPileLeft[0];

    List<Object> output = [Object(), Object()];

    // No need to check if hand length is 0
    for (int i = 0; i < game.opponentHand.length; i++) {
      GameCard card = game.opponentHand[i];
      if (game.receiverWillAccept(card, right)) {
        output[0] = game.receiverPileRight;
        output[1] = card;
        return output;
      }
      if (game.receiverWillAccept(card, left)) {
        output[0] = game.receiverPileLeft;
        output[1] = card;
        return output;
      }
    }

    return null;
  }
}
