# ribs_optics

`ribs_optics` provides a powerful set of tools for inspecting and transforming complex, immutable data structures in a type-safe and composable way. It implements common functional programming "optics" like Lenses, Prisms, and Isos.

Optics are particularly useful when you need to update a nested field in a deep data structure without losing the benefits of immutability.

## Key Optics

- **Lens**: Zoms into a specific field of a product type (e.g., a Class). Supports both `get` and `set`.
- **Prism**: Zooms into a specific case of a sum type (e.g., a sealed class or enum). Useful for narrowing types.
- **Optional**: Like a Lens, but for a field that may or may not exist.
- **Iso**: A lossless, reversible transformation between two types.
- **Getter**: A read-only view into a structure.
- **Setter**: A write-only transformation for a structure.

## Why ribs_optics?

Immutable data is great for safety and predictability, but updating nested fields can lead to cumbersome "copy with" boilerplate:

```dart
// Without Optics
final updatedUser = user.copyWith(
  address: user.address.copyWith(
    street: user.address.street.copyWith(name: "New Street")
  )
);
```

With `ribs_optics`, you can define your relationships once and compose them:

```dart
// Define Lenses
final addressL = Lens<User, Address>((u) => u.address, (a) => (u) => u.copyWith(address: a));
final streetL = Lens<Address, String>((a) => a.street, (s) => (a) => a.copyWith(street: s));

// Compose them
final userStreetL = addressL.andThenL(streetL);

// Update deeply nested data cleanly
final updatedUser = userStreetL.replace("New Street")(user);
```

## Quick Examples

### Composing Lenses
Lenses can be composed to reach deep into structures.

```dart
final cityL = addressL.andThenL(Lens<Address, String>((a) => a.city, (c) => (a) => a.copyWith(city: c)));
final updated = cityL.modify((city) => city.toUpperCase())(user);
```

### Using Prisms for Sum Types
Prisms allow you to work with specific subtypes.

```dart
// Assuming a sealed class Shape with a Circle case
final circleP = Prism<Shape, Circle>(
  (s) => s is Circle ? s.asRight() : s.asLeft(),
  (c) => c
);

final radiusL = Lens<Circle, double>((c) => c.radius, (r) => (c) => Circle(r));

// Compose Prism and Lens
final shapeRadiusO = circleP.andThenO(radiusL);

// Only updates if the shape is actually a Circle
final biggerShape = shapeRadiusO.modify((r) => r * 2)(someShape);
```