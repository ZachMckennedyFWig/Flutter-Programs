// ignore_for_file: file_names

import 'package:flutter/material.dart';

class navbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth > 1200){
          return DesktopNavbar();
        }
        else{
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
        children:[
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Sortify", 
            style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 100, letterSpacing: 0),
          ),
          const SizedBox(
            height: 20
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Home", 
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 30,
              ),
              Text(
                "About", 
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class MobileNavbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}