import 'package:deantoniodev/home/home.dart';
import 'package:deantoniodev/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:deantoniodev/speed/speedLauncher.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  AppState createState() => AppState();
}

class AppState extends State<App> {
  bool usingDarkTheme = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: usingDarkTheme ? Themes.dark : Themes.light,
      home: Scaffold(
        appBar: AppBar(
          actions: [
            FlatButton(child: Icon(Icons.brightness_6), onPressed: () {
              setState(() {
                usingDarkTheme = !usingDarkTheme;
              });
            }),
          ],
        ),
        body: Home(),
      ),
    );
  }
}
