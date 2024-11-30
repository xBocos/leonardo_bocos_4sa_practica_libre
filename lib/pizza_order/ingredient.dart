import 'package:flutter/rendering.dart';

/// Representa un ingrediente con una imagen principal, una unidad de imagen asociada
/// y una lista de posiciones donde puede aparecer en una interfaz.
class Ingredient {
  const Ingredient(
    this.image, // Ruta de la imagen principal del ingrediente.
    this.imageUnit, // Ruta de la imagen de la unidad del ingrediente.
    this.positions, // Lista de posiciones (como offsets) donde aparece el ingrediente.
  );

  final String image; // Ruta de la imagen principal del ingrediente.
  final String imageUnit; // Ruta de la imagen de la unidad del ingrediente.
  final List<Offset> positions; // Lista de posiciones relativas (x, y).

  /// Compara este ingrediente con otro basado en la imagen principal.
  /// Devuelve true si las imágenes coinciden.
  bool compare(Ingredient ingredient) => ingredient.image == image;
}

/// Lista de ingredientes predefinidos con imágenes y posiciones.
const ingredients = <Ingredient>[
  Ingredient(
    'lib/images/chili.png', // Imagen principal del chile.
    'lib/images/chili_unit.png', // Imagen de la unidad del chile.
    <Offset>[
      Offset(0.2, 0.2), // Posición relativa 1.
      Offset(0.6, 0.2), // Posición relativa 2.
      Offset(0.4, 0.25), // Posición relativa 3.
      Offset(0.5, 0.3), // Posición relativa 4.
      Offset(0.4, 0.65), // Posición relativa 5.
    ],
  ),
  Ingredient(
    'lib/images/mushroom.png', // Imagen principal del champiñón.
    'lib/images/mushroom_unit.png', // Imagen de la unidad del champiñón.
    <Offset>[
      Offset(0.2, 0.35), // Posición relativa 1.
      Offset(0.65, 0.35), // Posición relativa 2.
      Offset(0.3, 0.23), // Posición relativa 3.
      Offset(0.5, 0.2), // Posición relativa 4.
      Offset(0.3, 0.5), // Posición relativa 5.
    ],
  ),
  Ingredient(
    'lib/images/olive.png', // Imagen principal de la aceituna.
    'lib/images/olive_unit.png', // Imagen de la unidad de la aceituna.
    <Offset>[
      Offset(0.25, 0.5), // Posición relativa 1.
      Offset(0.4, 0.4), // Posición relativa 2.
      Offset(0.2, 0.3), // Posición relativa 3.
      Offset(0.4, 0.2), // Posición relativa 4.
      Offset(0.2, 0.45), // Posición relativa 5.
    ],
  ),
  Ingredient(
    'lib/images/onion.png', // Imagen principal de la cebolla.
    'lib/images/onion.png', // Imagen de la unidad de la cebolla.
    <Offset>[
      Offset(0.2, 0.65), // Posición relativa 1.
      Offset(0.65, 0.3), // Posición relativa 2.
      Offset(0.25, 0.25), // Posición relativa 3.
      Offset(0.45, 0.35), // Posición relativa 4.
      Offset(0.4, 0.65), // Posición relativa 5.
    ],
  ),
  Ingredient(
    'lib/images/pea.png', // Imagen principal del guisante.
    'lib/images/pea_unit.png', // Imagen de la unidad del guisante.
    <Offset>[
      Offset(0.2, 0.35), // Posición relativa 1.
      Offset(0.65, 0.35), // Posición relativa 2.
      Offset(0.3, 0.23), // Posición relativa 3.
      Offset(0.5, 0.2), // Posición relativa 4.
      Offset(0.3, 0.5), // Posición relativa 5.
    ],
  ),
  Ingredient(
    'lib/images/pickle.png', // Imagen principal del pepinillo.
    'lib/images/pickle_unit.png', // Imagen de la unidad del pepinillo.
    <Offset>[
      Offset(0.2, 0.65), // Posición relativa 1.
      Offset(0.65, 0.3), // Posición relativa 2.
      Offset(0.25, 0.25), // Posición relativa 3.
      Offset(0.45, 0.35), // Posición relativa 4.
      Offset(0.4, 0.65), // Posición relativa 5.
    ],
  ),
  Ingredient(
    'lib/images/potato.png', // Imagen principal de la papa.
    'lib/images/potato_unit.png', // Imagen de la unidad de la papa.
    <Offset>[
      Offset(0.2, 0.2), // Posición relativa 1.
      Offset(0.6, 0.2), // Posición relativa 2.
      Offset(0.4, 0.25), // Posición relativa 3.
      Offset(0.5, 0.3), // Posición relativa 4.
      Offset(0.4, 0.65), // Posición relativa 5.
    ],
  ),
];
