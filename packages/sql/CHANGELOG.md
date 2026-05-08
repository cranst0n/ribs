## 1.0.0-dev.3

- Fix `Put.setParameter` to encode values before storing, so contramapped puts
  (`Put.json`, `Put.dateTime`, `Put.blob`) correctly convert to driver-compatible
  types rather than storing raw Dart objects.
- Simplify `Put.boolean` to pass `bool` values directly to the driver.

## 1.0.0-dev.2

- Update dependencies.

## 1.0.0-dev.1

- Initial release
