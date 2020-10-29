import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:deantoniodev/speed/models/speedAi.dart';
import 'package:deantoniodev/speed/models/speedView.dart';
import 'package:deantoniodev/speed/widgets/gameCard.dart';
import 'package:deantoniodev/speed/widgets/gameCardDetails.dart';

class SpeedController extends StatefulWidget {
  final int aiDifficultyIndex;
  final bool devModeOn;
  final Function startNewGame;
  final Function backToSettings;

  SpeedController({@required this.aiDifficultyIndex, @required this.devModeOn, @required this.startNewGame, @required this.backToSettings});

  @override
  SpeedControllerState createState() => SpeedControllerState();
}

/// The common data will live here. Will be plugged into the AI object or multiplayer for mutation
class SpeedControllerState extends State<SpeedController> {
  // All vars regarding state live here and this object is passed into the children ai object and view widget to responsively rebuild and call functions

  bool shouldAutoDraw = true; // Is toggled by the toggleAutoDraw function
  bool isPaused = false; // Is toggled by the togglePause function
  bool playerRequestsCard = false, opponentRequestsCard = false; // These represent the players' requests for new center cards
  int aiDifficultyIndex; // Is used by the AI to select the play speed

  List<GameCard> deck = GameCard.buildDeck();
  List<GameCard> playerHand = [];
  List<GameCard> playerPile = [];

  List<GameCard> opponentHand = [];
  List<GameCard> opponentPile = [];

  List<GameCard> receiverPileRight = [];
  List<GameCard> stuckPileRight = [];

  List<GameCard> receiverPileLeft = [];
  List<GameCard> stuckPileLeft = [];

  SpeedAi ai;

  void initialize() {
    deck.shuffle();
    // Deal cards to player
    playerPile.addAll(_takeFromTopOfDeck(20));
    transferCardsBetweenPiles(fromPile: playerPile, toPile: playerHand, amount: 5);

    // Deal cards to opponent and set their status
    opponentPile.addAll(_takeFromTopOfDeck(20));
    opponentPile.forEach((card) => card.details.value = GameCardDetails.fromDetails(details: card.details.value, isFaceUp: false, canDrag: false));
    transferCardsBetweenPiles(fromPile: opponentPile, toPile: opponentHand, amount: 5);

    // Set receive pile and stuck pile
    receiverPileRight.addAll(_takeFromTopOfDeck(1));
    stuckPileRight.addAll(_takeFromTopOfDeck(5));
    // For each card in the receiver pile (only one), set the details correctly and set the card's acceptance function
    receiverPileRight.forEach((receiverCard) {
      receiverCard.details.value = GameCardDetails.fromDetails(details: receiverCard.details.value, canDrag: false);
      receiverCard.setAcceptCardDragLogic((incoming) => receiverWillAccept(incoming, receiverCard));
      receiverCard.setOnIncomingCardAccepted((incoming) => doAcceptCard(receiverPileRight, incoming));
    });

    // Set receive pile and stuck pile
    receiverPileLeft.addAll(_takeFromTopOfDeck(1));
    stuckPileLeft.addAll(_takeFromTopOfDeck(5));
    // For each card in the receiver pile (only one), set the details correctly and set the card's acceptance function
    receiverPileLeft.forEach((receiverCard) {
      receiverCard.details.value = GameCardDetails.fromDetails(details: receiverCard.details.value, canDrag: false);
      receiverCard.setAcceptCardDragLogic((incoming) => receiverWillAccept(incoming, receiverCard));
      receiverCard.setOnIncomingCardAccepted((incoming) => doAcceptCard(receiverPileLeft, incoming));
    });

    if (widget.devModeOn) {
      toggleDeveloperMode();
    }

    aiDifficultyIndex = widget.aiDifficultyIndex;
    ai = SpeedAi(this);
  }

  // Pick a card from the 0 index in the deck and remove it
  List<GameCard> _takeFromTopOfDeck(int num) {
    List<GameCard> fromDeck = [];

    for (int i = 0; i < num; i++) {
      fromDeck.add(deck.first);
      deck.removeAt(0);
    }

    return fromDeck;
  }

  // Returns whether the card that was dragged on should accept the incoming card
  bool receiverWillAccept(GameCard incomingCard, GameCard receiverCard) {
    GameCardDetails receiverDetails = receiverCard.details.value;
    GameCardDetails incomingDetails = incomingCard.details.value;
    if (receiverDetails == incomingDetails) {
      // Same card, don't accept (shouldn't be possible)
      return false;
    } else {
      int receiverRank = receiverDetails.rank.index + 1; // 1(A) through 13(K)
      int incomingRank = incomingDetails.rank.index + 1; // Same ^

      // If A and K or 2
      if (receiverRank == 1 && (incomingRank == 13 || incomingRank == 2)) {
        return true;
      }

      // If K and A or Q
      if (receiverRank == 13 && (incomingRank == 1 || incomingRank == 12)) {
        return true;
      }

      // If not K or A and the difference is 1
      int diff = (receiverRank - incomingRank).abs();
      if (diff == 1) {
        return true;
      }
    }
    // If we make it all the way down here the drag was invalid
    return false;
  }

