import 'dart:developer';

import 'package:flutter/material.dart';
import 'networ.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentPrice = '??';
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 300,
                height: 50,
                color: Colors.red,
                child: Text('BTC price in USD is $currentPrice'),
              ),
              ElevatedButton(onPressed: fetchData, child: Text('Update price')),
            ],
          ),
        ),
      ),
    );
  }
}
