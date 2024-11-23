import 'package:flutter/material.dart';

class GlobalTextStyle {

  // Default Text Light
  TextStyle defaultTextStyle({Color? color, double? fontSize}){
    return TextStyle(
      overflow: TextOverflow.ellipsis,
      fontSize: fontSize ?? 13,
      fontFamily: "Poppins-Light",
      color: color ?? Colors.black,

    );
  }

  // Default Text Medium
  TextStyle defaultTextStyleMedium({Color? color, double? fontSize}){
    return TextStyle(
      overflow: TextOverflow.ellipsis,
      fontSize: fontSize ?? 13,
      fontFamily: "Poppins-Medium",
      color: color ?? Colors.black,

    );
  }

  // Default Text Medium
  TextStyle defaultTextStyleBold({Color? color, double? fontSize, bool? withShadow = false}){
    return TextStyle(
      shadows: withShadow == false ? [] : [ 
        const Shadow(
          // offset: const  Offset(2.0, 2.0), //position of shadow
          blurRadius: 15, //blur intensity of shadow
          color: Colors.black45 //color of shadow with opacity
        ),
      ],
      overflow: TextOverflow.ellipsis,
      fontSize: fontSize ?? 15,
      fontFamily: "Poppins-Bold",
      color: color ?? Colors.black,
    );
  }
}