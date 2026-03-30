---
sidebar_position: 3
---


# Set

A **set** is an unordered collection of unique elements. In ribs, all set
types mix in `RSet<A>`, which extends `RIterable<A>` and adds a single
foundational operation: `contains(elem)`.

This page covers the four set types in ribs — two immutable and two mutable —
along with when to reach for each.

---

## The Set Hierarchy

```
RSet<A>             unordered, unique elements; adds contains(elem)
  ├── ISet<A>        immutable hash set; full set-algebra operations
  └── MSet<A>        mutable hash set; in-place add/remove

RMultiSet<A>        unordered, duplicate elements tracked by count
  ├── IMultiSet<A>   immutable multiset
  └── MMultiSet<A>   mutable multiset
```

`RSet` and `RMultiSet` are separate hierarchies. A multiset is not a set —
it allows the same element to appear more than once.

---

## ISet

`ISet<A>` is a persistent immutable hash set backed by a CHAMP
(Compressed Hash-Array Mapped Prefix-tree) trie. All operations return a
new `ISet`; the original is never modified.

**Structural properties:**
- `contains` — effectively O(1)
- `incl` / `excl` (and `operator +` / `-`) — effectively O(1)
- `union` / `diff` / `intersect` — O(n)
- Unordered — iteration order reflects hash values, not insertion order

**Construction:**

<<< @/../snippets/lib/src/core/sets.dart#iset-construction

**Core operations:**

<<< @/../snippets/lib/src/core/sets.dart#iset-ops

**Use when:**
- You need fast membership testing (`contains`) and can tolerate no ordering
- You want automatic deduplication of elements
- The collection will be used in set-algebra operations (union, intersection, difference)

**Avoid when:**
- Order of elements matters — use `IVector` or `IList` instead
- Duplicate elements are meaningful — use `IMultiSet` instead

---

## MSet

`MSet<A>` is a mutable hash set. `add` and `remove` modify the set in place
and return a `bool` indicating whether the operation changed anything. This
is the key API difference from `ISet`, where `+` and `-` return a new set.

<<< @/../snippets/lib/src/core/sets.dart#mset-ops

**Use when:**
- You are building a set incrementally in a local scope and immutability
  is not required
- You need the boolean result of `add`/`remove` to know whether membership
  actually changed

**Avoid when:**
- The set will be shared across call sites or stored in state — use `ISet`
  to prevent unexpected mutation

---

## IMultiSet

A **multiset** (also called a *bag*) is like a set, but each element can
appear more than once. `IMultiSet<A>` tracks how many times each element
has been added and exposes this as the `occurrences` map.

**Construction:**

<<< @/../snippets/lib/src/core/sets.dart#imultiset-construction

**Core operations:**

<<< @/../snippets/lib/src/core/sets.dart#imultiset-ops

**Key distinctions from `ISet`:**
- `operator +` adds one *occurrence* of an element, not the element itself.
  If `'a'` already has a count of 2, `ms + 'a'` produces a multiset where
  `'a'` has a count of 3.
- `operator -` removes one occurrence. If the count reaches zero, the element
  is no longer `contains`-able.
- `get(elem)` returns the count (0 if absent), rather than a boolean.
- `occurrences` provides the full `IMap<A, int>` of counts, which can be
  iterated, filtered, and transformed like any other map.

**Use when:**
- You need to count how many times each element appears (e.g. word frequency,
  vote tallies, inventory quantities)
- You want to add and remove individual occurrences without managing a
  separate `IMap<A, int>` yourself

---

## Choosing a Set Type

| Requirement | Recommended type |
|-------------|-----------------|
| Immutable, unique elements, set algebra | `ISet` |
| Mutable, local accumulation | `MSet` |
| Count occurrences of each element | `IMultiSet` |
| Mutable occurrence counting | `MMultiSet` |
