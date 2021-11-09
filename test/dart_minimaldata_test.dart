import 'package:dart_minimaldata/dart_minimaldata.dart';
import 'package:test/test.dart';

import 'fixtures.dart' as fixtures;

void main() {
  group('dart_minimaldata', () {
    for (var f in fixtures.valid) {
      test('Valid for ${f.description}', () {
        expect(bip62(f.hex), true);
      });
    }
    for (var f in fixtures.invalid) {
      test('Valid for ${f.description}', () {
        expect(bip62(f.hex), false);
      });
    }
  });
}
