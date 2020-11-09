import 'dart:ui';

import 'package:deantoniodev/home/home.dart';
import 'package:deantoniodev/shared/themes.dart';
import 'package:flutter/material.dart';
import 'package:deantoniodev/speed/speedLauncher.dart';
import 'package:flutter/services.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  AppState createState() => AppState();
}

class AppState extends State<App> {
  final _responsiveBreak = 640;

  ThemeData currentTheme = Themes.dark;
  SpeedLauncher speedLauncher = SpeedLauncher();
  PageController pageController = PageController(viewportFraction: 0.99); // Fraction allows the next thing next page to stay alive

  final double drawerButtonHeight = 60;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      home: LayoutBuilder(
        builder: (_, constraints) {
          return Scaffold(
            appBar: AppBar(
              title: MaterialButton(
                child: Text('deantonio.dev'),
                onPressed: () => _scrollToPage(0),
              ),
              actions: constraints.maxWidth > _responsiveBreak ? _buildNavOptions(constraints) : null,
            ),
            endDrawer: Builder(
              builder: (BuildContext context) {
                return _buildDrawer(constraints, context);
              },
            ),
            body: Center(
              child: PageView(
                physics: AlwaysScrollableScrollPhysics(),
                controller: pageController,
                pageSnapping: false,
                scrollDirection: Axis.vertical,
                children: [
                  Home(scrollToSpeedPage: () => _scrollToPage(1)),
                  speedLauncher,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildNavOptions(BoxConstraints constraints) {
    List<Widget> actions = List<Widget>();
    actions.add(
      MaterialButton(
        child: Text(
          "Projects",
          textAlign: TextAlign.start,
        ),
        onPressed: () {},
      ),
    );
    actions.add(
      MaterialButton(
        child: Text(
          "About me",
          textAlign: TextAlign.start,
        ),
        onPressed: () {},
      ),
    );
    actions.add(
      MaterialButton(
        child: Text(
          "Tech",
          textAlign: TextAlign.start,
        ),
        onPressed: () {},
      ),
    );
    if (constraints.maxWidth > _responsiveBreak) actions.add(MaterialButton(child: Icon(Icons.brightness_6), onPressed: () => toggleTheme()));
    return actions;
  }

  void _scrollToPage(int page) {
    pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void toggleTheme() {
    setState(() => currentTheme == Themes.dark ? currentTheme = Themes.light : currentTheme = Themes.dark);
  }

  Widget _buildDrawer(BoxConstraints constraints, BuildContext context) {
    List<Widget> actions = _buildNavOptions(constraints);
    Drawer drawer = Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'deantonio.dev',
              style: Theme.of(context).textTheme.headline6,
            ),
            automaticallyImplyLeading: false,
            actions: [
              MaterialButton(child: Icon(Icons.brightness_6), onPressed: () => toggleTheme()),
            ],
          ),
          for (var action in actions)
            Container(
              width: constraints.maxWidth,
              height: drawerButtonHeight,
              child: action,
            ),
        ],
      ),
    );

    if (constraints.maxWidth < _responsiveBreak) {
      return drawer;
    } else {
      return Container();
    }
  }
}
