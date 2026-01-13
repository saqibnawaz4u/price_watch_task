import 'package:price_watch/domain/entities/asset_price.dart';

abstract class PriceRepository{
  Future<List<AssetPrice>> fetchPrices();
  List<AssetPrice>? getCachedPrices();
  void cachePrices(List<AssetPrice> prices);
}