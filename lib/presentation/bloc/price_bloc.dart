import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_watch/presentation/bloc/price_event.dart';
import 'package:price_watch/presentation/bloc/price_state.dart';

import '../../domain/repository_interface/price_respo.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final PriceRepository repository;
  bool cachedFirst = true;

  PriceBloc(this.repository) : super(PriceInitial()) {
    on<FetchPrices>(_onFetch);
    on<RefreshPrices>(_onRefresh);
    on<ToggleCachedFirst>((_, __) => cachedFirst = !cachedFirst);
  }

  Future<void> _onFetch(
      FetchPrices event,
      Emitter<PriceState> emit,
      ) async {
    try {
      if (cachedFirst) {
        final cache = repository.getCachedPrices();
        if (cache != null) {
          emit(PriceLoaded(cache, true));
        }
      }

      emit(PriceLoading());
      final prices = await repository.fetchPrices();
      emit(PriceLoaded(prices,true));
    } catch (e) {
      emit(PriceError(e.toString()));
    }
  }

  Future<void> _onRefresh(
      RefreshPrices event,
      Emitter<PriceState> emit,
      ) async {
    add(FetchPrices());
  }
}
