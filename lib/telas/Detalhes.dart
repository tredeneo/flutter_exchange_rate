import 'package:flutter/material.dart';
import 'package:flutter_exchange_rate/api/moedas.dart';

class Detalhes extends StatefulWidget {
  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  @override
  Widget build(BuildContext context) {
    final Moedas moeda = ModalRoute.of(context).settings.arguments;
    return Container(
      child: ListTile(
        title: Text("${moeda.rates.values}"),
        subtitle: Text("teste"),
      ),
    );
  }
}