  // After the card was accepted by the receiving pile
  void doAcceptCard(List<GameCard> receiverPile, GameCard incoming) {
    setState(() {
      List<GameCard> fromHand = playerHand;
      List<GameCard> drawFromPile = playerPile;

      if (opponentHand.contains(incoming)) {
        fromHand = opponentHand;
        drawFromPile = opponentPile;
      } else {
        // The player played a card, reset the request
        playerRequestsCard = false;
      }

      fromHand.remove(incoming);
      receiverPile.insert(0, incoming);

      // Set the card to be a receiver and undraggable
      incoming.details.value = GameCardDetails.fromDetails(details: incoming.details.value, canDrag: false, isFaceUp: true);
      incoming.setAcceptCardDragLogic((newCard) => receiverWillAccept(incoming, newCard));
      incoming.setOnIncomingCardAccepted((newCard) => doAcceptCard(receiverPile, newCard));

      // Auto draw a new card from the pile (if turned on)
      if (shouldAutoDraw) transferCardsBetweenPiles(fromPile: drawFromPile, toPile: fromHand, amount: 1);
    });
  }

  // Moves specified number of cards between lists
  void transferCardsBetweenPiles({List<GameCard> fromPile, List<GameCard> toPile, int amount}) {
    if (fromPile.length > 0) {
      setState(() {
        for (int i = 0; i < amount; i++) {
          toPile.add(fromPile[i]);
          fromPile.removeAt(i);
        }
      });
    }
  }

  void transferFromPileToHand({@required List<GameCard> fromPile, @required List<GameCard> toPile, int amount}) {
    amount = amount ?? 1;
    if (fromPile.length > 0 && toPile.length < 5) {
      transferCardsBetweenPiles(fromPile: fromPile, toPile: toPile, amount: amount);
    }
  }

  void drawCenterCards({@required List<GameCard> fromPile, @required List<GameCard> toPile}) {
    setState(() {
      if (fromPile.length > 0) {
        GameCard card = fromPile[0]; // Get the top card
        card.details.value = GameCardDetails.fromDetails(details: card.details.value, canDrag: false); // Give new details
        card.setAcceptCardDragLogic((newCard) => receiverWillAccept(card, newCard)); // Logic to decide to accept new cards
        card.setOnIncomingCardAccepted((newCard) => doAcceptCard(toPile, newCard)); // Logic for accepting new card
        toPile.insert(0, card); // Insert the new card on the top
        fromPile.removeAt(0); // Remove from the old pile
      } else {
        if (stuckPileRight.length == 0 && stuckPileLeft.length == 0) {
          consolidateCenterCards();
        }
      }
    });
  }

  void consolidateCenterCards() {
    // shuffle and reset the cards here
    List<GameCard> centerCards = [];
    centerCards.addAll(stuckPileLeft);
    centerCards.addAll(stuckPileRight);
    centerCards.addAll(receiverPileLeft);
    centerCards.addAll(receiverPileRight);

    centerCards.shuffle();
    // print('Combined all the center cards and shuffled them. There are ${centerCards.length}');

    receiverPileRight = [centerCards[0]];
    centerCards.removeAt(0);
    receiverPileLeft = [centerCards[0]];
    centerCards.removeAt(0);
    // print('Added a card to right and left receivers. ${centerCards.length} remain in the stack');

    int half = (centerCards.length / 2).floor();
    // print('Will give the left $half');

    stuckPileLeft = [];
    for (int i = 0; i < half; i++) {
      stuckPileLeft.add(centerCards[0]);
      centerCards.removeAt(0);
    }
    // print('The left now has ${stuckPileLeft.length}. The center cards now has ${centerCards.length}');

    stuckPileRight = List.from(centerCards);
    // print('The right now has ${stuckPileRight.length}.');

    centerCards.clear();
    // print('Cleared the center cards, but not necessary');
  }

  // Toggles the request for the specified boolean (player or opponent) to attempt drawing center card
  void toggleCardRequest(bool isPlayerRequest, bool isRequesting) {
    setState(() {
      isPlayerRequest ? playerRequestsCard = isRequesting : opponentRequestsCard = isRequesting;
      if (playerRequestsCard && opponentRequestsCard) {
        drawCenterCards(fromPile: stuckPileLeft, toPile: receiverPileLeft);
        drawCenterCards(fromPile: stuckPileRight, toPile: receiverPileRight);
        playerRequestsCard = false;
        opponentRequestsCard = false;
      }
    });
  }

  // Set the should auto draw to true or false.
  void toggleAutoDraw() {
    setState(() {
      shouldAutoDraw = !shouldAutoDraw;
    });
  }

  void toggleGamePause() {
    setState(() {
      if (getWinner() == null) {
        isPaused = !isPaused;
      }
    });
  }

  void toggleDeveloperMode() {
    opponentPile.forEach((card) => card.details.value = GameCardDetails.fromDetails(details: card.details.value, isFaceUp: true));
    opponentHand.forEach((card) => card.details.value = GameCardDetails.fromDetails(details: card.details.value, isFaceUp: true));
  }

  // Checks the player and opponent's cards. Returns null if no winner
  String getWinner() {
    // Player has no more cards anywhere
    if (playerHand.length + playerPile.length == 0) {
      return 'player';
    } else if (opponentHand.length + opponentPile.length == 0) {
      return 'opponent';
    } else {
      return null;
    }
  }

  void winGame(String winner) {
    setState(() {
      if (winner == 'player') {
        playerHand.clear();
        playerPile.clear();
      } else {
        opponentHand.clear();
        opponentPile.clear();
      }
    });
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  FocusNode kbFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // This should just instantiate the view and pass in the variables for the view to track and rebuild from
    // The methods here are called by the view (user) and the ai or other player

    return RawKeyboardListener(
      onKey: (event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey.keyLabel == ' ') toggleGamePause();
        }
      },
      focusNode: kbFocusNode,
      child: SpeedView(game: this),
    );
  }
}
