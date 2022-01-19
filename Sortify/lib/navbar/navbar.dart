// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

bool desktop = true;

class navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth > 1200){
          desktop = true;
        }
        else{
          desktop = false;
        }
        return DesktopNavbar();
      },
    );
  }
}


class DesktopNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(desktop)
    {
      return Container(
        //padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Spacer(flex: 1),
            Flexible(
              flex: 45,
              child:
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Sortify", 
                  style: TextStyle(
                    fontFamily: "SpotifyBold",
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
    else
    {
      return Container(
        //padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Spacer(flex: 1),
            Flexible(
              flex: 45,
              child:
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Sortify", 
                  style: TextStyle(
                    fontFamily: "SpotifyBold",
                    fontWeight: FontWeight.bold, 
                    color: Colors.white, 
                    fontSize: 70, 
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
}


class MobileNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}