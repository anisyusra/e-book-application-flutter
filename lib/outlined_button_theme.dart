import 'package:flutter/material.dart';
import 'package:test1/colors.dart';
import 'package:test1/sizes.dart';

class TOutlinedButtonTheme{
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
     style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black),
                      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
                    ), 
  );

    static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
       style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      foregroundColor: tWhiteColor,
                      side: BorderSide(color: tWhiteColor),
                      padding: EdgeInsets.symmetric(vertical: tButtonHeight),
                    ), 
    );

}