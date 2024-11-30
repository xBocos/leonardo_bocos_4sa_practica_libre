import 'package:flutter/material.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/ingredient.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_order_provider.dart';

// Tamaño de los elementos de los ingredientes en la interfaz de usuario.
const itemSize = 45.0;

/// Widget principal que muestra la lista de ingredientes disponibles para la pizza.
/// Esta lista se muestra de forma horizontal y se actualiza cuando el estado de los ingredientes cambia.
class PizzaIngredients extends StatelessWidget {
  const PizzaIngredients({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene la instancia del Bloc para manejar el estado de los ingredientes.
    final bloc = PizzaOrderProvider.of(context);

    return ValueListenableBuilder(
      // Se escucha el valor de notifierTotal que es el estado de la lista de ingredientes.
      valueListenable: bloc.notifierTotal,
      builder: (context, value, _) {
        // Se construye una lista horizontal de ingredientes.
        return ListView.builder(
          scrollDirection: Axis
              .horizontal, // Configura la dirección del scroll a horizontal.
          itemCount:
              ingredients.length, // Cantidad total de ingredientes en la lista.
          itemBuilder: (context, index) {
            final ingredient = ingredients[index];
            return PizzaIngredientItem(
              ingredient: ingredient, // Pasar el ingrediente a cada ítem.
              exist: bloc.containsIngredient(
                  ingredient), // Verifica si el ingrediente está en la pizza.
              onTap: () {
                bloc.removeIngredient(
                    ingredient); // Elimina el ingrediente de la pizza al hacer tap.
              },
            );
          },
        );
      },
    );
  }
}

/// Widget que representa un ingrediente individual en la lista.
/// Muestra el ingrediente con una imagen y permite eliminarlo al tocarlo.
class PizzaIngredientItem extends StatelessWidget {
  const PizzaIngredientItem({
    super.key,
    required this.ingredient, // El ingrediente que se va a mostrar.
    required this.exist, // Si el ingrediente ya está en la pizza.
    required this.onTap, // Acción para eliminar el ingrediente.
  });

  final Ingredient ingredient;
  final bool exist;
  final VoidCallback onTap;

  /// Construye el contenido visual del ingrediente, con opción de mostrar o no la imagen.
  Widget _buildChild({bool withImage = true}) {
    return GestureDetector(
      onTap: exist
          ? onTap
          : null, // Si el ingrediente existe, se puede eliminar al hacer tap.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Container(
          height:
              itemSize, // Establece el tamaño del contenedor para el ingrediente.
          width: itemSize,
          decoration: BoxDecoration(
            color: const Color(0xFFF5EED3), // Color de fondo del ingrediente.
            shape: BoxShape.circle, // Forma circular.
            border: exist
                ? Border.all(color: Colors.red, width: 2)
                : null, // Si el ingrediente existe, bordea con rojo.
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: withImage
                ? Image.asset(
                    // Si withImage es verdadero, muestra la imagen del ingrediente.
                    ingredient.image,
                    fit: BoxFit
                        .contain, // Ajusta la imagen al contenedor sin distorsión.
                  )
                : SizedBox
                    .fromSize(), // Si withImage es falso, no muestra nada.
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: exist // Si el ingrediente está en la pizza, solo lo muestra.
          ? _buildChild()
          : Draggable(
              // Si el ingrediente no está en la pizza, permite que sea arrastrado.
              feedback: DecoratedBox(
                // Vista del ingrediente cuando se está arrastrando.
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 5.0,
                    )
                  ],
                ),
                child:
                    _buildChild(), // Muestra el mismo contenido del ingrediente al arrastrar.
              ),
              childWhenDragging: _buildChild(
                  withImage:
                      false), // Muestra solo el contorno cuando se está arrastrando.
              data: ingredient, // El ingrediente se pasa como datos del drag.
              child: _buildChild(), // Muestra el ingrediente normalmente.
            ),
    );
  }
}
