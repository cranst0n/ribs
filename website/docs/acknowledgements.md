---
sidebar_position: 2
---

# Acknowledgements

Ribs is built on the shoulders of giants. This project began out of a curiosity
of how advanced FP libraries work in the wild so I reviewed implementations from
many libraries I've used in Scala and worked on implementing them in Dart. Not
only did I learn a lot from them, some of the libraries provide capabilities
that don't otherwise exist in the Dart ecosystem (at the time of this writing).

That being said, large portions of Ribs are directly derived from the following
libraries:

| Library                                                 | Derived Work(s)                                      |
| ------------------------------------------------------- | ---------------------------------------------------- |
| [cats-effect](https://github.com/typelevel/cats-effect) | `IO`, `Ref` and other effect related implementations |
| [cats-retry](https://github.com/cb372/cats-retry)       | `IO` retry capabilities                              |
| [jawn](https://github.com/typelevel/jawn)               | JSON parser                                          |
| [circe](https://github.com/circe/circe)                 | JSON Encoding / Decoding                             |
| [scodec](https://github.com/scodec/scodec)              | `ByteVector`, Binary Encoding / Decoding             |
| [monocle](https://www.optics.dev/Monocle/)              | Optics                                               |
| [sqaunts](https://github.com/typelevel/squants)         | Typesafe Dimensonal Analysis                         |
| [dart-check](https://github.com/wigahluk/dart-check)    | Property based testing                               |

In addition to these libraries, additional inspiration/motivation was provided by:

| Library                                                    |                                                                                                       |
| ---------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| [FIC](https://pub.dev/packages/fast_immutable_collections) | Amazing immutable collections library for Dart that Ribs uses under the hood of it's collections API. |
| [dartz](https://github.com/spebbe/dartz)                   | The OG Dart FP library where I made my first contributions to Dart.                                   |
| [fpdart](https://github.com/SandroMaglione/fpdart)         | The current de-facto FP library for Dart provides an amazing dev experience.                          |

All of these libraries are worth exploring and represent tremendous value to
the entire Dart ecosystem! Much of what Ribs has become is directly possible
with these libraries.