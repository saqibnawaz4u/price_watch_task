import 'package:price_watch/data/api/coingecko_api.dart';
import 'package:price_watch/domain/entities/asset_price.dart';
import 'package:price_watch/domain/repository_interface/price_respo.dart';

class RepositoryImpl implements PriceRepository {
  final CoinGeckoApi api;
  List<AssetPrice>? _cache;

  RepositoryImpl(this.api);

  void cachePrices(List<AssetPrice> prices) {
    _cache = prices;
  }

  Future<List<AssetPrice>> fetchPrices() async {
    final data = await api.fetchPrices();
    final prices = data.entries.map((e) {
      return AssetPrice(id: e.key, price: e.value['usd'].toDouble());
    }).toList();
    cachePrices(prices);
    return prices;
  }

  @override
  List<AssetPrice>? getCachedPrices() => _cache;
}
