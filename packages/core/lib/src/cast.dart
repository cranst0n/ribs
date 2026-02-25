/// Helper function to cast the given argument to the given type. With the help
/// of type inference, this is usually cleaner to us than: `func(value as Type)`.
/// You can usually get away with: `function(cast(value))`.
@pragma('vm:prefer-inline')
@pragma('dart2js:tryInline')
A cast<A>(dynamic a) => a as A;
