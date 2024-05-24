
<div align="center">

![Ribs](https://raw.githubusercontent.com/cranst0n/ribs/main/.github/assets/logo.png)

# Ribs

[![CI](https://github.com/cranst0n/ribs/actions/workflows/ci.yml/badge.svg)](https://github.com/cranst0n/ribs/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/cranst0n/ribs/branch/main/graph/badge.svg?token=12627T0AO0)](https://codecov.io/gh/cranst0n/ribs)

[![core](https://img.shields.io/pub/v/ribs_core?label=ribs_core&color=00c000)](https://pub.dev/packages/ribs_core)
[![effect](https://img.shields.io/pub/v/ribs_effect?label=ribs_effect&color=00c000)](https://pub.dev/packages/ribs_effect)
[![json](https://img.shields.io/pub/v/ribs_json?label=ribs_json&color=00c000)](https://pub.dev/packages/ribs_json)
[![binary](https://img.shields.io/pub/v/ribs_binary?label=ribs_binary&color=00c000)](https://pub.dev/packages/ribs_binary)
[![optics](https://img.shields.io/pub/v/ribs_optics?label=ribs_optics&color=00c000)](https://pub.dev/packages/ribs_optics)
[![units](https://img.shields.io/pub/v/ribs_units?label=ribs_units&color=00c000)](https://pub.dev/packages/ribs_units)
[![check](https://img.shields.io/pub/v/ribs_check?label=ribs_check&color=00c000)](https://pub.dev/packages/ribs_check)
[![ip](https://img.shields.io/pub/v/ribs_ip?label=ribs_ip&color=00c000)](https://pub.dev/packages/ribs_ip)

![http](https://img.shields.io/badge/ribs__http-unpublished-f00000)
![rill](https://img.shields.io/badge/ribs__rill-unpublished-f00000)
![sqlite](https://img.shields.io/badge/ribs__sqlite-unpublished-f00000)

**🧪 Experimental FP packages for Dart 🧪**

[![Reinventing the Wheel](https://raw.githubusercontent.com/cranst0n/ribs/main/.github/assets/reinventing_the_wheel.png)](https://twitter.com/rockthejvm/status/1640320394438508545)


[Documentation](https://cranst0n.github.io/ribs/)

### Unpublished Libraries

**rill**

While the existing library is somewhat useful for tinkering around there are at least 2 major
roadblocks that should be addressed before rill is reliably useful in the wild:

* [Lower Type Bounds][https://github.com/dart-lang/language/issues/1674]
* [Variance][https://github.com/dart-lang/language/issues/213]

Both of these features exist in Scala, which in part, is what makes fs2 work so
well. Lack of these features severly limits the general usefulness.

**http**

Building a production ready http library is a massive undertaking, and one that isn't within
the scope of my efforts today, or maybe ever. ribs_http is a proof of concept that works for
small limited use-cases. I use if for small toy project because it fits in well with the rest
of the ribs ecosystem. If you want to do anything mildly out of the ordinary, chances are you'll
have to build something yourself. ribs_http should also be dependent on rill, so until a good
streaming library exists, the utility is limited here.

**sqlite**

This is still a fairly immature library but has proven useful in my toy projects so could be
published at some point.

</div>

---

### Alternatives

There are more battle tested libraries available that have overlapping
features, as well as additional features not found here, so you should
certainly consider using them. They all bring some things to the table
that you won't find here.

* [dartz](https://github.com/spebbe/dartz)
* [fpdart](https://github.com/SandroMaglione/fpdart)
* [FIC](https://pub.dev/packages/fast_immutable_collections)

### Credits

Much of the design and functionality in this repository is closely derived from
the following libraries.

* [scala](https://github.com/scala/scala)
* [cats-effect](https://github.com/typelevel/cats-effect)
* [fs2](https://github.com/typelevel/fs2)
* [scodec](https://github.com/scodec/scodec)
* [jawn](https://github.com/typelevel/jawn)
* [circe](https://github.com/circe/circe)
* [monocle](https://www.optics.dev/Monocle/)
* [sqaunts](https://github.com/typelevel/squants)
* [cats-retry](https://github.com/cb372/cats-retry)
* [doobie](https://github.com/tpolecat/doobie)
* [dart-check](https://github.com/wigahluk/dart-check)
* [ip4s](https://github.com/Comcast/ip4s)
* [punycode_converter](https://github.com/darkxanter/punycode_converter)
