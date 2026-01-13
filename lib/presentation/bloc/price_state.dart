import '../../domain/entities/asset_price.dart';

abstract class PriceState{}

class PriceInitial extends PriceState{}
class PriceLoading extends PriceState{}

class PriceLoaded extends PriceState{
  final List<AssetPrice> data;
  final bool isStale;

  PriceLoaded(this.data, this.isStale);
}

class PriceError extends PriceState{
  final String message;
  PriceError(this.message);
}