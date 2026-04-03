/// IEC binary prefix multipliers (powers of 1024).
///
/// These are used as [conversionFactor] values for binary-prefixed
/// information units (kibibytes, mebibytes, etc.) throughout ribs_units,
/// as distinct from the decimal [MetricSystem] prefixes.
final class BinarySystem {
  BinarySystem._();

  /// 2¹⁰ = 1 024 (kibi).
  static const Kilo = 1024.0;

  /// 2²⁰ = 1 048 576 (mebi).
  static const Mega = 1024.0 * Kilo;

  /// 2³⁰ ≈ 1.07 × 10⁹ (gibi).
  static const Giga = 1024.0 * Mega;

  /// 2⁴⁰ ≈ 1.10 × 10¹² (tebi).
  static const Tera = 1024.0 * Giga;

  /// 2⁵⁰ ≈ 1.13 × 10¹⁵ (pebi).
  static const Peta = 1024.0 * Tera;

  /// 2⁶⁰ ≈ 1.15 × 10¹⁸ (exbi).
  static const Exa = 1024.0 * Peta;

  /// 2⁷⁰ ≈ 1.18 × 10²¹ (zebi).
  static const Zetta = 1024.0 * Exa;

  /// 2⁸⁰ ≈ 1.21 × 10²⁴ (yobi).
  static const Yotta = 1024.0 * Zetta;
}
