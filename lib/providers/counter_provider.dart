import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerCounter = AutoDisposeNotifierProvider<CounterNotifier, int>(CounterNotifier.new);

class CounterNotifier extends AutoDisposeNotifier<int> {
  final int initialValue = 10;

  @override
  int build() => initialValue;
  void increment() => state++;
  void decrement() => state--;
}