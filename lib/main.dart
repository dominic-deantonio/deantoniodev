import 'package:flutter/material.dart';
import 'package:deantoniodev/speed/speedLauncher.dart';

void main() => runApp(App());

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[900]
        ),
        home: Home(),
    );
  }


}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (a, size) {
              return Container(
                width: 1800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to Dom's Website",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: size.maxWidth / 20, color: Colors.white),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "There's not much here for now,\nbut soon I will add my projects, \nabout me, and other stuff.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: size.maxWidth / 35, color: Colors.white),
                    ),
                    SizedBox(height: 50),
                    MaterialButton(
                      color: Colors.white,
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
      ),
    );
  }
}

