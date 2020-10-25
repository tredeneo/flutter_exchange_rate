import 'package:dio/dio.dart';
import 'dart:convert';

Moedas welcomeFromJson(String str) => Moedas.fromJson(json.decode(str));
List<String> nomes_disponiveis = ["dolar", "real", "euro"];
Map disponiveis = {"dolar": "USD", "real": "BRL", "euro": "EUR"};

String welcomeToJson(Moedas data) => json.encode(data.toJson());

class Moedas {
  final Map<String, double> rates;
  final String base;
  final DateTime date;

  Moedas({this.base, this.date, this.rates});

  factory Moedas.fromJson(Map<String, dynamic> json) => Moedas(
        base: json["base"],
        rates: Map.from(json["rates"]).map((k, v) =>
            MapEntry<String, double>(k, double.parse((v).toStringAsFixed(2)))),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "base": base,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
      };
}

Future<Moedas> pegarConversion(String moeda) async {
  var response = await Dio().get(
      "https://api.exchangeratesapi.io/latest?base=${disponiveis[moeda]}&symbols=BRL");
  return Moedas.fromJson(response.data);
}
