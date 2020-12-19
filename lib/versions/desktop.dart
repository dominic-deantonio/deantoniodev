import 'package:deantoniodev/constants.dart';
import 'package:deantoniodev/shared/AnimatedStateButton.dart';
import 'package:flutter/cupertino.dart';
import '../shared/project.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'package:deantoniodev/shared/gif.dart';

class Desktop extends StatelessWidget {
  final BoxConstraints constraints;
  final AppState state;

  Desktop({this.constraints, this.state});

  @override
  Widget build(BuildContext context) {
    double prefWidth = constraints.maxWidth > 1400 ? 1400 : constraints.maxWidth;
    List<Widget> actions = getAppBarButtons();
    return Container(
      width: prefWidth,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            height: Constants.APP_BAR_HEIGHT,
            child: Row(
              children: [
                Container(
                  height: Constants.APP_BAR_HEIGHT,
                  child: MaterialButton(
                    child: Text('deantonio.dev'),
                    onPressed: () => state.scrollToPage(0),
                  ),
                ),
                Expanded(child: Container()),
                for (var action in actions) Container(height: Constants.APP_BAR_HEIGHT, child: action),
              ],
            ),
          ),
          Container(
            height: constraints.maxHeight - Constants.APP_BAR_HEIGHT,
            child: pageView(context),
          )
        ],
      ),
    );
  }

  List<Widget> getAppBarButtons() {
    return [
      MaterialButton(child: Text('About'), onPressed: () => state.scrollToPage(1)),
      MaterialButton(child: Text('Projects'), onPressed: () => state.scrollToPage(2)),
      MaterialButton(child: Text('Contact'), onPressed: () => state.scrollToPage(3)),
      MaterialButton(child: Text(state.getThemeButtonLabel()), onPressed: () => state.toggleTheme()),
    ];
  }

  Widget pageView(BuildContext context) {
    return PageView(
      physics: AlwaysScrollableScrollPhysics(),
      controller: state.mainPageController,
      pageSnapping: false,
      scrollDirection: Axis.vertical,
      children: [
        _getWelcomePage(context),
        _getAboutPage(context),
        _getProjectsPage(context),
        _getContactPage(context),
//        state.speedLauncher,
      ],
    );
  }

  Widget _getWelcomePage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 2, child: Container()),
        Text(
          Constants.WELCOME,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        Flexible(child: Container()),
        RaisedButton(
          color: Theme.of(context).buttonColor,
          child: Text(Constants.BUTTON_TEXT_VIEW_ABOUT),
          onPressed: () => state.scrollToPage(1),
        ),
        Flexible(flex: 2, child: Container()),
      ],
    );
  }

  _getAboutPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 2, child: Container()),
        Text(
          'About',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        Flexible(child: Container()),
        RaisedButton(
          color: Theme.of(context).buttonColor,
          child: Text(Constants.BUTTON_TEXT_VIEW_WORK),
          onPressed: () => state.scrollToPage(2),
        ),
        Flexible(flex: 2, child: Container()),
      ],
    );
  }

//  _getProjectsPageOld(BuildContext context) {
//    return Column(
//      children: [
//        Text(
//          'Projects',
//          textAlign: TextAlign.left,
//          style: Theme.of(context).textTheme.headline2,
//        ),
//        Flexible(
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: [
//              Row(
//                children: [
//                  IconButton(icon: Icon(Icons.chevron_left), onPressed: () => state.scrollToProject("back")),
//                  Card(
//                    margin: EdgeInsets.only(left: 30, right: 30, bottom: 10, top: 20),
//                    child: NotificationListener(
//                      onNotification: (notification) => true, // Prevents horiz scrollbar https://github.com/flutter/flutter/issues/36474#issuecomment-513325171
//                      child: PageView(
//                        controller: state.projectsPageController,
//                        children: [
//                          for (Project p in state.projects)
//                            Container(
//                              child: Text(p.title),
//                              color: p.color,
//                            ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  IconButton(icon: Icon(Icons.chevron_right), onPressed: () => state.scrollToProject("next")),
//                ],
//              ),
////
//              Expanded(
//                child: Container(
//                  color: Colors.green,
//                  child: Text('hi'),
//                ),
//              )
//            ],
//          ),
//        ),
////        RaisedButton(
////          color: Theme.of(context).buttonColor,
////          child: Text(Constants.BUTTON_TEXT_CONTACT_ME),
////          onPressed: () => state.scrollToPage(3),
////        ),
//      ],
//    );
//  }

  _getProjectsPage(BuildContext context) {
    return Column(
      children: [
        Text(
          'Projects',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.headline2,
        ),
        SizedBox(height: 18),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: Column(
                    children: getFancyButtons(),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _displayCurrentProjectInfo(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _displayCurrentProjectInfo() {
    if (state.currentProject == null) {
      return Card(
        child: Container(),
        margin: EdgeInsets.zero,
      );
    } else {
      Project p = state.currentProject;
      return Card(
        color: Colors.transparent,
        margin: EdgeInsets.zero,
        elevation: 0,
        child: Stack(
          children: [
            AnimatedContainer(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment(0.8, 1),
                  colors: [p.color, state.currentTheme.primaryColorDark.withOpacity(.5)],
                ),
              ),
              duration: Duration(milliseconds: 200),
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      p.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      p.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: IconButton(
                            padding: EdgeInsets.only(left: 8),
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () => state.scrollToProject("back"),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(50),
                            child: PageView.builder(
                              controller: state.projectsPageController,
                              scrollDirection: Axis.horizontal,
                              itemCount: p.gifs.length,
                              itemBuilder: (BuildContext context, int index) {
                                Gif gif = p.gifs[index];
                                return Row(
                                  children: [
                                    Flexible(flex: 1, child: Image.network(gif.imageUrl)),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        gif.description,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () => state.scrollToProject("next"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text('. . . .', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _getContactPage(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Contact',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline2,
        ),
        Text(
          'Put a form here',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline3,
        ),
      ],
    );
  }

  List<Widget> getFancyButtons() {
    List<Widget> out = new List<Widget>();

    for (int i = 0; i < state.projects.length; i++) {
      Project p = state.projects[i];
      out.add(
        Flexible(
          child: FancyImageButton(
            title: p.title,
            imageUrl: p.imageUrl,
            color: p.color,
            onTap: () => state.switchToProject(p),
          ),
        ),
      );

      if (i <= state.projects.length - 2)
        out.add(SizedBox(
          height: 8,
        ));
    }

    return out;
  }
}
