import 'package:flutter/material.dart';
import 'package:twixer/DataLogic/actions.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/Views/auth.dart';
import 'package:twixer/Views/navigation.dart';
import 'package:twixer/config.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: AuthView(
          logout: false,
        ),
      ),
      theme: ThemeData(fontFamily: "Quicksand", brightness: Brightness.light, useMaterial3: true).copyWith(
          textTheme: ThemeData(fontFamily: "Quicksand", brightness: Brightness.light, useMaterial3: true)
              .textTheme
              .copyWith(
                bodyLarge: TextStyle(fontSize: 19),
                labelMedium: TextStyle(
                  color: Color.fromARGB(255, 85, 99, 110),
                ),
                headlineSmall: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              )
              .apply(bodyColor: Colors.black, displayColor: Colors.black, fontFamily: "Quicksand"),
          primaryColor: BLUE,
          focusColor: BLUE,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.light(primary: BLUE)),
    );
  }
}

MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;

  final Map<int, Color> shades = {
    50: Color.fromRGBO(red, green, blue, .1),
    100: Color.fromRGBO(red, green, blue, .2),
    200: Color.fromRGBO(red, green, blue, .3),
    300: Color.fromRGBO(red, green, blue, .4),
    400: Color.fromRGBO(red, green, blue, .5),
    500: Color.fromRGBO(red, green, blue, .6),
    600: Color.fromRGBO(red, green, blue, .7),
    700: Color.fromRGBO(red, green, blue, .8),
    800: Color.fromRGBO(red, green, blue, .9),
    900: Color.fromRGBO(red, green, blue, 1),
  };

  return MaterialColor(color.value, shades);
}

ButtonStyle twixerIconButtonStyle = IconButton.styleFrom(
    backgroundColor: Colors.black.withOpacity(0.4),
    minimumSize: Size.zero,
    padding: EdgeInsets.all(6),
    foregroundColor: Colors.white);
