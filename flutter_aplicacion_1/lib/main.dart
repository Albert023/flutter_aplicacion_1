import 'package:flutter/material.dart';
import 'layouts/pagina_inicio.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Inicio(),

      debugShowCheckedModeBanner: false,

      title: "Control de finanzas",

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF121212),

        primaryColor: Colors.tealAccent,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),

      //  initialRoute: "/",
      //  routes: {
      // "/" : (context) =>Inicio()
      //},
    );
  }
}
