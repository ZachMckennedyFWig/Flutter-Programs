import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// DEFAULT VALUES:
const Color dText = Colors.black;
const Color dBg = Colors.transparent;
const BoxFit dFit = BoxFit.none;
const TextOverflow dOf = TextOverflow.ellipsis;

// Color presets for project: 
Color pGray([double opacity = 1.0]) {return Color.fromRGBO(25, 20, 20, opacity);} // Spotify Gray
Color pGreen([double opacity = 1.0]) {return Color.fromRGBO(29, 185, 84, opacity);} // Spotify Green
Color pWhite([double opacity = 1.0]) {return Color.fromRGBO(255, 255, 255, opacity);} // White
Color pBlack([double opacity = 1.0]) {return Color.fromRGBO(0, 0, 0, opacity);} // Black

// Boxfit preset for project:
BoxFit pFit = BoxFit.fitWidth;



Widget genText(String text, double size, {Color color = dText, BoxFit fitType = dFit, Color bg = dBg, bool overflow = false, TextOverflow ofType = dOf})
{
  // Function to generate basic text so I don't have to copy and paste a lot of brackets everywhere
  /*
  required params: 
    text -> String of text you want
    size -> Default size of text

  optional parameters:
    color -> Main color of text
    fitType -> How the text should size itself if the box is too small
    bg -> Background color 
    overflow -> should the text overflow 
    ofType -> How should the text overflow
  */
  if(overflow)
  {
    return FittedBox(
              fit: fitType,
              child: Text(text, overflow: ofType, style: TextStyle(color: color, fontSize: size, backgroundColor: bg))
            );
  }
  else
  {
    return FittedBox(
              fit: fitType,
              child: Text(text, style: TextStyle(color: color, fontSize: size, backgroundColor: bg))
            );
  }
}


Widget balls = genText('hell0', 15, color: pGreen());



