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
  String cryptoValue = '??';
  String? fiatCurrency = 'USD';
  

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
      value: fiatCurrency,
      items: dropDownList,
      onChanged: ((value) {
        setState(() {
          fiatCurrency = value;
          fetchData();
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
    //value had to be updated into a Map to store the values of all three cryptocurrencies.
  Map<String, String> coinValues = {};
  //7: Figure out a way of displaying a '?' on screen while we're waiting for the price data to come back. First we have to create a variable to keep track of when we're waiting on the request to complete.
  bool isWaiting = false;
  void fetchData() async {
//7: Second, we set it to true when we initiate the request for prices.
    isWaiting = true;
    try {
      var data = await NetWork().getPrice(fiatCurrency!);
       //7. Third, as soon the above line of code completes, we now have the data and no longer need to wait. So we can set isWaiting to false.
      isWaiting = false;
      setState(() {
        cryptoValue = data;
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

   //For bonus points, create a method that loops through the cryptoList and generates a CryptoCard for each. Call makeCards() in the build() method instead of the Column with 3 CryptoCards.
 Column makeCards() {
   List<CryptoCard> cryptoCards = [];
   for (String crypto in cryptoCoins) {
     cryptoCards.add(
       CryptoCard(
         cryptoCurrency: crypto,
         selectedCurrency: fiatCurrency,
         value: isWaiting ? '?' : coinValues[crypto],
       ),
     );
   }
   return Column(
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: cryptoCards,
   );
 }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //3: You'll need to use a Column Widget to contain the three CryptoCards.
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CryptoCard(
                cryptoCurrency: 'BTC',
                //7. Finally, we use a ternary operator to check if we are waiting and if so, we'll display a '?' otherwise we'll show the actual price data.
                value: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: fiatCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'ETH',
                value: isWaiting ? '?' : coinValues['ETH'],
                selectedCurrency: fiatCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'LTC',
                value: isWaiting ? '?' : coinValues['LTC'],
                selectedCurrency: fiatCurrency,
              ),
            ],
          ),
              
              Container(
                  color: Colors.blueAccent,
                  height: 100,
                  alignment: Alignment.center,
                  child: Platform.isIOS ? cupertinoPicker() : dropDownBtn()),
            ],
          ),
        ),
      
    );
  }
}


//1: Refactor this Padding Widget into a separate Stateless Widget called CryptoCard, so we can create 3 of them, one for each cryptocurrency.
class CryptoCard extends StatelessWidget {
  //2: You'll need to able to pass the selectedCurrency, value and cryptoCurrency to the constructor of this CryptoCard Widget.
  const CryptoCard({super.key, 
    this.value,
    this.selectedCurrency,
    this.cryptoCurrency,
  });

  final String? value;
  final String? selectedCurrency;
  final String? cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}