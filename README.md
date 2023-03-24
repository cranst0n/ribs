
🧪 Experimental 🧪 set of FP packages for Dart.

### Caveats

**Maturity**

These are *very* young libraries and should be used with caution. You'll need
to accept the possibility that there are bugs and are willing to fix them as
they pop up.

**Performance**

The design is almost entirely directed at purity, so you may run into some
performance issues. The original `IList` implementation, while pure and
somewhat elegant, suffers from pretty terrible performance. So bad in fact
it's unusable for many real world situations. In light of that, it was replaced
with an implementation backed by [FIC](https://pub.dev/packages/fast_immutable_collections).
This was done to maintain the old implementations API and behavior since
there's quite a bit of things build on top of `IList`. Highly recommend
checking FIC out since it solves a lot of problems while maintaining good
performance.

```
                 |        ribs  |         fic  |  
------------------------------------------------
append           |       962µs  |        17µs  |  
concat           |       635µs  |         1µs  |  
drop             |       299µs  |       109µs  |  
dropRight        |      1412µs  |       129µs  |  
filter           |       851µs  |       221µs  |  
findLast         |    972695µs  |       114µs  |  
flatMap          |      9786µs  |      2735µs  |  
init             |   2007336µs  |       247µs  |  
map              |      1122µs  |       257µs  |  
partition        |      1421µs  |       510µs  |  
prepend          |         0µs  |       134µs  |  
replace          |       379µs  |        69µs  |  
reverse          |    929614µs  |       540µs  |  
sliding          |    759597µs  |     82489µs  |  
tabulate         |       439µs  |       105µs  |  
zipWithIndex     |      1109µs  |      1140µs  |
```

**Documentation**

This began out of a desire expand my understanding of advanced FP concepts, so
documentation was not even close to the top of the priorities. While I do hope
to improve the situation, until that day, other simliar projects may provide
insight into what this project provides. If you run into an especially opaque
piece of code, chances are it was inspired by another library that has more
complete documentation.

### Alternatives

There are more battle tested libraries available that have overlapping
features, as well as additional features not found here, so you should
certainly consider using them. I've made certain design tradeoffs that
may impact your mileage.

[dartz](https://github.com/spebbe/dartz)
[fpdart](https://github.com/SandroMaglione/fpdart)

I've also provided `compat` libraries to make it easier converting between
similar types in those libraries if you want to use both.

Ideally, some of the functionality in these libraries will find a home in an
already popular library, so as not to reinvent the wheel, but it's easier to
move fast and break things when you're working in your own sandbox.

### Credits

Much of the functionality in this repository is closely derived from
the following libraries.

* [cats-effect](https://github.com/typelevel/cats-effect)
* [fs2](https://github.com/typelevel/fs2)
* [scodec](https://github.com/scodec/scodec)
* [circe](https://github.com/circe/circe)
* [sqaunts](https://github.com/typelevel/squants)
* [cats-retry](https://github.com/cb372/cats-retry)
* [dart-check](https://github.com/wigahluk/dart-check)

Additional functionality and inspiration was provided by:

* [FIC](https://pub.dev/packages/fast_immutable_collections)
* [dartz](https://github.com/spebbe/dartz)
* [fpdart](https://github.com/SandroMaglione/fpdart)
