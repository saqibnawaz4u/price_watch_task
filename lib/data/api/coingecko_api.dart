import 'dart:convert';

import 'package:http/http.dart' as http;

class CoinGeckoApi {
  final http.Client client;

  CoinGeckoApi(this.client);

  Future<Map<String, dynamic>> fetchPrices() async {
    final response = await client.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?vs_currencies=usd&ids=bitcoin&names=Bitcoin&symbols=btc',
      ),
    );
    return json.decode(response.body);
  }
}
