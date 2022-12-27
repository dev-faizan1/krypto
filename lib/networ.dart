import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class NetWork {
  Future getPrice() async {
    String url =
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin%2Clitecoin&vs_currencies=usd';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var decodedData = jsonDecode(response.body);
      var lastPrice = decodedData['bitcoin']['usd'];
      return lastPrice;
    } else {
      log(response.statusCode.toString());
      throw 'Problem with get request';
    }
  }
  
}
