import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart' show ChangeNotifier, ValueNotifier;
import 'package:flutter/rendering.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/ingredient.dart';

// Esta clase contiene metadatos relacionados con la pizza, como la imagen (en bytes), posición y tamaño.
class PizzaMetadata {
  const PizzaMetadata(this.imageBytes, this.position, this.size);
  final Uint8List imageBytes; // La imagen de la pizza convertida en bytes.
  final Offset position; // La posición en la pantalla de la pizza.
  final Size size; // El tamaño de la pizza.
}

// Enum para definir los tamaños de pizza.
enum PizzaSizeValue {
  s, // Tamaño pequeño
  m, // Tamaño mediano
  l, // Tamaño grande
}

// Esta clase mantiene el estado del tamaño de la pizza.
class PizzaSizeState {
  PizzaSizeState(this.value)
      : factor = _getFactorBySize(
            value); // Determina el factor de escala según el tamaño.
  final PizzaSizeValue value; // El valor del tamaño de la pizza.
  final double
      factor; // Factor de escala que se utiliza para ajustar el tamaño de la pizza.

  // Método que devuelve un factor de escala según el tamaño de la pizza.
  static double _getFactorBySize(PizzaSizeValue value) {
    switch (value) {
      case PizzaSizeValue.s:
        return 0.75; // Para pizza pequeña (s) el factor es 0.75.
      case PizzaSizeValue.m:
        return 0.85; // Para pizza mediana (m) el factor es 0.85.
      case PizzaSizeValue.l:
        return 1.0; // Para pizza grande (l) el factor es 1.0.
    }
  }
}

// Valor inicial para el total de ingredientes en la pizza.
const initialTotal = 15;

// Clase que maneja el estado y las acciones de la orden de pizza (como agregar o quitar ingredientes).
class PizzaOrderBloc extends ChangeNotifier {
  final listIngredients = <Ingredient>[]; // Lista de ingredientes en la pizza.
  final notifierTotal =
      ValueNotifier(initialTotal); // Notificador para el total de ingredientes.
  final notifierDeletedIngredient = ValueNotifier<Ingredient?>(
      null); // Notificador para un ingrediente eliminado.
  final notifierFocused =
      ValueNotifier(false); // Notificador para si la pizza está enfocada.
  final notifierPizzaSize = ValueNotifier<PizzaSizeState>(PizzaSizeState(
      PizzaSizeValue.m)); // Notificador para el tamaño de la pizza.
  final notifierPizzaBoxAnimation = ValueNotifier(
      false); // Notificador para la animación de la caja de pizza.
  final notifierImagePizza = ValueNotifier<PizzaMetadata?>(
      null); // Notificador para la imagen de la pizza.
  final notifierCartIconAnimation = ValueNotifier(
      0); // Notificador para la animación del ícono del carrito de compras.

  get bloc => null;

  // Método para agregar un ingrediente a la pizza y actualizar el total.
  void addIngredient(Ingredient ingredient) {
    listIngredients.add(ingredient); // Agrega el ingrediente a la lista.
    notifierTotal.value++; // Incrementa el total de ingredientes.
  }

  // Método para remover un ingrediente de la pizza y actualizar el total.
  void removeIngredient(Ingredient ingredient) {
    listIngredients.remove(ingredient); // Remueve el ingrediente de la lista.
    notifierTotal.value--; // Decrementa el total de ingredientes.
    notifierDeletedIngredient.value =
        ingredient; // Notifica qué ingrediente fue eliminado.
  }

  // Método para restablecer el ingrediente eliminado (si es necesario).
  void refreshDeletedIngredient() {
    notifierDeletedIngredient.value =
        null; // Reinicia el ingrediente eliminado.
  }

  // Método para verificar si un ingrediente está presente en la pizza.
  bool containsIngredient(Ingredient ingredient) {
    for (Ingredient i in listIngredients) {
      if (i.compare(ingredient)) {
        // Compara los ingredientes.
        return true; // Si se encuentra, retorna verdadero.
      }
    }
    return false; // Si no se encuentra, retorna falso.
  }

  // Método para resetear el estado de la pizza (limpiar ingredientes, restaurar total, etc.).
  void reset() {
    notifierPizzaBoxAnimation.value = false; // Detiene la animación de la caja.
    notifierImagePizza.value = null; // Elimina la imagen de la pizza.
    listIngredients.clear(); // Limpia la lista de ingredientes.
    notifierTotal.value = initialTotal; // Restaura el total a su valor inicial.
    notifierCartIconAnimation.value++; // Incrementa la animación del carrito.
  }

  // Método para iniciar la animación de la caja de pizza.
  void startPizzaBoxAnimation() {
    notifierPizzaBoxAnimation.value = true; // Activa la animación de la caja.
  }

  // Método para convertir un RenderRepaintBoundary en una imagen de la pizza.
  Future<void> transformToImage(RenderRepaintBoundary boundary) async {
    final position =
        boundary.localToGlobal(Offset.zero); // Obtiene la posición de la pizza.
    final size = boundary.size; // Obtiene el tamaño de la pizza.
    final image =
        await boundary.toImage(); // Convierte el boundary a una imagen.
    ByteData? byteData = await image.toByteData(
        format: ImageByteFormat.png); // Convierte la imagen a formato PNG.
    notifierImagePizza.value = PizzaMetadata(byteData!.buffer.asUint8List(),
        position, size); // Notifica los metadatos de la imagen.
  }
}
