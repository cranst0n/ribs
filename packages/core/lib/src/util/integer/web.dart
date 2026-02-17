/*
 * Copyright (c) 1994, 2023, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Oracle designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Oracle in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */

import 'package:ribs_core/src/util/integer/base.dart';

final class IntegerImpl extends IntegerBase {
  @override
  int get MaxValue => 0x1FFFFFFFFFFFFF;

  @override
  int get MinValue => -0x1FFFFFFFFFFFFF;

  @override
  int get Size => 53;

  @override
  int highestOneBit(int i) {
    var x = i;
    x |= x >> 1;
    x |= x >> 2;
    x |= x >> 4;
    x |= x >> 8;
    x |= x >> 16;
    return x - (x >>> 1);
  }

  @override
  int bitCount(int i) {
    var x = i;

    x = x - ((x >>> 1) & 0x55555555);
    x = (x & 0x33333333) + ((x >>> 2) & 0x33333333);
    x = (x + (x >>> 4)) & 0x0f0f0f0f;
    x = x + (x >>> 8);
    x = x + (x >>> 16);
    return x & 0x3f;
  }

  @override
  int numberOfLeadingZeros(int i) {
    var x = i;

    if (x <= 0) return x == 0 ? 32 : 0;

    int n = 31;

    if (x >= 1 << 16) {
      n -= 16;
      x >>>= 16;
    }

    if (x >= 1 << 8) {
      n -= 8;
      x >>>= 8;
    }

    if (x >= 1 << 4) {
      n -= 4;
      x >>>= 4;
    }

    if (x >= 1 << 2) {
      n -= 2;
      x >>>= 2;
    }

    return n - (x >>> 1);
  }

  @override
  int numberOfTrailingZeros(int i) {
    var x = i;

    x = ~x & (x - 1);

    if (x <= 0) return x & 32;

    int n = 1;

    if (x > 1 << 16) {
      n += 16;
      x >>>= 16;
    }

    if (x > 1 << 8) {
      n += 8;
      x >>>= 8;
    }

    if (x > 1 << 4) {
      n += 4;
      x >>>= 4;
    }

    if (x > 1 << 2) {
      n += 2;
      x >>>= 2;
    }

    return n + (x >>> 1);
  }
}
