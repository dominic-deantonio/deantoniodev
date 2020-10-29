import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

enum Rank { ace, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king }
enum Suit { club, diamond, heart, spade }

/// Holds all the details about the card. Should be replaced, not updated, to trigger the ValueListenable to build

class GameCardDetails {
  Rank rank;
  Suit suit;
  bool isFaceUp;
  bool canDrag;

  GameCardDetails({this.rank, this.suit, this.isFaceUp: true, this.canDrag: true});

  /// Takes details from a previous card and optional parameters to set selected parameters if provided.
  /// If fields were not provided, the value of the old details is used
  GameCardDetails.fromDetails({@required GameCardDetails details, Rank rank, Suit suit, bool isFaceUp, bool canDrag, bool isTarget}) {
    this.rank = rank ?? details.rank;
    this.suit = suit ?? details.suit;
    this.isFaceUp = isFaceUp ?? details.isFaceUp;
    this.canDrag = canDrag ?? details.canDrag;
  }
//
//  @override
//  String toString() {
//    String out = '\nRank: ${this.rank}' + '\nSuit: ${this.suit}' + '\nIs face up: ${this.isFaceUp}' + '\nCan drag: ${this.canDrag}';
//    return out;
//  }
}
