import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

// --white:#fff;
//   --black:#111;
//   --blue:#3a80e9;
//   --grey:#888;
//   --darkgrey:#1b1b1b;
//   --green: #61c96f;
//   --red:#f94141;


class ThemeClass{
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light().copyWith(
      primary: HexColor('#3a80e9'),
      onPrimary: HexColor('#ffffff'),
      background: HexColor('#f2f2f2'),
      onBackground: HexColor('#111111')
    ),
    fontFamily: 'Inter',
  );
  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark().copyWith(
      primary: HexColor('#3a80e9'),
      onPrimary: HexColor('#ffffff'),
      // background: HexColor('#11111'),
      // onBackground: HexColor('#ffffff')
    ),
    fontFamily: 'Inter',
  );

  static var red = HexColor('#f94141');
  static var green = HexColor('#61c96f');
  static var darkgrey = HexColor('#1b1b1b');
  static var grey = HexColor('#888888');
}

