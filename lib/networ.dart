import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:krypto/coindata.dart';

const String publicKey = 'YzJkMjJmMjNjMjM5NDBiOTg5NDY4YmIyMDEzNTIwMDQ';

class NetWork {
  Future getPrice(String fiatCurrency) async {
    Map<String, String> cryptoPrices = {};
    for (String crypto in cryptoCoins) {
      String url =
          'https://apiv2.bitcoinaverage.com/indices/global/ticker/$crypto$fiatCurrency';
      http.Response response =
          await http.get(Uri.parse(url), headers: {'x-ba-key': publicKey});
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        var lastPrice = decodedData['last'];
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        log(response.statusCode.toString());
        throw 'Problem with get request';
      }
    }
    return cryptoPrices;
  }
}
