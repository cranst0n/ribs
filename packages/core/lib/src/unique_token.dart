/// An unforgeable identity token.
///
/// Each instantiation produces a new object whose identity is distinct from
/// every other [UniqueToken]. Used internally to tag or key resources without
/// exposing a public equality contract.
final class UniqueToken {}
