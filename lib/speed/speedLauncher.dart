import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deantoniodev/speed/models/speedController.dart';
import 'package:url_launcher/url_launcher.dart';

class SpeedLauncher extends StatefulWidget {
  @override
  _SpeedLauncherState createState() => _SpeedLauncherState();
}

class _SpeedLauncherState extends State<SpeedLauncher> {
  SpeedController game;
  double difficulty = 3;
  bool isDevMode = false;
  int countDown = 3;
  Timer timer;
  bool countingDown = false;

  final List<String> difficulties = ['Baby', 'Casual', 'Goldilocks', 'Tough', 'Masochist'];

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer if it is null
    game = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return game ?? getStartMenu();
  }

  Widget getStartMenu() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Play', style: Theme.of(context).textTheme.headline4),
          Text('Speed', style: Theme.of(context).textTheme.headline2),
          Container(
            width: 350,
            child: countingDown ? countdownWidget() : Card(child: settingsWidget()),
          ),
          countingDown
              ? Container()
              : Container(
                  width: 130,
                  child: RaisedButton(
                    onPressed: startCountDown,
                    child: Text('Start'),
                  ),
                ),
          countingDown
              ? Container()
              : Container(
                  width: 130,
                  child: MaterialButton(
                    onPressed: _launchURL,
                    child: Text('How to play'),
                  ),
                ),
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'https://youtu.be/vqtuntlmn6U';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget settingsWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, bottom: 20, right:0),
      child: Column(
        children: [
          Text('Settings'),
//          debuggingWidget(),
          aiSpeedWidget(),
        ],
      ),
    );
  }

  Widget countdownWidget() {
    return Text(
      '$countDown',
      style: Theme.of(context).textTheme.headline1,
      textAlign: TextAlign.center,
    );
  }

  Widget aiSpeedWidget() {
    return Tooltip(
      message: 'How fast the AI plays its hand',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('AI Speed'),
          Slider(
            onChanged: (v) => setState(() => difficulty = v),
            value: difficulty,
            min: 1,
            max: 5,
            divisions: 4,
            label: difficulties[difficulty.floor() - 1],
          ),
        ],
      ),
    );
  }

  Widget debuggingWidget() {
    return Tooltip(
      message: 'Changes some settings to assist in debugging the game.',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Developer mode'),
          Switch(
            onChanged: (b) => setState(() => isDevMode = !isDevMode),
            value: isDevMode,
          ),
        ],
      ),
    );
  }

  void startCountDown() {
    setState(() => countingDown = true);
    int countDownSpeed = isDevMode ? 100 : 1000;

    timer = Timer.periodic(
      Duration(milliseconds: countDownSpeed),
      (v) => setState(() {
        if (countDown > 1) {
          countDown--;
        } else {
          timer.cancel();
          game = SpeedController(
            aiDifficultyIndex: difficulty.floor() - 1,
            devModeOn: isDevMode,
            startNewGame: () => startNewGame(),
            backToSettings: () => backToSettings(),
          );
        }
      }),
    );
  }

  void startNewGame() {
    setState(() {
      countDown = 3;
      game = null;
      startCountDown();
    });
  }

  void backToSettings() {
    setState(() {
      countDown = 3;
      countingDown = false;
      game = null;
    });
  }
}
