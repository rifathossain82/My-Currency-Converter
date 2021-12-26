import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Api_client{
  final Uri currency_api=Uri.https("free.currconv.com","/api/v7/currencies", {"apiKey":"0a887d855a68b6afb8a6"});
  Future<List<String>> getCurrensies() async{
    final response= await http.get(currency_api);
    if(response.statusCode==200){
      var body=jsonDecode(response.body);
      var list=body['results'];
      List<String> currensies=(list.keys).toList();

      return currensies;
    }
    else{
      throw Exception('Failed to connect to API.');
    }
  }


  Future<double> getRate(String from, String to) async{
    final Uri rate_uri=Uri.https("free.currconv.com","/api/v7/convert",
      {"apiKey":"0a887d855a68b6afb8a6",
        "q":"${from}_${to}",
        "compact": "ultra"
      },
    );
    final response= await http.get(rate_uri);
    if(response.statusCode==200){
      var body=jsonDecode(response.body);
      return body["${from}_${to}"];
    }
    else{
      throw Exception('Failed to connect to API.');
    }
  }

  Future<double> getcurrentRate_Default(date) async{
    //final Uri rate_uri=Uri.https(Uri.p);
    final response= await http.get(Uri.parse('https://free.currconv.com/api/v7/convert?q=USD_BDT&compact=ultra&date=${date}&apiKey=0a887d855a68b6afb8a6'));
    if(response.statusCode==200){
      var body=jsonDecode(response.body);
      return body["USD_BDT"][date];
    }
    else{
      throw Exception('Failed to connect to API.');
    }
  }


  Future<List<String>> getsymbol() async{
    final response= await http.get(currency_api);
    if(response.statusCode==200){
      var body=jsonDecode(response.body);
      var list=body['results'];
      List<String> currensies=(list.keys).toList();
      List<String> symbol=[];
      for(var i in currensies){
        symbol.add(body['results'][i]['currencySymbol']);
      }
      print(symbol);
      return symbol;
    }
    else{
      throw Exception('Failed to connect to API.');
    }
  }   ///to find symbol of currecy
}