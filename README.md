
Experimental set of FP inspired packages for Dart.

**Important Note:**

These are young libraries and should be used with caution. I use them for work,
but accept the strong possibility that there are bugs and am willing to fix
them as they pop up.

The design is almost entirely directed at purity, so you can expect to run into
performance issues. `IList` in particular is not build with thousands of
elements in mind. I would recommend looking at a simliar, but more performant
implementation in [dartz](https://github.com/spebbe/dartz/tree/master/lib/src)
or [FIC](https://pub.dev/packages/fast_immutable_collections).

Credit goes to the following libraries for inspiration.

* [dartz](https://github.com/spebbe/dartz/tree/master/lib/src)
* [shuttlecock](https://github.com/alexeieleusis/shuttlecock)

Much of the functionality in this repository is closely derived from
the following libraries and their licenses should be observed.

* [circe](https://github.com/circe/circe)
* [scodec](https://github.com/scodec/scodec)
* [sqaunts](https://github.com/typelevel/squants)
* [cats-retry](https://github.com/cb372/cats-retry)
* [dart-check](https://github.com/wigahluk/dart-check)
