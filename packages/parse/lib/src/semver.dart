import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/src/numbers.dart';
import 'package:ribs_parse/src/parser.dart';

/// A parsed [Semantic Versioning 2.0.0](https://semver.org/) version string.
///
/// Use [SemVer.parser] to parse a `MAJOR.MINOR.PATCH` string with an optional
/// pre-release label and build metadata suffix, or [SemVer.semverString] to
/// capture the raw matched text without constructing a [SemVer] instance.
final class SemVer {
  /// The major version component (e.g. `"1"`).
  final String major;

  /// The minor version component (e.g. `"2"`).
  final String minor;

  /// The patch version component (e.g. `"3"`).
  final String patch;

  /// The pre-release label following `-`, if present (e.g. `"alpha.1"`).
  final Option<String> preRelease;

  /// The build metadata following `+`, if present (e.g. `"20230101"`).
  final Option<String> buildMetadata;

  SemVer({
    required this.major,
    required this.minor,
    required this.patch,
    this.preRelease = const None(),
    this.buildMetadata = const None(),
  });

  /// Matches a literal `.`.
  static final dot = Parsers.charIn(ilist(['.']));

  /// Matches a literal `-`.
  static final hyphen = Parsers.charIn(ilist(['-']));

  /// Matches a literal `+`.
  static final plus = Parsers.charIn(ilist(['+']));

  /// Matches a single ASCII letter (case-insensitive).
  static final letter = Parsers.ignoreCaseCharInRange('a', 'z');

  /// Matches a letter or hyphen — the non-digit identifier characters.
  static final nonDigit = letter | hyphen;

  /// Matches a single alphanumeric character or hyphen.
  static final identifierChar = Numbers.digit | nonDigit;

  /// Matches one or more [identifierChar]s and returns them as a string.
  static final identifierChars = identifierChar.rep().string;

  /// A numeric identifier: a non-negative integer with no leading zeros.
  static final numericIdentifier = Numbers.nonNegativeIntString;

  /// An alphanumeric identifier: one or more [identifierChar]s.
  static final alphanumericIdentifier = identifierChars;

  /// A build metadata identifier (same grammar as [alphanumericIdentifier]).
  static final buildIdentifier = alphanumericIdentifier;

  /// A pre-release identifier (same grammar as [alphanumericIdentifier]).
  static final preReleaseIdentifier = alphanumericIdentifier;

  /// Dot-separated build identifiers forming the full build metadata string.
  static final dotSeparatedBuildIdentifiers = buildIdentifier.repSep(dot).string;

  /// The full build metadata string (after `+`).
  static final build = dotSeparatedBuildIdentifiers;

  /// Dot-separated pre-release identifiers forming the full pre-release string.
  static final dotSeparatedPreReleaseIdentifiers = preReleaseIdentifier.repSep(dot).string;

  /// The full pre-release string (after `-`).
  static final preReleaseP = dotSeparatedBuildIdentifiers;

  /// Parser for the patch version component.
  static final patchP = numericIdentifier;

  /// Parser for the minor version component.
  static final minorP = numericIdentifier;

  /// Parser for the major version component.
  static final majorP = numericIdentifier;

  /// Parses the `MAJOR.MINOR.PATCH` core triple and returns a
  /// `(major, minor, patch)` tuple.
  static final core = majorP
      .product(dot.productR(minorP))
      .product(dot.productR(minorP))
      .map((tup) => (tup.$1.$1, tup.$1.$2, tup.$2));

  /// Parses the core version triple and returns the raw matched string.
  static final coreString = core.string;

  /// Parses a full semantic version string and constructs a [SemVer].
  ///
  /// Accepts `MAJOR.MINOR.PATCH[-pre-release][+build]`.
  static final parser = core
      .product(hyphen.productR(preReleaseP).opt)
      .product(plus.productR(build).opt)
      .map((tup) {
        final (((major, minor, patch), preRelease), build) = tup;

        return SemVer(
          major: major,
          minor: minor,
          patch: patch,
          preRelease: preRelease,
          buildMetadata: build,
        );
      });

  /// Parses a full semantic version string and returns the raw matched text.
  static final semverString = parser.string;
}
