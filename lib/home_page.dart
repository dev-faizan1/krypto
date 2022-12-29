import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'networ.dart';
import 'coindata.dart';
import 'dart:io' show Platform;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentPrice = '??';
  String? selectedCurrency = 'USD';

  //DropDownBtn
  DropdownButton dropDownBtn() {
    List<DropdownMenuItem<String>> dropDownList = [];

    for (String currency in currencies) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropDownList.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownList,
      onChanged: ((value) {
        setState(() {
          selectedCurrency = value;
        });
      }),
    );
  }

  //CupertinoPicker
  CupertinoPicker cupertinoPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currencies) {
      var item = Text(currency);
      pickerItems.add(item);
    }

    return CupertinoPicker(
      itemExtent: 30,
      onSelectedItemChanged: (selectedIndex) {},
      children: pickerItems,
    );
  }

  

  void fetchData() async {
    try {
      double data = await NetWork().getPrice();
      setState(() {
        currentPrice = data.toString();
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                width: 300,
                height: 50,
                color: Colors.red,
                child: Text('BTC price in USD is $currentPrice'),
              ),
              Container(
                  color: Colors.blueAccent,
                  height: 100,
                  alignment: Alignment.center,
                  child: Platform.isIOS? cupertinoPicker():dropDownBtn()),
            ],
          ),
        ),
      ),
    );
  }
}
