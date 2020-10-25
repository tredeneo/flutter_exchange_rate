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
            brightness: Brightness.dark),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

var tema;

class HomePageState extends State<HomePage> {
  Future<Moedas> futureMoedas;
  String dropdownValue;
  void initState() {
    super.initState();
    dropdownValue = nomes_disponiveis[0];
    futureMoedas = pegarConversion("dolar");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("conversor")),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
              DropdownButton<String>(
                  value: dropdownValue,
                  style: TextStyle(),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      futureMoedas = pegarConversion(dropdownValue);
                    });
                  },
                  items: nomes_disponiveis
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList()),
              Center(
                child: FutureBuilder<Moedas>(
                  future: futureMoedas,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                          "${dropdownValue}: ${snapshot.data.rates.values}",
                          style: TextStyle(fontSize: 30));
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ])));
  }
}
