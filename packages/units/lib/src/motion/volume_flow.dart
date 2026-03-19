import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_units/ribs_units.dart';

final class VolumeFlow extends Quantity<VolumeFlow> {
  VolumeFlow(super.value, super.unit);

  VolumeFlow operator +(VolumeFlow that) => VolumeFlow(value + that.to(unit), unit);
  VolumeFlow operator -(VolumeFlow that) => VolumeFlow(value - that.to(unit), unit);

  VolumeFlow get toCubicMetersPerSecond => to(cubicMetersPerSecond).cubicMetersPerSecond;
  VolumeFlow get toCubicFeetPerSecond => to(cubicFeetPerSecond).cubicFeetPerSecond;
  VolumeFlow get toCubicFeetPerMinute => to(cubicFeetPerMinute).cubicFeetPerMinute;
  VolumeFlow get toGallonsPerMinute => to(gallonsPerMinute).gallonsPerMinute;
  VolumeFlow get toLitersPerSecond => to(litersPerSecond).litersPerSecond;
  VolumeFlow get toLitersPerMinute => to(litersPerMinute).litersPerMinute;
  VolumeFlow get toLitersPerHour => to(litersPerHour).litersPerHour;
  VolumeFlow get toNanolitersPerSecond => to(nanolitersPerSecond).nanolitersPerSecond;
  VolumeFlow get toMicrolitersPerSecond => to(microlitersPerSecond).microlitersPerSecond;
  VolumeFlow get toMillilitersPerSecond => to(millilitersPerSecond).millilitersPerSecond;
  VolumeFlow get toMillilitersPerMinute => to(millilitersPerMinute).millilitersPerMinute;
  VolumeFlow get toMillilitersPerHour => to(millilitersPerHour).millilitersPerHour;

  static const VolumeFlowUnit cubicMetersPerSecond = CubicMetersPerSecond._();
  static const VolumeFlowUnit cubicFeetPerSecond = CubicFeetPerSecond._();
  static const VolumeFlowUnit cubicFeetPerMinute = CubicFeetPerMinute._();
  static const VolumeFlowUnit gallonsPerMinute = GallonsPerMinute._();
  static const VolumeFlowUnit litersPerSecond = LitersPerSecond._();
  static const VolumeFlowUnit litersPerMinute = LitersPerMinute._();
  static const VolumeFlowUnit litersPerHour = LitersPerHour._();
  static const VolumeFlowUnit nanolitersPerSecond = NanolitersPerSecond._();
  static const VolumeFlowUnit microlitersPerSecond = MicrolitersPerSecond._();
  static const VolumeFlowUnit millilitersPerSecond = MillilitersPerSecond._();
  static const VolumeFlowUnit millilitersPerMinute = MillilitersPerMinute._();
  static const VolumeFlowUnit millilitersPerHour = MillilitersPerHour._();

  static const units = {
    cubicMetersPerSecond,
    cubicFeetPerSecond,
    cubicFeetPerMinute,
    gallonsPerMinute,
    litersPerSecond,
    litersPerMinute,
    litersPerHour,
    nanolitersPerSecond,
    microlitersPerSecond,
    millilitersPerSecond,
    millilitersPerMinute,
    millilitersPerHour,
  };

  static Option<VolumeFlow> parse(String s) => Quantity.parse(s, units);
}

abstract class VolumeFlowUnit extends BaseUnit<VolumeFlow> {
  const VolumeFlowUnit(super.unit, super.symbol, super.conversionFactor);

  @override
  VolumeFlow call(num value) => VolumeFlow(value.toDouble(), this);
}

final class CubicMetersPerSecond extends VolumeFlowUnit {
  const CubicMetersPerSecond._() : super('cubic meter/second', 'm³/s', 1.0);
}

final class CubicFeetPerSecond extends VolumeFlowUnit {
  const CubicFeetPerSecond._() : super('cubic feet/second', 'ft³/s', 0.028317016);
}

final class CubicFeetPerMinute extends VolumeFlowUnit {
  const CubicFeetPerMinute._() : super('cubic feet/minute', 'ft³/min', 0.028317016 / 60.0);
}

final class GallonsPerMinute extends VolumeFlowUnit {
  const GallonsPerMinute._() : super('gallon/minute', 'gal/min', 6.30901964e-5);
}

final class LitersPerSecond extends VolumeFlowUnit {
  const LitersPerSecond._() : super('liter/second', 'L/s', 1e-3);
}

final class LitersPerMinute extends VolumeFlowUnit {
  const LitersPerMinute._() : super('liter/minute', 'L/min', 1e-3 / 60.0);
}

final class LitersPerHour extends VolumeFlowUnit {
  const LitersPerHour._() : super('liter/hour', 'L/h', 1e-3 / 3600.0);
}

final class NanolitersPerSecond extends VolumeFlowUnit {
  const NanolitersPerSecond._() : super('nanoliter/second', 'nL/s', 1e-12);
}

final class MicrolitersPerSecond extends VolumeFlowUnit {
  const MicrolitersPerSecond._() : super('microliter/second', 'µL/s', 1e-9);
}

final class MillilitersPerSecond extends VolumeFlowUnit {
  const MillilitersPerSecond._() : super('milliliter/second', 'mL/s', 1e-6);
}

final class MillilitersPerMinute extends VolumeFlowUnit {
  const MillilitersPerMinute._() : super('milliliter/minute', 'mL/min', 1e-6 / 60.0);
}

final class MillilitersPerHour extends VolumeFlowUnit {
  const MillilitersPerHour._() : super('milliliter/hour', 'mL/h', 1e-6 / 3600.0);
}

extension VolumeFlowOps on num {
  VolumeFlow get cubicMetersPerSecond => VolumeFlow.cubicMetersPerSecond(this);
  VolumeFlow get cubicFeetPerSecond => VolumeFlow.cubicFeetPerSecond(this);
  VolumeFlow get cubicFeetPerMinute => VolumeFlow.cubicFeetPerMinute(this);
  VolumeFlow get gallonsPerMinute => VolumeFlow.gallonsPerMinute(this);
  VolumeFlow get litersPerSecond => VolumeFlow.litersPerSecond(this);
  VolumeFlow get litersPerMinute => VolumeFlow.litersPerMinute(this);
  VolumeFlow get litersPerHour => VolumeFlow.litersPerHour(this);
  VolumeFlow get nanolitersPerSecond => VolumeFlow.nanolitersPerSecond(this);
  VolumeFlow get microlitersPerSecond => VolumeFlow.microlitersPerSecond(this);
  VolumeFlow get millilitersPerSecond => VolumeFlow.millilitersPerSecond(this);
  VolumeFlow get millilitersPerMinute => VolumeFlow.millilitersPerMinute(this);
  VolumeFlow get millilitersPerHour => VolumeFlow.millilitersPerHour(this);
}
