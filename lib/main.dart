import 'dart:ui';
import 'package:deantoniodev/shared/gif.dart';
import 'package:deantoniodev/shared/projectData.dart';
import 'shared/project.dart';
import 'package:flutter/services.dart';
import 'versions/versions.dart';
import 'package:deantoniodev/shared/themes.dart';
import 'package:deantoniodev/shared/util.dart';
import 'package:deantoniodev/speed/speedLauncher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  AppState createState() => AppState();
}

class AppState extends State<App> {
  // State----------------------------------------------
  ThemeData currentTheme = Themes.dark;
  SpeedLauncher speedLauncher = SpeedLauncher();
  PageController mainPageController = PageController();
  PageController projectsPageController = PageController();
  FocusNode node = FocusNode();
  Project currentProject;

  List<Project> projects = ProjectData.projects;

  // Methods----------------------------------------------
  void scrollToPage(int page) {
    mainPageController.animateToPage(page, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void scrollToProject(String direction) {
    if (direction == "next") {
      projectsPageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      projectsPageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  String getThemeButtonLabel() {
    String out = currentTheme == Themes.dark ? 'Lighten up' : 'Go dark';
    return out;
  }

  void toggleTheme() {
    setState(() {
      currentTheme == Themes.dark ? currentTheme = Themes.light : currentTheme = Themes.dark;
    });
  }

  void switchToProject(Project p) {
    setState(() {
      currentProject = p;
    });
  }

  @override
  void initState() {
    currentProject = projects[0];
    super.initState();
  }

  @override
  void dispose() {
    mainPageController.dispose();
    projectsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      home: RawKeyboardListener(
        focusNode: node,
        autofocus: true,
        onKey: (event) {
          if (event is RawKeyDownEvent) {
            _navigatePagesWithDirectionalPad(event);
            _navigateProjectsWithDirectionalPad(event);
          }
        },
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Scaffold(
              body: Scrollbar(
                child: Stack(
                  children: [
                    _getBackgroundImage(constraints),
                    _getGradient(),
                    Center(child: _getVersion(constraints, this)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Private methods--------------------------------------
  void _navigateProjectsWithDirectionalPad(RawKeyDownEvent event) {
    if (projectsPageController.hasClients) {
      if (mainPageController.page == 2) {
        if (event.character == 'ArrowRight') {
          scrollToProject('next');
        } else if (event.character == 'ArrowLeft') {
          scrollToProject('previous');
        }
      }
    }
  }

  Widget _getVersion(BoxConstraints constraints, AppState state) {
    double w = constraints.maxWidth;
    if (w >= 1200) {
      return Desktop(constraints: constraints, state: state);
    } else if (w >= 992) {
      return Text("Tablet Landscape");
    } else if (w >= 768) {
      return Text("Tablet Portrait");
    } else if (w >= 480) {
      return Text("Mobile Landscape");
    } else {
      return Text("Mobile Portrait");
    }
  }

  Widget _getGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter, // 10% of the width, so there are ten blinds.
          colors: [currentTheme.primaryColor, Colors.transparent], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
    );
  }

  Widget _getBackgroundImage(BoxConstraints constraints) {
    return Opacity(
      opacity: 0.1,
      child: Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Image.network(Constants.MAIN_BG_IMAGE, fit: BoxFit.cover),
      ),
    );
  }

  void _navigatePagesWithDirectionalPad(RawKeyDownEvent event) {
    if (mainPageController.hasClients) {
      if (event.character == 'ArrowUp') {
        mainPageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
      } else if (event.character == 'ArrowDown') {
        mainPageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
      }
    }
  }
}
