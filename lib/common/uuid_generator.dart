import 'dart:math';

import 'package:meta/meta.dart';

int _pseudoRandomNumberGenerator(int max) => Random.secure().nextInt(max);

List<_HexDigit> randomHexDigitListGenerator([int listSize = 2]) =>
    List<_HexDigit>.generate(
      listSize,
      (index) => _HexDigit(
        integer: _pseudoRandomNumberGenerator(16),
      ),
    );

List<_HexOctet> randomHexOctetListGenerator(int listSize) =>
    List<_HexOctet>.generate(
      listSize,
      (index) => _HexOctet(
        hexDigits: randomHexDigitListGenerator(),
      ),
    );

class UUIDGenerator {
  final _node = _UUIDField(6);
  final _timeLow = _UUIDField(4);
  final _timeMid = _UUIDField(2);
  final _clockSeqLow = _UUIDField(1);

  //setting for UUID Version 4
  final _timeHighAndVersion = _UUIDField(
    2,
    hexOctets: <_HexOctet>[
      _HexOctet(
        hexDigits: <_HexDigit>[
          _HexDigit(integer: 0),
          _HexDigit(integer: 1),
        ],
      ),
      _HexOctet(
        hexDigits: <_HexDigit>[
          _HexDigit(integer: 0),
          _HexDigit(integer: 0),
        ],
      ),
    ],
  );

  //setting for UUID Variant 1
  final _clockSeqHighAndReserved = _UUIDField(
    1,
    hexOctets: <_HexOctet>[
      _HexOctet(
        hexDigits: <_HexDigit>[
          _HexDigit(integer: 0),
          _HexDigit(integer: 1),
        ],
      ),
    ],
  );

  String get uuid => <String>[
        _timeLow.bits,
        _timeMid.bits,
        _timeHighAndVersion.bits,
        <String>[
          _clockSeqHighAndReserved.bits,
          _clockSeqLow.bits,
        ].join(),
        _node.bits,
      ].join('-');
}

class _UUIDField {
  _UUIDField(
    this.fieldSize, {
    this.hexOctets,
  })  : assert(fieldSize != null),
        assert(
          hexOctets == null ||
              (hexOctets != null && hexOctets.length == fieldSize),
        );

  final List<_HexOctet> hexOctets;
  final int fieldSize;

  List<_HexOctet> _hexOctets() =>
      hexOctets ?? randomHexOctetListGenerator(fieldSize);

  String get encodedBits {
    final _integerEncodedList = _hexOctets()
      ..map(
        (octet) => BigInt.parse(octet.digits, radix: 16),
      ).toList()
      ..sort();

    return _integerEncodedList.reversed.toList().join();
  }

  String get bits => _hexOctets()
      .map(
        (octet) => octet.digits,
      )
      .toList()
      .join();
}

class _HexOctet {
  _HexOctet({this.hexDigits})
      : assert(
          hexDigits == null || (hexDigits != null && hexDigits.length == 2),
        );

  final List<_HexDigit> hexDigits;

  List<String> _hexDigitsUnsigned() {
    final _digits = hexDigits ?? randomHexDigitListGenerator();

    return _digits.map((digit) => digit.unsignedBit).toList();
  }

  String get digits => _hexDigitsUnsigned().join();
}

class _HexDigit {
  _HexDigit({@required this.integer}) : assert(integer != null);

  final int integer;

  String get unsignedBit => integer.toRadixString(16).toLowerCase();
}
