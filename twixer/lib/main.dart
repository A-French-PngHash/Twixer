import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:twixer/DataLogic/auth.dart';
import 'package:twixer/Views/navigation.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigation(
        connection: Connection("titouan", false, username: "titouan"),
      ),
      theme: ThemeData.light(useMaterial3: true).copyWith(
          textTheme: GoogleFonts.quicksandTextTheme(
            TextTheme().copyWith(
                bodyLarge: TextStyle(fontSize: 19),
                labelMedium: TextStyle(
                  color: Color.fromARGB(255, 85, 99, 110),
                ),
                headlineSmall: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          ).apply(bodyColor: Colors.black, displayColor: Colors.black),
          primaryColor: Color.fromARGB(255, 29, 161, 242),
          focusColor: Color.fromARGB(255, 29, 161, 242),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 29, 161, 242))),
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
