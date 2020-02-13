import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreenDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
<<<<<<< HEAD
          gradient: LinearGradient(
          // Where the linear gradient begins and ends
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.1, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.black,
            Color(0xff282828),
          ],
        ),
=======
          color: Color.fromARGB(255, 255, 255, 255),
>>>>>>> master
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
<<<<<<< HEAD
            Image.asset('assets/icon/splash.png')
=======
            Positioned(
              child: Container(
                width: 305,
                height: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 70,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Logo
                          Positioned(
                            bottom: 0,
                            child: Container(
                              child: Image.asset(
                                "assets/logo2.png",
                                width: 200,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
>>>>>>> master
          ],
        ),
      ),
    );
  }
}
