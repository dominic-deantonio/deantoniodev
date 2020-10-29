import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'gameCardDetails.dart';

class GameCard extends StatefulWidget {
  ValueNotifier<GameCardDetails> details = ValueNotifier(GameCardDetails()); // Update this with a NEW details to trigger a rebuild
  bool Function(GameCard) _onWillAcceptDrag;
  Function(GameCard) _onIncomingCardAccepted;

  GameCard({GameCardDetails details, Function onWillAcceptDrag, Function onIncomingCardAccepted}) {
    this.details.value = details;
    this._onWillAcceptDrag = onWillAcceptDrag ?? (_) => false; // If no onWillAccept provided, just return false
    this._onIncomingCardAccepted = onIncomingCardAccepted ?? (_) => false; // If no onWillAccept provided, just return false
  }

  static List<GameCard> buildDeck() {
    List<GameCard> deck = [];
    Suit.values.forEach((suit) {
      Rank.values.forEach((rank) {
        GameCard card = GameCard(details: GameCardDetails(rank: rank, suit: suit));
        deck.add(card);
      });
    });
    return deck;
  }

  void setAcceptCardDragLogic(bool Function(GameCard) func) {
    // This GameCard is the INCOMING card passed from the onWillAccept function in the DragTarget
    this._onWillAcceptDrag = func;
  }

  void setOnIncomingCardAccepted(Function(GameCard) func) {
    // This GameCard is the INCOMING card passed from the onWillAccept function in the DragTarget
    this._onIncomingCardAccepted = func;
  }

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool willAccept = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 62 / 88,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ValueListenableBuilder(
            valueListenable: widget.details,
            builder: (BuildContext context, GameCardDetails details, Widget child) {
              return Draggable<GameCard>(
                data: widget,
                maxSimultaneousDrags: details.canDrag ? 1 : 0,
                ignoringFeedbackSemantics: false,
                feedback: Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Card(
                    child: details.isFaceUp ? _getFaceUp(constraints) : Container(),
                    elevation: 15,
                  ),
                ),
                childWhenDragging: Card(
                  color: Colors.grey[200],
                  elevation: 0,
                ),
                child: DragTarget<GameCard>(
                  onAccept: (d) => widget._onIncomingCardAccepted(d),
                  onWillAccept: (incoming) => widget._onWillAcceptDrag(incoming),
                  builder: (context, list1, list2) {
                    return Card(
                      child: details.isFaceUp ? _getFaceUp(constraints) : _getFaceDown(constraints),
                    );
                  },
                ),
                onDragStarted: () {},
                onDragEnd: (details) {},
              );
            },
          );
        },
      ),
    );
  }

  IconData _getIcon() {
    switch (widget.details.value.suit) {
      case Suit.club:
        return CupertinoIcons.suit_club_fill;
        break;
      case Suit.diamond:
        return CupertinoIcons.suit_diamond_fill;
        break;
      case Suit.heart:
        return CupertinoIcons.heart_solid;
        break;
      default:
        return CupertinoIcons.suit_spade_fill;
        break;
    }
  }

  Widget _getFaceUp(BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _getRank(),
          style: TextStyle(fontSize: constraints.maxHeight / 3, fontWeight: FontWeight.bold),
        ),
        Icon(
          _getIcon(),
          color: widget.details.value.suit == Suit.club || widget.details.value.suit == Suit.spade ? Colors.black : Colors.red,
          size: constraints.maxHeight / 3, // Make sure to specify the width of the parent
        ),
        SizedBox(
          height: constraints.maxHeight / 15,
        )
      ],
    );
  }

  Widget _getFaceDown(BoxConstraints constraints) {
    double size = constraints.maxHeight / 4.5;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(CupertinoIcons.suit_club_fill, size: size),
          Icon(CupertinoIcons.suit_diamond_fill, size: size),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Icon(CupertinoIcons.heart_solid, size: size),
          Icon(CupertinoIcons.suit_spade_fill, size: size),
        ]),
      ],
    );
  }

  String _getRank() {
    List<String> out = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
    return out[widget.details.value.rank.index];
  }
}
