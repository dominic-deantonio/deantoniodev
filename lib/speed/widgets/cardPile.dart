import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:deantoniodev/speed/widgets/gameCard.dart';

class CardPile extends StatefulWidget {
  List<GameCard> cards;
  String title;
  Function onPressed;

  CardPile({List<GameCard> cards, String title, Function onPressed}) {
    this.cards = cards;
    this.title = title;
    this.onPressed = onPressed;
  }

  @override
  _CardPileState createState() => _CardPileState();
}

class _CardPileState extends State<CardPile> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 62 / 88,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Card(
            color: Colors.cyanAccent,
            child: TextButton(
              onPressed: () => setState(() {
                widget.onPressed();
              }),
              child: label(constraints),
            ),
          );
        },
      ),
    );
  }

  Widget label(BoxConstraints constraints) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          (widget.cards.length - count).toString(),
          style: TextStyle(fontSize: constraints.maxHeight / 5, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          widget.title,
          style: TextStyle(fontSize: constraints.maxHeight / 10, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
