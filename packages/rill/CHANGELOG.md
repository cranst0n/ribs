## 1.0.1

### Bug Fixes

- Export the pipe syntax extensions (`Base64Pipes`, `CompressionPipes`,
  `GZipPipes`, `HexPipes`, `LinesPipes`, `TextPipes`, `Utf8Pipes`) from the
  public API so they can be used outside the package.
- Fix a race condition in `Scope` where concurrent register/lease/release/close
  operations could interleave between the separate reads and writes, allowing
  finalizers to be run more than once or skipped.

## 1.0.0

- First stable release.

## 1.0.0-dev.3

### Bug Fixes

- Update `ribs_core` dependency.

## 1.0.0-dev.2

### Breaking Changes

- Remove `ribs_rill_test.dart` test matchers library. Rill stream matchers are
  now provided by the `ribs_test` package.

## 1.0.0-dev.1

- Initial release
