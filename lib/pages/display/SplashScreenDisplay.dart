import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreenDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
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
          ],
        ),
      ),
    );
  }
}
