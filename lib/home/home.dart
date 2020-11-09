import 'package:deantoniodev/shared/basicPageRoute.dart';
import 'package:deantoniodev/speed/speedLauncher.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Function scrollToSpeedPage;

  Home({this.scrollToSpeedPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Welcome to Dom's Website",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        SizedBox(height: 30),
        Text(
          "There's not much here for now, but soon I'll add my projects, about me, and other stuff.",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: 50),
        RaisedButton(color: Theme.of(context).buttonColor, child: Text('Play a game of Speed in the meantime?'), onPressed: () => scrollToSpeedPage()),
      ],
    );
  }
}
