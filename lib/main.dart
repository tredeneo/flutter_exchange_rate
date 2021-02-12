import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
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
            brightness: Brightness.light),
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.system,
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
  String valoresSalida;
  DateTime selectedDate;
  //CalendarController calendario;
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    valoresSalida = nomesDisponiveis[1];
    futureMoedas = pegarConversion(valoresSalida, selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("conversor")),
        body: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: DateTimeField(
                  decoration:
                      const InputDecoration(hintText: 'selecione a data'),
                  selectedDate: selectedDate,
                  dateFormat: DateFormat.yMd(),
                  lastDate: DateTime.now(),
                  onDateSelected: (DateTime value) {
                    setState(() {
                      selectedDate = value;
                      futureMoedas =
                          pegarConversion(valoresSalida, selectedDate);
                    });
                  },
                  mode: DateTimeFieldPickerMode.date,
                ),
              ),
              Center(
                child: Container(
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
                                    valoresSalida, selectedDate);
                              });
                            },
                            items: nomesDisponiveis
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList())),
                  ],
                )),
              ),
              Container(
                alignment: Alignment.center,
                //width: MediaQuery.of(context).size.width / 4,
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'quantidade',
                  ),
                ),
              ),
              FutureBuilder(
                  future: futureMoedas,
                  builder: (context, AsyncSnapshot<Moedas> snapshot) {
                    if (snapshot.hasData) {
                      return buildListView(snapshot);
                    } else {
                      return LinearProgressIndicator();
                    }
                  })
            ]));
  }

  ListView buildListView(AsyncSnapshot<Moedas> snapshot) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: snapshot.data.rates.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Center(
                child: Text(snapshot.data.rates.keys.elementAt(index)),
              ),
              subtitle: Center(
                child: Text(
                    "${(1 / snapshot.data.rates.values.elementAt(index)).toStringAsFixed(3)}"),
              ));
        });
  }
}
