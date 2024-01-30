part of '../imap.dart';

class IHashMapBuilder<K, V> {
  IMapBuilder<K, V> addAll(IterableOnce<(K, V)> elems) {
    throw UnimplementedError('IHashMapBuilder.addAll');
  }

  IMapBuilder<K, V> addOne((K, V) keyValue) {
    throw UnimplementedError('IHashMapBuilder.addOne');
  }

  void clear() {
    throw UnimplementedError('IHashMapBuilder.clear');
  }

  IMap<K, V> result() => throw UnimplementedError('IHashMapBuilder.result');
}
