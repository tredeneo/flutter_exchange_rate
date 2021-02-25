import 'package:flutter/material.dart';
import 'package:flutter_exchange_rate/telas/Detalhes.dart';
import 'telas/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'conversor de moedas',
      theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      routes: {
        "/": (context) => HomePage(),
        "/detalhe": (context) => Detalhes()
      },
    );
  }
}
