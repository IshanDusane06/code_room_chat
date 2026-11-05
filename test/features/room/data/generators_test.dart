import 'dart:math';

import 'package:code_room_chat_app/features/room/data/services/name_generator.dart';
import 'package:code_room_chat_app/features/room/data/services/room_code_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('name has an adjective and an animal', () {
    final parts = NameGenerator(Random(1)).generate({}).split(' ');

    expect(NameGenerator.adjectives, contains(parts[0]));
    expect(NameGenerator.animals, contains(parts[1]));
  });

  test('name avoids everything already taken', () {
    final all = {
      for (final adjective in NameGenerator.adjectives)
        for (final animal in NameGenerator.animals) '$adjective $animal',
    };
    all.remove('Brave Badger');

    expect(NameGenerator(Random(1)).generate(all), 'Brave Badger');
  });

  test('name stays unique when every combination is taken', () {
    final all = {
      for (final adjective in NameGenerator.adjectives)
        for (final animal in NameGenerator.animals) '$adjective $animal',
    };

    expect(all, isNot(contains(NameGenerator(Random(1)).generate(all))));
  });

  test('room code is six digits without a leading zero', () {
    final generator = RoomCodeGenerator(Random(1));
    for (var i = 0; i < 200; i++) {
      expect(generator.generate(), matches(RegExp(r'^[1-9][0-9]{5}$')));
    }
  });
}
