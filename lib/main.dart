import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_watch/data/repository/price_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:price_watch/presentation/bloc/price_bloc.dart';
import 'package:price_watch/presentation/screens/price_watch_screen.dart';
import 'data/api/coingecko_api.dart';

import 'package:http/http.dart' as http;

void main() {
  final api = CoinGeckoApi(http.Client());
  final repository = RepositoryImpl(api);

  runApp(
    BlocProvider(
      create: (_) => PriceBloc(repository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PriceWatchPage(),
    );
  }
}
