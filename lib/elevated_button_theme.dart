import 'package:flutter/material.dart';
import 'package:test1/colors.dart';
import 'package:test1/sizes.dart';

class TElevatedButtonTheme{
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(),
                      foregroundColor: tWhiteColor,
                      backgroundColor: tSecondaryColor,
                      side: BorderSide(color: tSecondaryColor),
                      padding: EdgeInsets.symmetric(vertical: tButtonHeight)
                    ),
  );

    static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(),
                      foregroundColor: tSecondaryColor,
                      backgroundColor: tWhiteColor,
                      side: BorderSide(color: tWhiteColor),
                      padding: EdgeInsets.symmetric(vertical: tButtonHeight)
                    ),
    );

}