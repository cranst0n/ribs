import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';

abstract class NetworkInterface {
  String get name;

  IList<Cidr<IpAddress>> get addresses;
}
