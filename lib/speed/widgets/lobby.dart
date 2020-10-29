import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Lobby extends StatefulWidget {
  @override
  _LobbyState createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text('Lobby'),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ElevatedButton(
                child: Text('Load Game'),
                onPressed: () {
                  print('loaded a game');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
