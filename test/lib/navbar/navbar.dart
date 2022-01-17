// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return DesktopNavbar();
        } else {
          return MobileNavbar();
        }
      },
    );
  }
}

class DesktopNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          Flexible(
            flex: 45,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Sortify",
                style: TextStyle(
                    fontFamily: "Spotify",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 100,
                    letterSpacing: 0),
              ),
            ),
          ),
          Spacer(flex: 1),
        ],
      ),
    );
  }
}

class MobileNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
