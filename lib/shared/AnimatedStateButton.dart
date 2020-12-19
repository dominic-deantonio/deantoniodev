import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tap_builder/tap_builder.dart';

class FancyImageButton extends StatelessWidget {
  String title;
  String imageUrl;
  Color color;
  Function onTap;

  FancyImageButton({this.title, this.imageUrl ,this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedTapBuilder(
      onTap: onTap ?? (){},
      builder: (context, state, cursorLocation, cursorAlignment) {
        cursorAlignment = state == TapState.hover ? Alignment(-cursorAlignment.x, -cursorAlignment.y) : Alignment.center;
        return AnimatedContainer(
          transformAlignment: Alignment.center,
          transform: Matrix4.rotationX(-cursorAlignment.y * 0.1)
            ..rotateY(cursorAlignment.x * 0.1)
            ..scale(
              state == TapState.pressed ? 0.96 : 1.0,
            ),
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: state == TapState.hover ? 0.6 : 0.8,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedContainer(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment(0.8, 1),
                      colors: [color.withOpacity(.8),Colors.black.withOpacity(.2)],
                    ),
                  ),
                  height: 200,
                  transformAlignment: Alignment.center,
                  duration: const Duration(milliseconds: 200),
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 50),
                    alignment: Alignment(-cursorAlignment.x, -cursorAlignment.y),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.001),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(state == TapState.hover ? 0.2 : 0.0),
                            blurRadius: 200,
                            spreadRadius: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
