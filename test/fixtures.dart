import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';

Uint8List _parseHex(String data) {
  return Uint8List.fromList(hex.decode(data));
}

class Fixture {
  String description;
  Uint8List hex;

  Fixture.fromJSON(Map<String, dynamic> data)
      : description = data['description'],
        hex = _parseHex(data['hex']);
}

String _jsonString = File('test/fixtures.json').readAsStringSync();
Map<String, dynamic> _json = json.decode(_jsonString);

List<Fixture> valid = _json['valid']
    .map((e) => Fixture.fromJSON(Map<String, String>.from(e)))
    .cast<Fixture>()
    .toList();

List<Fixture> invalid = _json['invalid']
    .map((e) => Fixture.fromJSON(Map<String, String>.from(e)))
    .cast<Fixture>()
    .toList();
