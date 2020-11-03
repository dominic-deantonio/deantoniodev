import 'dart:async';
import 'dart:io';

import 'package:deantoniodev/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:deantoniodev/speed/models/speedController.dart';

import '../main.dart';

class SpeedLauncher extends StatefulWidget {
  @override
  _SpeedLauncherState createState() => _SpeedLauncherState();
}

class _SpeedLauncherState extends State<SpeedLauncher> {
  SpeedController game;
  double difficulty = 3;
  bool autoDraw = true;
  bool isDevMode = false;
  int countDown = 3;
  Timer timer;
  bool countingDown = false;

  final List<String> difficulties = ['Baby', 'Casual', 'Goldilocks', 'Tough', 'Masochist'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: game == null
          ? AppBar(
              leading: IconButton(
                icon: Icon(Icons.home),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.purple,
              title: Text('Play Speed'),
              centerTitle: true,
            )
          : null,
      body: game ?? getStartMenu(),
    );
  }

  Widget getStartMenu() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 400,
//            height: 180,
            child: countingDown ? countdownWidget() : settingsWidget(),
          ),
          SizedBox(height: 100),
          countingDown
              ? Container()
              : Container(
                  width: 130,
                  child: MaterialButton(
                    onPressed: startCountDown,
                    child: Text('Start'),
                    color: Colors.green[100],
                  ),
                ),
//          countingDown
//              ? Container()
//              : Container(
//                  width: 130,
//                  child: MaterialButton(
//                    onPressed: () {},
//                    child: Text('How to play'),
//                    color: Colors.grey[100],
//                  ),
//                ),
        ],
      ),
    );
  }

  Widget settingsWidget() {
    return Card(
      color: Colors.red,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text('Settings'),
//            debuggingWidget(),
//            autoDrawWidget(),
            aiSpeedWidget(),
          ],
        ),
      ),
    );
  }

  Widget countdownWidget() {
    return Text(
      '$countDown',
      style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
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
          Row(
            children: [
              Icon(Icons.play_arrow),
              Slider(
                onChanged: (v) => setState(() => difficulty = v),
                value: difficulty,
                min: 1,
                max: 5,
                divisions: 4,
                label: difficulties[difficulty.floor() - 1],
              ),
              Icon(Icons.fast_forward),
            ],
          )
        ],
      ),
    );
  }

  Widget autoDrawWidget() {
    return Tooltip(
      message: 'When on, immediately draws another card from your pile.',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Auto draw'),
          Switch(
            onChanged: (b) => setState(() => autoDraw = !autoDraw),
            value: autoDraw,
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
