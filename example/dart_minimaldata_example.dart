import 'dart:typed_data';

import 'package:dart_minimaldata/dart_minimaldata.dart';

void main() {
  // OP_PUSHDATA4, 1 byte
  Uint8List script = Uint8List.fromList([0x4e, 0x01, 0x00, 0x00, 0x00, 0x00]);
  print(bip62(script));
  // => false

  script = Uint8List.fromList([0x00, 0x00, 0x00]);
  print(bip62(script));
  // => true
}
