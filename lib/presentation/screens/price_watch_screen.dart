import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/price_bloc.dart';
import '../bloc/price_event.dart';
import '../bloc/price_state.dart';

class PriceWatchPage extends StatelessWidget {
  const PriceWatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Price Watch'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PriceBloc>().add(RefreshPrices());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _CachedFirstToggle(),
          const Divider(height: 1),
          Expanded(child: _PriceBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<PriceBloc>().add(FetchPrices());
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
class _CachedFirstToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PriceBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text(
            'Cached first',
            style: TextStyle(fontSize: 16),
          ),
          const Spacer(),
          Switch(
            value: bloc.cachedFirst,
            onChanged: (_) {
              bloc.add(ToggleCachedFirst());
            },
          ),
        ],
      ),
    );
  }
}
class _PriceBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PriceBloc, PriceState>(
      builder: (context, state) {
        if (state is PriceInitial) {
          return const Center(
            child: Text('Press download to fetch prices'),
          );
        }

        if (state is PriceLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is PriceError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is PriceLoaded) {
          return Column(
            children: [
              if (state.isStale)
                _StaleBanner(),
              Expanded(
                child: ListView.separated(
                  itemCount: state.data.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final asset = state.data[index];
                    return ListTile(
                      title: Text(
                        asset.id.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '\$${asset.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
class _StaleBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange.withOpacity(0.15),
      padding: const EdgeInsets.all(8),
      child: const Text(
        'Showing cached data (may be outdated)',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.orange),
      ),
    );
  }
}

