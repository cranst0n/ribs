
<div align="center">

![Ribs](https://raw.githubusercontent.com/cranst0n/ribs/main/.github/assets/logo.png)

# Ribs

[![CI](https://github.com/cranst0n/ribs/actions/workflows/ci.yml/badge.svg)](https://github.com/cranst0n/ribs/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/cranst0n/ribs/branch/main/graph/badge.svg?token=12627T0AO0)](https://codecov.io/gh/cranst0n/ribs)

**🧪 Experimental FP packages for Dart 🧪**

[![Reinvent the Wheel](https://raw.githubusercontent.com/cranst0n/ribs/main/.github/assets/reinventing_the_wheel.png)](https://twitter.com/rockthejvm/status/1640320394438508545)


</div>

---

### Caveats

**Maturity**

These are *very* young libraries and should be used with caution. You'll need
to accept the possibility that there are bugs and are willing to fix them as
they pop up.

**Documentation**

This began out of a desire expand my understanding of advanced FP concepts, so
documentation was not even close to the top of the priorities. While I do hope
to improve the situation, until that day, other simliar projects may provide
insight into what this project provides. If you run into an especially opaque
piece of code, chances are it was inspired by another library that has more
complete documentation.

**Performance**

The design is almost entirely directed at purity, so you may run into some
performance issues. As an example, the original `IList` implementation, while
pure and somewhat elegant, suffered from pretty terrible performance. So bad in
fact, it's unusable for many real world situations. In light of that, it was
replaced with an implementation backed by [FIC](https://pub.dev/packages/fast_immutable_collections).
There is potential for similar situations in other structures so if you're
seeing something that is particularly slow, raise an issue.

### Alternatives

There are more battle tested libraries available that have overlapping
features, as well as additional features not found here, so you should
certainly consider using them. They all bring some things to the table
that you won't find here.

* [dartz](https://github.com/spebbe/dartz)
* [fpdart](https://github.com/SandroMaglione/fpdart)

There are also provided `compat` libraries to make it easier converting between
similar types in those libraries if you want to use both.

Ideally, some of the functionality in these libraries will find a home in an
already popular library, but it's easier to move fast and break things when
you're working in your own sandbox.

### Credits

Much of the design and functionality in this repository is closely derived from
the following libraries.

* [cats-effect](https://github.com/typelevel/cats-effect)
* [fs2](https://github.com/typelevel/fs2)
* [scodec](https://github.com/scodec/scodec)
* [jawn](https://github.com/typelevel/jawn)
* [circe](https://github.com/circe/circe)
* [monocle](https://www.optics.dev/Monocle/)
* [sqaunts](https://github.com/typelevel/squants)
* [cats-retry](https://github.com/cb372/cats-retry)
* [dart-check](https://github.com/wigahluk/dart-check)

Additional inspiration provided by:

* [FIC](https://pub.dev/packages/fast_immutable_collections)
* [dartz](https://github.com/spebbe/dartz)
* [fpdart](https://github.com/SandroMaglione/fpdart)
