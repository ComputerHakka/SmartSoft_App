import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

const largeTxtSize = 26.0;
const mediumTextSize = 20.0;
const bodyTextSize = 16.0;

const String fontNameTitle = 'Ubuntu';

Color kPrimaryColor = HexColor('1E1E1E');
Color kSecondaryColor = HexColor('320F14');
Color kBackgroundColor = HexColor('FFFFFF');
Color kAccentColor = HexColor('FC734D');
Color kCardColor = Colors.black45;

ThemeData appTheme() => ThemeData(
      primaryColor: kPrimaryColor,
      fontFamily: 'Ubuntu',
      useMaterial3: true,
      cardColor: kCardColor,
      buttonTheme: ButtonThemeData(buttonColor: kAccentColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(kAccentColor),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          overlayColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 255, 171, 145)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStatePropertyAll(kAccentColor),
          overlayColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 253, 192, 173)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: kAccentColor),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(width: 0.8, color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(width: 0.8, color: kPrimaryColor),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: kAccentColor,
        activeTickMarkColor: kAccentColor,
        valueIndicatorColor: kAccentColor,
        thumbColor: kAccentColor,
      ),
    );
