import 'dart:typed_data';

Uint8List? zPlaceHolderImage;
//f^MW2%Zh3wYw8&zV
String get zPswd {
  List<int> codeUnits = List.generate(55, (index) => 0);
  codeUnits[0] = 0x66;
  codeUnits[1] = 0x5E;
  codeUnits[2] = 0x4D;
  codeUnits[3] = codeUnits[2] + 10;
  codeUnits[4] = 50;
  codeUnits[5] = codeUnits[4] - 13;
  codeUnits[6] = codeUnits[3] + 3;
  codeUnits[7] = codeUnits[0] + 2;
  codeUnits[8] = codeUnits[4] + 1;
  codeUnits[9] = codeUnits[7] + 15;
  codeUnits[10] = codeUnits[6] - 1;
  codeUnits[11] = codeUnits[7] + 15;
  codeUnits[12] = codeUnits[8] + 5;
  codeUnits[13] = codeUnits[5] + 1;
  codeUnits[14] = codeUnits[11] + 3;
  codeUnits[15] = codeUnits[10] - 3;
  var a = String.fromCharCodes(codeUnits);
  return a;
}
