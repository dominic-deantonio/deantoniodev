import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:deantoniodev/speed/widgets/gameCard.dart';

class CardPile extends StatefulWidget {
  List<GameCard> cards;
  String title;
  Function onPressed;

  CardPile({this.cards, this.title, Function onPressed}) {
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
          return Card(child: getButton(constraints));
        },
      ),
    );
  }

  Widget getButton(BoxConstraints constraints) {
    if (widget.onPressed != null) {
      return FlatButton(
        onPressed: () => setState(() {
          widget.onPressed();
        }),
        child: getLabel(constraints),
      );
    }else{
      return getLabel(constraints);
    }
  }

  Widget getLabel(BoxConstraints constraints) {
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
