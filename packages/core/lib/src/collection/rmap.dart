import 'package:ribs_core/ribs_core.dart';

mixin RMap<K, V> on RIterableOnce<(K, V)>, RIterable<(K, V)> {
  /// Returns the value associated with the given [key], or the [defaultValue]
  /// of this map (which could potentially throw).
  V operator [](K key) => get(key).getOrElse(() => defaultValue(key));

  /// Returns true if this map contains the key [key], false otherwise.
  bool contains(K key);

  V defaultValue(K key) => throw Exception("No such value for key: '$key'");

  /// Returns the value for the given key [key] as a [Some], or [None] if this
  /// map doesn't contain the key.
  Option<V> get(K key);

  /// Returns a [Set] of all the keys stored in the map.
  ISet<K> get keys;

  /// Returns the value for the given key [key], or [orElse] if this map doesn't
  /// contain the key.
  V getOrElse(K key, Function0<V> orElse) => get(key).getOrElse(orElse);

  /// Returns a list of all values stored in this map.
  RIterator<V> get values;

  @override
  int get hashCode => MurmurHash3.mapHash(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is RMap<K, V>) {
      return size == other.size &&
          forall((kv) => other.get(kv.$1) == Some(kv.$2));
    } else {
      return super == other;
    }
  }
}
