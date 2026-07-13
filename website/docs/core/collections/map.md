---
sidebar_position: 4
---


# Map

A **map** is a collection of key–value pairs where each key is unique. In ribs,
all map types mix in `RMap<K, V>`, which extends `RIterable<(K, V)>` — maps
are iterable as `(key, value)` tuples — and adds foundational lookup operations:
`get(key)`, `contains(key)`, `keys`, and `values`.

This page covers the four map types in ribs — two regular maps (one immutable,
one mutable) and two multi-value maps — along with when to reach for each.

---

## The Map Hierarchy

```
RMap<K, V>              key–value; iterable as (K, V) tuples; adds get/contains/keys/values
  ├── IMap<K, V>        immutable hash map; structural update returns a new IMap
  └── MMap<K, V>        mutable hash map; in-place put/remove

RMultiDict<K, V>        each key maps to a *set* of values
  ├── IMultiDict<K, V>  immutable multi-value map
  └── MMultiDict<K, V>  mutable multi-value map
```

`RMap` and `RMultiDict` are separate hierarchies. A multidict is not a map —
each key can have multiple distinct values.

---

## IMap

`IMap<K, V>` is a persistent immutable hash map backed by a CHAMP
(Compressed Hash-Array Mapped Prefix-tree) trie. All structural operations
return a new `IMap`; the original is never modified.

**Structural properties:**
- `get` / `contains` — effectively O(1)
- `operator +` / `-` (add/remove one entry) — effectively O(1)
- `mapValues` / `transform` — O(n)
- Unordered — iteration order reflects hash values, not insertion order

**Construction:**

<<< @/../snippets/lib/src/core/maps.dart#imap-construction

For incremental construction, use `IMap.builder<K, V>()`. Call `addOne` with a
`(K, V)` tuple for each entry, then `result()` to produce the final immutable map:

<<< @/../snippets/lib/src/core/maps.dart#imap-builder

**Core operations:**

<<< @/../snippets/lib/src/core/maps.dart#imap-ops

**Key distinctions:**
- `get(key)` returns `Option<V>` — never throws, never returns `null`.
- `operator []` throws if the key is absent; use `get` or `getOrElse` in
  production code.
- `operator +` takes a `(K, V)` tuple. If the key already exists, the old
  value is replaced.
- `operator -` takes a key and returns a new map with that key removed. If
  the key is absent, the map is returned unchanged.
- `updatedWith(key, fn)` receives the current value as `Option<V>` and can
  insert, update, or remove an entry in a single step.

**Use when:**
- You need fast key lookup and can tolerate no ordering
- The map is shared across call sites or stored in state — immutability
  prevents unexpected mutation
- You want structural updates without managing copies manually

**Avoid when:**
- You are building a map incrementally in a local scope where immutability
  is not required — use `MMap` instead
- Each key should map to multiple values — use `IMultiDict`

---

## MMap

`MMap<K, V>` is a mutable hash map. Operations like `put` and `remove` modify
the map in place and return `Option<V>` indicating the previous value. The
assignment operator `[]=` mutates silently, matching Dart's own `Map` API.

<<< @/../snippets/lib/src/core/maps.dart#mmap-ops

**Key distinctions from `IMap`:**
- `put(key, val)` returns `Some(oldValue)` if the key existed, `None` if it
  was newly inserted — useful when you need to know whether an insert was
  actually an update.
- `remove(key)` returns `Some(removedValue)` or `None` if absent.
- `getOrElseUpdate(key, fn)` atomically inserts a default and returns it if
  the key is missing — useful for memoisation or lazy initialisation.
- `updateWith(key, fn)` receives `Option<V>` and can insert, update, or
  delete an entry in one call; returning `None` removes the key.
- `filterInPlace(p)` removes all entries that do not satisfy `p`, mutating
  the map in place.

**Use when:**
- Building a map incrementally in a local scope (e.g. grouping, counting)
- The return value of `put`/`remove` matters to the algorithm
- You need `getOrElseUpdate` for lazy initialisation or memoisation

**Avoid when:**
- The map will be shared across call sites or stored in state — use `IMap`
  to prevent unexpected mutation

---

## IMultiDict

`IMultiDict<K, V>` maps each key to a **set** of values. Unlike `IMap`, a
single key can have multiple distinct values associated with it.

Internally, it is backed by an `IMap<K, ISet<V>>`, which is exposed via the
`sets` property (typed as `RMap<K, ISet<V>>`). This means that adding the same `(key, value)` pair twice is
idempotent — duplicates within a key's value set are ignored.

**Construction:**

<<< @/../snippets/lib/src/core/maps.dart#imultidict-construction

**Core operations:**

<<< @/../snippets/lib/src/core/maps.dart#imultidict-ops

**Key distinctions from `IMap`:**
- `get(key)` returns `RSet<V>` — the full set of values for that key —
  rather than `Option<V>`. An absent key returns an empty set.
- `operator +` takes a `(K, V)` tuple and adds one entry to the key's value
  set. Adding an already-present entry is a no-op.
- `containsEntry(entry)` takes a `(K, V)` tuple and checks for an exact
  key–value pair.
- `sets` exposes the full backing structure as an `RMap<K, ISet<V>>`, which
  can be iterated, filtered, and transformed like any other map.

**Use when:**
- One key naturally corresponds to multiple values (e.g. tags on documents,
  roles per user, HTTP headers with multiple values)
- You want automatic deduplication of values under each key

**Avoid when:**
- A key should have exactly one value — use `IMap`
- You need mutable in-place updates — use `MMultiDict`

---

## MMultiDict

`MMultiDict<K, V>` is the mutable counterpart to `IMultiDict`. The same
key-to-set semantics apply, but `add` mutates in place and returns `this` for
chaining.

Use the same construction functions as `IMultiDict`, substituting
`MMultiDict.empty<K, V>()` or `mmultidict(iterable)` as the entry point.
Call `add(key, val)` or `operator +` to add entries and `get(key)` to retrieve
the value set.

**Use when:**
- You are building up a multi-value map incrementally in a local scope

**Avoid when:**
- The map will be shared or stored in state — use `IMultiDict`

---

## Choosing a Map Type

| Requirement | Recommended type |
|-------------|-----------------|
| Immutable, one value per key | `IMap` |
| Mutable, local accumulation or counting | `MMap` |
| Immutable, multiple values per key | `IMultiDict` |
| Mutable multi-value accumulation | `MMultiDict` |
