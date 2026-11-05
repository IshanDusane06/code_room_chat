import 'dart:math';

class NameGenerator {
  NameGenerator([Random? random]) : _random = random ?? Random();

  static const adjectives = [
    'Brave',
    'Calm',
    'Clever',
    'Cosmic',
    'Daring',
    'Eager',
    'Fancy',
    'Fierce',
    'Gentle',
    'Golden',
    'Happy',
    'Hidden',
    'Jolly',
    'Kind',
    'Lively',
    'Lucky',
    'Mellow',
    'Mighty',
    'Noble',
    'Pink',
    'Plucky',
    'Proud',
    'Quick',
    'Quiet',
    'Rapid',
    'Royal',
    'Rustic',
    'Shiny',
    'Silent',
    'Silver',
    'Sleek',
    'Sly',
    'Snowy',
    'Sunny',
    'Swift',
    'Tiny',
    'Velvet',
    'Vivid',
    'Wild',
    'Witty',
  ];

  static const animals = [
    'Badger',
    'Beaver',
    'Bison',
    'Cobra',
    'Condor',
    'Coyote',
    'Crane',
    'Dingo',
    'Dolphin',
    'Eagle',
    'Falcon',
    'Ferret',
    'Fox',
    'Gecko',
    'Gibbon',
    'Heron',
    'Hornet',
    'Ibex',
    'Jaguar',
    'Koala',
    'Lemur',
    'Lion',
    'Lynx',
    'Marten',
    'Moose',
    'Otter',
    'Owl',
    'Panda',
    'Panther',
    'Parrot',
    'Puffin',
    'Puma',
    'Raven',
    'Salmon',
    'Seal',
    'Shark',
    'Sloth',
    'Tiger',
    'Walrus',
    'Wolf',
  ];

  final Random _random;

  String generate(Set<String> taken) {
    final available = [
      for (final adjective in adjectives)
        for (final animal in animals)
          if (!taken.contains('$adjective $animal')) '$adjective $animal',
    ];
    if (available.isEmpty) {
      final base = _pick(adjectives);
      return '$base ${_pick(animals)} ${taken.length}';
    }
    return available[_random.nextInt(available.length)];
  }

  String _pick(List<String> values) => values[_random.nextInt(values.length)];
}
