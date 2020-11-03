import 'package:deantoniodev/speed/speedLauncher.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1200),
        child: LayoutBuilder(
          builder: (a, size) {
            return Container(
              width: 1800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    "Welcome to Dom's Website",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  SizedBox(height: 30),
                  SelectableText(
                    "There's not much here for now,\nbut soon I will add my projects, \nabout me, and other stuff.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  SizedBox(height: 50),
                  MaterialButton(
                    color: Theme.of(context).buttonColor,
                    child: Text('Play a game of Speed in the meantime?'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SpeedLauncher()));
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
