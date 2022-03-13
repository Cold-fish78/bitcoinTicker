import 'dart:convert';

import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedProperty = 'USD';
 String currentValue ='?';



  Future getData(String value) async {
    // 5292524fa54041cfe87a5e3130eba1b4  api key
    var realUrl = Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/$value?apikey=778C318B-9D9D-4B37-B008-52D9E28C527C');
    http.Response response = await http.get(realUrl);
    if(response.statusCode ==200){
      var decodedData =await jsonDecode(response.body);
      print(decodedData);
      print(decodedData['rate']);
      var val = decodedData['rate'];


      setState(()  {
        selectedProperty = value;
        currentValue=  val.toStringAsFixed(3);



      });

    } else{
      print(response.statusCode);
    }

  }


  DropdownButton<dynamic> androidDropdownButton() {
    List<DropdownMenuItem> dropdownitems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownitems.add(newItem);
    }

    return DropdownButton<dynamic>(
      value: selectedProperty,
      items: dropdownitems,
      onChanged: (value) async {
        await getData( value);
      },
    );
  }

  CupertinoPicker iosPicker(){
    List<Widget> texts = [];
    for (int i = 0; i < currenciesList.length; i++) {
      texts.add(Text(currenciesList[i]));
      print(currenciesList[i]);
    }


  return  CupertinoPicker(
      itemExtent: 32.0,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: texts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC =$currentValue $selectedProperty ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}
