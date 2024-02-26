// This file is derived in part from the Scala collection library.
// https://github.com/scala/scala/blob/v2.13.x/src/library/scala/collection/
//
// Scala (https://www.scala-lang.org)
//
// Copyright EPFL and Lightbend, Inc.
//
// Licensed under Apache License 2.0
// (http://www.apache.org/licenses/LICENSE-2.0).
//
// See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.

sealed class Hashing {
  static int improve(int hcode) {
    var h = hcode + ~(hcode << 9);
    h = h ^ (h >>> 14);
    h = h + (h << 4);
    return h ^ (h >>> 10);
  }
}
