import 'dart:math';

import 'package:meta/meta.dart';

class UUIDGenerator {
  UUIDGenerator._({
    @required this.node,
    @required this.timeLow,
    @required this.timeMid,
    @required this.timeHighAndVersion,
    @required this.clockSeqLow,
    @required this.clockSeqHighAndReserved,
  })  : assert(node != null),
        assert(timeLow != null),
        assert(timeMid != null),
        assert(timeHighAndVersion != null),
        assert(clockSeqLow != null),
        assert(clockSeqHighAndReserved != null);

  factory UUIDGenerator.version4() => UUIDGenerator._(
        node: _UUIDField(6),
        timeLow: _UUIDField(4),
        timeMid: _UUIDField(2),
        timeHighAndVersion: _UUIDField(
          2,
          hexOctets: <_HexOctet>[
            _HexOctet(
              hexDigits: <_HexDigit>[
                _HexDigit(0),
                _HexDigit(1),
              ],
            ),
            _HexOctet(
              hexDigits: <_HexDigit>[
                _HexDigit(0),
                _HexDigit(0),
              ],
            ),
          ],
        ),
        clockSeqLow: _UUIDField(1),
        clockSeqHighAndReserved: _UUIDField(
          1,
          hexOctets: <_HexOctet>[
            _HexOctet(
              hexDigits: <_HexDigit>[
                _HexDigit(0),
                _HexDigit(1),
              ],
            ),
          ],
        ),
      );

  final _UUIDField node;
  final _UUIDField timeLow;
  final _UUIDField timeMid;
  final _UUIDField timeHighAndVersion;
  final _UUIDField clockSeqLow;
  final _UUIDField clockSeqHighAndReserved;

  String get uuid => <String>[
        timeLow.bits,
        timeMid.bits,
        timeHighAndVersion.bits,
        <String>[
          clockSeqHighAndReserved.bits,
          clockSeqLow.bits,
        ].join(),
        node.bits,
      ].join('-');
}

class _UUIDField {
  _UUIDField(
    this.listSize, {
    this.hexOctets,
  })  : assert(listSize != null),
        assert(
          hexOctets == null ||
              (hexOctets != null && hexOctets.length == listSize),
        );

  final List<_HexOctet> hexOctets;
  final int listSize;

  List<_HexOctet> _randomHexOctetListGenerator(int listSize) =>
      List<_HexOctet>.generate(
        listSize,
        (index) => _HexOctet(),
      );

  List<_HexOctet> _hexOctets() =>
      hexOctets ?? _randomHexOctetListGenerator(listSize);

  String get bits => _hexOctets().map((octet) => octet.digits).toList().join();
}

class _HexOctet {
  _HexOctet({this.hexDigits})
      : assert(
          hexDigits == null || (hexDigits != null && hexDigits.length == 2),
        );

  final List<_HexDigit> hexDigits;

  List<_HexDigit> _randomHexDigitListGenerator([int listSize = 2]) =>
      List<_HexDigit>.generate(
        listSize,
        (index) => _HexDigit(),
      );

  List<String> _hexDigitsUnsigned() {
    final _hexDigits = hexDigits ?? _randomHexDigitListGenerator();

    return _hexDigits.map((digit) => digit.unsignedBit).toList();
  }

  String get digits => _hexDigitsUnsigned().join();
}

class _HexDigit {
  _HexDigit([this.decimalDigit]);

  final int decimalDigit;

  String get unsignedBit {
    final _decimalDigit = decimalDigit ?? Random.secure().nextInt(16);

    return _decimalDigit.toRadixString(16);
  }
}
