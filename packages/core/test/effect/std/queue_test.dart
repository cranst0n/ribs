import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/effect/std/internal/list_queue.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  group('Bounded Queue', () {
    IO<Queue<int>> constructor(int n) => Queue.bounded<int>(n);

    QueueTests.batchOfferTests(
      constructor,
      (q, a) => q.tryOfferN(a),
      (q, a) => q.tryTakeN(a),
      id,
    );

    QueueTests.batchTakeTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryTakeN(a),
      id,
    );

    QueueTests.boundedBatchOfferTests(
      constructor,
      (q, a) => q.tryOfferN(a),
      (q, a) => q.tryTakeN(a),
      id,
    );

    QueueTests.cancelableOfferTests(
      constructor,
      (q, a) => q.offer(a),
      (q) => q.take(),
      (q) => q.tryTake(),
    );

    QueueTests.cancelableOfferBoundedTests(
      constructor,
      (q, a) => q.offer(a),
      (q) => q.take(),
      (q, n) => q.tryTakeN(n),
    );

    QueueTests.cancelableTakeTests(
      constructor,
      (q, a) => q.offer(a),
      (q) => q.take(),
    );

    QueueTests.commonTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      (q) => q.take(),
      (q) => q.tryTake(),
      (q) => q.size(),
    );

    QueueTests.tryOfferOnFullTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      false,
    );

    QueueTests.tryOfferTryTakeTests(
      constructor,
      (q, a) => q.tryOffer(a),
      (q) => q.tryTake(),
    );
  });

  group('Circular Buffer Queue', () {
    test('overwrites properly', () {
      final test = Queue.circularBuffer<int>(3).flatMap((q) {
        return ilist([1, 2, 3, 4, 5]).traverseIO(q.offer).flatMap((_) {
          return q.tryTakeN(none()).flatMap((items) {
            return expectIO(items, ilist([3, 4, 5]));
          });
        });
      });

      expect(test, ioSucceeded());
    });

    IO<Queue<int>> constructor(int n) => Queue.circularBuffer<int>(n);

    QueueTests.batchOfferTests(
      constructor,
      (q, a) => q.tryOfferN(a),
      (q, a) => q.tryTakeN(a),
      id,
    );

    QueueTests.batchTakeTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryTakeN(a),
      id,
    );

    QueueTests.commonTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      (q) => q.take(),
      (q) => q.tryTake(),
      (q) => q.size(),
    );

    QueueTests.tryOfferOnFullTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      true,
    );
  });

  group('Dropping Queue', () {
    test('drops properly', () {
      final test = Queue.dropping<int>(3).flatMap((q) {
        return ilist([1, 2, 3, 4, 5]).traverseIO(q.offer).flatMap((_) {
          return q.tryTakeN(none()).flatMap((items) {
            return expectIO(items, ilist([1, 2, 3]));
          });
        });
      });

      expect(test, ioSucceeded());
    });

    IO<Queue<int>> constructor(int n) => Queue.dropping<int>(n);

    QueueTests.batchOfferTests(
      constructor,
      (q, a) => q.tryOfferN(a),
      (q, a) => q.tryTakeN(a),
      id,
    );

    QueueTests.batchTakeTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryTakeN(a),
      id,
    );

    QueueTests.cancelableOfferTests(
      constructor,
      (q, a) => q.offer(a),
      (q) => q.take(),
      (q) => q.tryTake(),
    );

    QueueTests.cancelableTakeTests(
      constructor,
      (q, a) => q.offer(a),
      (q) => q.take(),
    );

    QueueTests.commonTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      (q) => q.take(),
      (q) => q.tryTake(),
      (q) => q.size(),
    );

    QueueTests.tryOfferOnFullTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      false,
    );

    QueueTests.tryOfferTryTakeTests(
      constructor,
      (q, a) => q.tryOffer(a),
      (q) => q.tryTake(),
    );
  });

  group('Synchronous Queue', () {
    test('simple offer/take', () {
      const offerValue = 0;

      final test = Queue.synchronous<int>().flatMap((q) {
        return q
            .offer(offerValue)
            .delayBy(const Duration(milliseconds: 100))
            .start()
            .flatMap((of) {
          return q.take().start().flatMap((tf) {
            return tf.joinWithNever().flatMap((value) {
              return expectIO(value, offerValue);
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });

    test('respect fifo order', () {
      final test = Queue.synchronous<int>().flatMap((q) {
        return IList.range(0, 5).traverseIO_((i) {
          final f = IO
              .sleep(Duration(milliseconds: i * 200))
              .flatMap((_) => q.offer(i))
              .voided();

          return f.start();
        }).flatMap((_) {
          return IO.sleep(const Duration(seconds: 2)).flatMap((_) {
            return q.take().replicate(5);
          });
        });
      });

      expect(test, ioSucceeded(ilist([0, 1, 2, 3, 4])));
    });

    test('not lose offer when taker is canceled during exchange', () {
      final test = Queue.synchronous<Unit>().flatMap((q) {
        return CountDownLatch.create(2).flatMap((latch) {
          return IO.ref(false).flatMap((offererDone) {
            return latch
                .release()
                .productR(() => latch.await())
                .productR(() => q.offer(Unit()))
                .guarantee(offererDone.setValue(true))
                .start()
                .flatMap((_) {
              return latch
                  .release()
                  .productR(() => latch.await())
                  .productR(() => q.take())
                  .onCancel(IO.println('CANCELED...'))
                  .start()
                  .flatMap((taker) {
                return latch.await().flatMap((_) {
                  return taker.cancel().flatMap((_) {
                    return taker.join().flatMap((oc) {
                      if (oc.isCanceled) {
                        return offererDone
                            .value()
                            .flatMap((b) => expectIO(b, false))
                            .productR(() => q.take());
                      } else {
                        return IO.unit;
                      }
                    });
                  });
                });
              });
            });
          });
        });
      });

      expect(test.parReplicate(1), ioSucceeded());
    }, skip: true);
  });

  group('Unbounded Queue', () {
    IO<Queue<int>> constructor(int n) => Queue.unbounded<int>();

    QueueTests.batchOfferTests(
      constructor,
      (q, a) => q.tryOfferN(a),
      (q, a) => q.tryTakeN(a),
      id,
    );

    QueueTests.commonTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      (q) => q.take(),
      (q) => q.tryTake(),
      (q) => q.size(),
    );

    QueueTests.batchTakeTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryTakeN(a),
      id,
    );

    QueueTests.tryOfferOnFullTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      true,
    );

    QueueTests.tryOfferTryTakeTests(
      constructor,
      (q, a) => q.tryOffer(a),
      (q) => q.tryTake(),
    );
  });
}

class QueueTests {
  static void batchOfferTests<Q extends Queue<int>>(
    Function1<int, IO<Q>> constructor,
    Function2<Q, IList<int>, IO<IList<int>>> tryOfferN,
    Function2<Q, Option<int>, IO<IList<int>>> tryTakeN,
    Function1<IList<int>, IList<int>> transform,
  ) {
    test('should offer all records when there is room', () {
      final test = constructor(5).flatMap((q) {
        return tryOfferN(q, ilist([1, 2, 3, 4, 5])).flatMap((offerR) {
          return tryTakeN(q, none()).flatMap((takeR) {
            return expectIO(transform(takeR), ilist([1, 2, 3, 4, 5]))
                .flatMap((_) {
              return expectIO(offerR, nil<int>());
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });
  }

  static void boundedBatchOfferTests<Q extends Queue<int>>(
    Function1<int, IO<Q>> constructor,
    Function2<Q, IList<int>, IO<IList<int>>> tryOfferN,
    Function2<Q, Option<int>, IO<IList<int>>> tryTakeN,
    Function1<IList<int>, IList<int>> transform,
  ) {
    test('should offer some records when the queue is full', () {
      final test = constructor(5).flatMap((q) {
        return tryOfferN(q, ilist([1, 2, 3, 4, 5, 6, 7])).flatMap((offerR) {
          return tryTakeN(q, none()).flatMap((takeR) {
            return expectIO(transform(takeR), ilist([1, 2, 3, 4, 5]))
                .flatMap((_) {
              return expectIO(offerR, ilist([6, 7]));
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });
  }

  static void batchTakeTests<Q extends Queue<int>>(
    Function1<int, IO<Q>> constructor,
    Function2<Q, int, IO<Unit>> offer,
    Function2<Q, Option<int>, IO<IList<int>>> tryTakeN,
    Function1<IList<int>, IList<int>> transform,
  ) {
    test('take batches for all records when None is provided', () {
      final test = constructor(5).flatMap((q) {
        return offer(q, 1).flatMap((_) {
          return offer(q, 2).flatMap((_) {
            return offer(q, 3).flatMap((_) {
              return offer(q, 4).flatMap((_) {
                return offer(q, 5).flatMap((_) {
                  return tryTakeN(q, none()).flatMap((b) {
                    return expectIO(transform(b), ilist([1, 2, 3, 4, 5]));
                  });
                });
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });

    test('take batches for all records when maxN is provided', () {
      final test = constructor(5).flatMap((q) {
        return offer(q, 1).flatMap((_) {
          return offer(q, 2).flatMap((_) {
            return offer(q, 3).flatMap((_) {
              return offer(q, 4).flatMap((_) {
                return offer(q, 5).flatMap((_) {
                  return tryTakeN(q, const Some(5)).flatMap((b) {
                    return expectIO(transform(b), ilist([1, 2, 3, 4, 5]));
                  });
                });
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });

    test('take all records when maxN > queue size', () {
      final test = constructor(5).flatMap((q) {
        return offer(q, 1).flatMap((_) {
          return offer(q, 2).flatMap((_) {
            return offer(q, 3).flatMap((_) {
              return offer(q, 4).flatMap((_) {
                return offer(q, 5).flatMap((_) {
                  return tryTakeN(q, const Some(7)).flatMap((b) {
                    return expectIO(transform(b), ilist([1, 2, 3, 4, 5]));
                  });
                });
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });

    test('be empty when queue is empty', () {
      final test = constructor(5).flatMap((q) {
        return tryTakeN(q, const Some(5)).flatMap((b) {
          return expectIO(transform(b), nil<int>());
        });
      });

      expect(test, ioSucceeded());
    });

    test('release one offerer when queue is full', () {
      final test = constructor(5).flatMap((q) {
        return offer(q, 0).replicate_(5).flatMap((_) {
          return IO.deferred<Unit>().flatMap((latch) {
            return CountDownLatch.create(1).flatMap((expected) {
              return latch
                  .complete(Unit())
                  .productR(() => offer(q, 0))
                  .productR(() => expected.release())
                  .start()
                  .flatMap((_) {
                return latch.value().flatMap((_) {
                  return tryTakeN(q, none()).flatMap((results) {
                    return results.nonEmpty
                        ? expected.await()
                        : fail('did not take any results');
                  });
                });
              });
            });
          });
        });
      });

      expect(test.parReplicate_(10), ioSucceeded());
    });

    test('release all offerers when queue is full', () {
      final test = constructor(5).flatMap((q) {
        return offer(q, 0).replicate_(5).flatMap((_) {
          return CountDownLatch.create(5).flatMap((latch) {
            return CountDownLatch.create(5).flatMap((expected) {
              return latch
                  .release()
                  .productR(() => offer(q, 0))
                  .productR(() => expected.release())
                  .start()
                  .replicate_(5)
                  .flatMap((_) {
                return latch.await().flatMap((_) {
                  return tryTakeN(q, none()).flatMap((results) {
                    return expected
                        .release()
                        .replicate_(5 - results.length)
                        .flatMap((_) {
                      return expected.await();
                    });
                  });
                });
              });
            });
          });
        });
      });

      expect(test.parReplicate(10), ioSucceeded());
    });
  }

  static void tryOfferOnFullTests<Q extends Queue<int>>(
    Function1<int, IO<Q>> constructor,
    Function2<Q, int, IO<Unit>> offer,
    Function2<Q, int, IO<bool>> tryOffer,
    bool expected,
  ) {
    test('return value on tryOffer when the queue is full', () {
      final test = constructor(2).flatMap((q) {
        return offer(q, 0).flatMap((_) {
          return offer(q, 0).flatMap((_) {
            return tryOffer(q, 1).flatMap((v) {
              return expectIO(v, expected);
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });
  }

  static void cancelableOfferTests<Q extends Queue<int>>(
    Function1<int, IO<Q>> constructor,
    Function2<Q, int, IO<Unit>> offer,
    Function1<Q, IO<int>> take,
    Function1<Q, IO<Option<int>>> tryTake,
  ) {
    test('demonstrate cancelable offer', () {
      final test = constructor(2).flatMap((q) {
        return offer(q, 1).flatMap((_) {
          return offer(q, 1).flatMap((_) {
            return offer(q, 2).start().flatMap((f) {
              return IO.sleep(const Duration(milliseconds: 10)).flatMap((_) {
                return f.cancel().flatMap((_) {
                  return take(q).flatMap((v1) {
                    return take(q).flatMap((_) {
                      return tryTake(q).flatMap((v2) {
                        return expectIO(v1, 1)
                            .productR(() => expectIO(v2, isNone()));
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });

    test('ensure offerers are awakened under all circumstances', () {
      final test = constructor(5).flatMap((q) {
        return Deferred.of<bool>().flatMap((offeredR) {
          return IList.range(0, 5).traverseIO_((n) => offer(q, n)).flatMap((_) {
            final offerer1 = offer(q, 42).guaranteeCase((oc) {
              return oc.fold(
                () => offeredR.complete(false).voided(),
                (_) => offeredR.complete(false).voided(),
                (a) => offeredR.complete(true).voided(),
              );
            });

            return offerer1.start().flatMap((offer1) {
              return offer(q, 24).start().flatMap((offer2) {
                return IO.sleep(const Duration(milliseconds: 250)).flatMap((_) {
                  return IO.both(take(q), offer1.cancel()).flatMap((_) {
                    return offeredR.value().flatMap((offered) {
                      final next = offered ? offer2.cancel() : offer2.join();
                      return next.voided();
                    });
                  });
                });
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });
  }

  static void cancelableOfferBoundedTests<Q extends Queue<int>>(
    Function1<int, IO<Q>> constructor,
    Function2<Q, int, IO<Unit>> offer,
    Function1<Q, IO<int>> take,
    Function2<Q, Option<int>, IO<IList<int>>> tryTakeN,
  ) {
    test('ensure offerers are awakened by tryTakeN after cancelation', () {
      final test = constructor(4).flatMap((q) {
        return IList.range(0, 4).traverseIO_((n) {
          return offer(q, n);
        }).flatMap((_) {
          return IList.range(0, 4)
              .traverseIO((n) => IO
                  .sleep(Duration(milliseconds: n * 10))
                  .productR(() => offer(q, 10 + n))
                  .start())
              .flatMap((offerers) {
            return IO.cede.flatMap((_) {
              return offerers[1].cancel().flatMap((_) {
                return offer(q, 20)
                    .delayBy(const Duration(milliseconds: 50))
                    .start()
                    .flatMap((_) {
                  return IO
                      .sleep(const Duration(milliseconds: 100))
                      .flatMap((_) {
                    return tryTakeN(q, none()).flatMap((taken1) {
                      return IList.range(0, 4)
                          .traverseIO((_) => take(q))
                          .flatMap((taken2) {
                        return expectIO(taken1, ilist([0, 1, 2, 3])).productR(
                            () => expectIO(taken2, ilist([10, 12, 13, 20])));
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });
  }

  static void cancelableTakeTests<Q extends Queue<int>>(
    Function1<int, IO<Q>> constructor,
    Function2<Q, int, IO<Unit>> offer,
    Function1<Q, IO<int>> take,
  ) {
    test('not lose data on canceled take', () {
      final test = constructor(100).flatMap((q) {
        return IList.range(0, 100)
            .traverseIO_((n) => offer(q, n).productR(() => IO.cede))
            .start()
            .flatMap((_) {
          return IO.ref(-1).flatMap((results) {
            return IO.deferred<Unit>().flatMap((latch) {
              final consumer = latch.complete(Unit()).flatMap((_) {
                return IO.uncancelable((poll) {
                  return poll(take(q)).flatMap((a) => results.setValue(a));
                }).replicate_(1000);
              });

              return consumer.start().flatMap((consumerFiber) {
                return latch.value().flatMap((_) {
                  return consumerFiber.cancel().flatMap((_) {
                    return results.value().flatMap((max) {
                      if (max < 99) {
                        return take(q).flatMap((next) {
                          return expectIO(next, max + 1).as(false);
                        });
                      } else {
                        return IO.pure(true);
                      }
                    });
                  });
                });
              });
            });
          });
        });
      });

      const bound = 10;

      IO<Unit> loop(int i) {
        if (i > bound) {
          return IO.pure(
              fail('attempted $i times and could not reproduce scenario'));
        } else {
          return test.ifM(() => loop(i + 1), () => IO.unit);
        }
      }

      final prog = loop(0).replicate_(100).as(Unit());

      expect(prog, ioSucceeded());
    });

    test('ensure takers are awakened under all circumstances', () {
      final test = constructor(64).flatMap((q) {
        return IO.deferred<Option<int>>().flatMap((takenR) {
          final taker1 = take(q).guaranteeCase((oc) {
            return oc.fold(
              () => takenR.complete(none()).voided(),
              (err) => takenR.complete(none()).voided(),
              (a) => takenR.complete(Some(a)).voided(),
            );
          });

          return taker1.start().flatMap((take1) {
            return take(q).start().flatMap((take2) {
              return IO.sleep(const Duration(milliseconds: 250)).flatMap((_) {
                return IO.both(offer(q, 42), take1.cancel()).flatMap((_) {
                  return takenR.value().flatMap((taken) {
                    return taken.fold(
                      () => take2.join(),
                      (a) => take2.cancel(),
                    );
                  });
                });
              });
            });
          });
        });
      }).voided();

      expect(test, ioSucceeded());
    });
  }

  static void tryOfferTryTakeTests<Q extends Queue<int>>(
    Function1<int, IO<Q>> constructor,
    Function2<Q, int, IO<bool>> tryOffer,
    Function1<Q, IO<Option<int>>> tryTake,
  ) {
    test('tryOffer/tryTake', () {
      const count = 1000;

      IO<Unit> producer(Q q, int n) {
        if (n > 0) {
          return tryOffer(q, count - n).ifM(
            () => producer(q, n - 1),
            () => IO.cede.productR(() => producer(q, n)),
          );
        } else {
          return IO.unit;
        }
      }

      IO<int> consumer(Q q, int n, ListQueue<int> acc) {
        if (n > 0) {
          return tryTake(q).flatMap((a) => a.fold(
                () => IO.cede.productR(() => consumer(q, n, acc)),
                (a) => consumer(q, n - 1, acc.enqueue(a)),
              ));
        } else {
          return IO.pure(acc.foldLeft(0, (a, b) => a + b));
        }
      }

      final test = constructor(10).flatMap((q) {
        return producer(q, count).start().flatMap((p) {
          return consumer(q, count, ListQueue.empty()).start().flatMap((c) {
            return p.join().flatMap((_) {
              return c.joinWithNever().flatMap((v) {
                return expectIO(v, count * (count - 1) ~/ 2);
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });
  }

  static void commonTests<Q extends Queue<int>>(
    Function1<int, IO<Q>> constructor,
    Function2<Q, int, IO<Unit>> offer,
    Function2<Q, int, IO<bool>> tryOffer,
    Function1<Q, IO<int>> take,
    Function1<Q, IO<Option<int>>> tryTake,
    Function1<Q, IO<int>> size,
  ) {
    test('should return the queue size when added to', () {
      final test = constructor(2).flatTap((q) {
        return offer(q, 1).flatMap((_) {
          return take(q).flatMap((_) {
            return offer(q, 2).flatMap((_) {
              return size(q).flatMap((sz) {
                return expectIO(sz, 1);
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });

    test('should return None on tryTake when the queue is empty', () {
      final test = constructor(2).flatMap((q) {
        return tryTake(q).flatMap((v) {
          return expectIO(v, isNone());
        });
      });

      expect(test, ioSucceeded());
    });

    test('demonstrate sequential offer and take', () {
      final test = constructor(2).flatMap((q) {
        return offer(q, 1).flatMap((_) {
          return take(q).flatMap((v1) {
            return offer(q, 2).flatMap((_) {
              return take(q).flatMap((v2) {
                return expectIO((v1, v2), (1, 2));
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });

    test('demonstrate cancelable take', () {
      final test = constructor(2).flatMap((q) {
        return take(q).start().flatMap((f) {
          return IO.sleep(const Duration(milliseconds: 10)).flatMap((_) {
            return f.cancel().flatMap((_) {
              return tryOffer(q, 1).flatMap((v) {
                return expectIO(v, isTrue);
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });

    test('async take', () {
      Option<int> futureValue = none();

      final test = constructor(10).flatMap((q) {
        return offer(q, 1).flatMap((_) {
          return take(q).flatMap((v1) {
            return expectIO(v1, 1).flatMap((_) {
              return IO
                  .delay(() => take(q)
                      .unsafeRunFuture()
                      .then((value) => futureValue = Option(value)))
                  .flatMap((f) {
                return expectIO(futureValue, isNone()).flatMap((_) {
                  return offer(q, 2).flatMap((_) {
                    return IO.fromFuture(IO.pure(f)).flatMap((v2) {
                      return expectIO(v2, isSome(2));
                    });
                  });
                });
              });
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });
  }
}
