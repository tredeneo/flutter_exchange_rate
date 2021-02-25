import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../api/moedas.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  Future<Moedas> futureMoedas;
  String valoresSalida;
  DateTime selectedDate;
  int quantidade;
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
        shrinkWrap: true,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              child: DateTimeField(
                decoration: const InputDecoration(hintText: 'selecione a data'),
                selectedDate: selectedDate,
                dateFormat: DateFormat.yMd(),
                lastDate: DateTime.now(),
                onDateSelected: (DateTime value) {
                  setState(
                    () {
                      selectedDate = value;
                      futureMoedas =
                          pegarConversion(valoresSalida, selectedDate);
                    },
                  );
                },
                mode: DateTimeFieldPickerMode.date,
              ),
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
                          setState(
                            () {
                              valoresSalida = newValue;
                              futureMoedas =
                                  pegarConversion(valoresSalida, selectedDate);
                            },
                          );
                        },
                        items: nomesDisponiveis.map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList()),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              child: TextField(
                //keyboardType: TextInputType.number,
                maxLength: 10,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'quantidade',
                ),
                onSubmitted: (value) {
                  //quantidade = ;
                },
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
            },
          )
        ],
      ),
    );
  }

  ListView buildListView(AsyncSnapshot<Moedas> snapshot) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: snapshot.data.rates.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Center(
            child: Text(snapshot.data.rates.keys.elementAt(index)),
          ),
          subtitle: Center(
            child: Text(
                "${(1 / snapshot.data.rates.values.elementAt(index)).toStringAsFixed(3)}"),
          ),
          onTap: () {
            Navigator.pushReplacementNamed(context, "/detalhe",
                arguments: snapshot);
          },
        );
      },
    );
  }
}
