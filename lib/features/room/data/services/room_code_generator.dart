import 'dart:math';

class RoomCodeGenerator {
  RoomCodeGenerator([Random? random]) : _random = random ?? Random.secure();

  static const codeLength = 6;

  final Random _random;

  String generate() => List.generate(
    codeLength,
    (index) => index == 0 ? _random.nextInt(9) + 1 : _random.nextInt(10),
  ).join();
}
