/// SI metric prefix multipliers.
///
/// Each constant is the numeric factor for its prefix. For example,
/// [MetricSystem.Kilo] is `1e3`, so `5 * MetricSystem.Kilo == 5000`.
///
/// These constants are used internally as [conversionFactor] values for
/// metric-prefixed units throughout ribs_units.
final class MetricSystem {
  MetricSystem._();

  /// 10⁻²⁴ (yocto).
  static const Yocto = 1e-24;

  /// 10⁻²¹ (zepto).
  static const Zepto = 1e-21;

  /// 10⁻¹⁸ (atto).
  static const Atto = 1e-18;

  /// 10⁻¹⁵ (femto).
  static const Femto = 1e-15;

  /// 10⁻¹² (pico).
  static const Pico = 1e-12;

  /// 10⁻⁹ (nano).
  static const Nano = 1e-9;

  /// 10⁻⁶ (micro).
  static const Micro = 1e-6;

  /// 10⁻³ (milli).
  static const Milli = 1e-3;

  /// 10⁻² (centi).
  static const Centi = 1e-2;

  /// 10⁻¹ (deci).
  static const Deci = 1e-1;

  /// 10¹ (deca).
  static const Deca = 1e1;

  /// 10² (hecto).
  static const Hecto = 1e2;

  /// 10³ (kilo).
  static const Kilo = 1e3;

  /// 10⁶ (mega).
  static const Mega = 1e6;

  /// 10⁹ (giga).
  static const Giga = 1e9;

  /// 10¹² (tera).
  static const Tera = 1e12;

  /// 10¹⁵ (peta).
  static const Peta = 1e15;

  /// 10¹⁸ (exa).
  static const Exa = 1e18;

  /// 10²¹ (zetta).
  static const Zetta = 1e21;

  /// 10²⁴ (yotta).
  static const Yotta = 1e24;
}
