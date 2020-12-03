import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
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
  String valoresEntrada, valoresSalida;
  CalendarController calendario;
  void initState() {
    super.initState();
    valoresEntrada = nomesDisponiveis[0];
    valoresSalida = nomesDisponiveis[1];
    futureMoedas = pegarConversion(valoresEntrada, valoresSalida);
    calendario = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("conversor")),
        body: Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                      child: DropdownButton<String>(
                          value: valoresSalida,
                          style: TextStyle(color: Colors.white, fontSize: 30),
                          onChanged: (String newValue) {
                            setState(() {
                              valoresSalida = newValue;
                              futureMoedas = pegarConversion(
                                  valoresEntrada, valoresSalida);
                            });
                          },
                          items: nomesDisponiveis
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList())),
                  Flexible(
                      child: DropdownButton(
                    value: valoresEntrada,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                    onChanged: (String newValue) {
                      setState(() {
                        valoresEntrada = newValue;
                        futureMoedas =
                            pegarConversion(valoresEntrada, valoresSalida);
                      });
                    },
                    items: nomesDisponiveis.map((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                  )),
                  Flexible(
                      child: TableCalendar(
                    startDay: DateTime.now(),
                    calendarController: calendario,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                  ))
                ],
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: TextField(
                      maxLength: 10,
                      maxLengthEnforced: true,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Passwodsadrd',
                      ),
                    ),
                  ),
                  Flexible(child: Text("teste"))
                ],
              ),
              Center(
                child: FutureBuilder<Moedas>(
                  future: futureMoedas,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("$valoresSalida",
                              style: TextStyle(fontSize: 30)),
                          Icon(Icons.arrow_forward_sharp),
                          Text(valoresEntrada, style: TextStyle(fontSize: 30)),
                          Text(":${snapshot.data.rates.values}",
                              style: TextStyle(fontSize: 30)),
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ])));
  }
}
