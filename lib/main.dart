import 'package:flutter/material.dart';
import 'api/moedas.dart';

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
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  Future<Moedas> futureMoedas;
  void initState() {
    super.initState();
    futureMoedas = pegarConversion("USD");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title:Row( Text("conversor")),
        body: Container(
            child: Center(
          child: FutureBuilder<Moedas>(
            future: futureMoedas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text("${snapshot.data.rates.values}",
                    style: TextStyle(fontSize: 30));
              } else if (snapshot.hasError) {
                return Text(
                  "${snapshot.error}",
                  style: TextStyle(fontSize: 30),
                );
              }
              return CircularProgressIndicator();
            },
          ),
        )));
  }
}
