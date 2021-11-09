import 'dart:typed_data';

import 'package:dart_bitcoin_ops/dart_bitcoin_ops.dart';
import 'package:dart_bitcoin_pushdata/dart_bitcoin_pushdata.dart' as push_data;

/// Maximum Script Element Size
///
/// Reference: https://github.com/bitcoin/bitcoin/blob/master/src/script/script.h#L22
const _maxScriptElementSize = 520;

/// Check is minimal push
///
/// Reference: https://github.com/bitcoin/bitcoin/blob/d612837814020ae832499d18e6ee5eb919a87907/src/script/interpreter.cpp#L209
bool _checkMinimalPush(int opcode, Uint8List data) {
  // Could have used OP_0.
  if (data.isEmpty) {
    return opcode == OPS['OP_0']!;

    // Could have used OP_1 .. OP_16.
  } else if (data.length == 1 && data[0] >= 1 && data[0] <= 16) {
    return opcode == OPS['OP_1']! + (opcode - 1);

    // Could have used OP_1NEGATE.
  } else if (data.length == 1 && opcode == 0x81) {
    return opcode == OPS['OP_1NEGATE']!;

    // Could have used a direct push (opcode indicating number of bytes pushed + those bytes).
  } else if (data.length <= 75) {
    return opcode == data.length;

    // Could have used OP_PUSHDATA1.
  } else if (data.length <= 255) {
    return opcode == OPS['OP_PUSHDATA1']!;

    // Could have used OP_PUSHDATA2.
  } else if (data.length <= 65535) {
    return opcode == OPS['OP_PUSHDATA2']!;
  }

  return false;
}

/// Check BIP62
///
/// Reference: https://github.com/bitcoin/bips/blob/master/bip-0062.mediawiki
bool bip62(Uint8List buffer) {
  int i = 0;

  while (i < buffer.length) {
    var opcode = buffer[i];

    // is this a data PUSH?
    if (opcode >= 0 && opcode <= OPS['OP_PUSHDATA4']!) {
      var d = push_data.decode(buffer, i);

      // did reading a pushDataInt fail? empty script
      if (d == null) return false;
      i += d.size;

      // attempt to read too much data? empty script
      if (i + d.number > buffer.length) return false;

      Uint8List data = buffer.sublist(i, i + d.number);
      i += d.number;

      if (d.number > _maxScriptElementSize) return false;
      if (!_checkMinimalPush(opcode, data)) return false;

      // opcode
    } else {
      ++i;
    }
  }

  return true;
}
