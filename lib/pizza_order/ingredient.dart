import 'package:flutter/rendering.dart';

class Ingredient {
  const Ingredient(
    this.image,
    this.imageUnit,
    this.positions,
  );

  final String image;
  final String imageUnit;
  final List<Offset> positions;

  bool compare(Ingredient ingredient) => ingredient.image == image;
}

final ingredients = const <Ingredient>[
  Ingredient(
    'lib/images/chili.png',
    'lib/images/chili_unit.png',
    <Offset>[
      Offset(0.2, 0.2),
      Offset(0.6, 0.2),
      Offset(0.4, 0.25),
      Offset(0.5, 0.3),
      Offset(0.4, 0.65),
    ],
  ),
  Ingredient(
    'lib/images/mushroom.png',
    'lib/images/mushroom_unit.png',
    <Offset>[
      Offset(0.2, 0.35),
      Offset(0.65, 0.35),
      Offset(0.3, 0.23),
      Offset(0.5, 0.2),
      Offset(0.3, 0.5),
    ],
  ),
  Ingredient(
    'lib/images/olive.png',
    'lib/images/olive_unit.png',
    <Offset>[
      Offset(0.25, 0.5),
      Offset(0.4, 0.4),
      Offset(0.2, 0.3),
      Offset(0.4, 0.2),
      Offset(0.2, 0.45),
    ],
  ),
  Ingredient(
    'lib/images/onion.png',
    'lib/images/onion.png',
    <Offset>[
      Offset(0.2, 0.65),
      Offset(0.65, 0.3),
      Offset(0.25, 0.25),
      Offset(0.45, 0.35),
      Offset(0.4, 0.65),
    ],
  ),
  Ingredient(
    'lib/images/pea.png',
    'lib/images/pea_unit.png',
    <Offset>[
      Offset(0.2, 0.35),
      Offset(0.65, 0.35),
      Offset(0.3, 0.23),
      Offset(0.5, 0.2),
      Offset(0.3, 0.5),
    ],
  ),
  Ingredient(
    'lib/images/pickle.png',
    'lib/images/pickle_unit.png',
    <Offset>[
      Offset(0.2, 0.65),
      Offset(0.65, 0.3),
      Offset(0.25, 0.25),
      Offset(0.45, 0.35),
      Offset(0.4, 0.65),
    ],
  ),
  Ingredient(
    'lib/images/potato.png',
    'lib/images/potato_unit.png',
    <Offset>[
      Offset(0.2, 0.2),
      Offset(0.6, 0.2),
      Offset(0.4, 0.25),
      Offset(0.5, 0.3),
      Offset(0.4, 0.65),
    ],
  ),
];
