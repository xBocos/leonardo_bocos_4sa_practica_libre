import 'package:flutter/material.dart';

/// Este widget representa un botón animado de carrito de compras.
/// Al ser presionado, ejecuta una animación de escala y llama a un callback definido.
class PizzaCartButton extends StatefulWidget {
  const PizzaCartButton({super.key, required this.onTap});

  /// Función que se ejecutará al presionar el botón.
  final VoidCallback onTap;

  @override
  PizzaCartButtonState createState() => PizzaCartButtonState();
}

class PizzaCartButtonState extends State<PizzaCartButton>
    with SingleTickerProviderStateMixin {
  // Controlador de animación para manejar la animación del botón.
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de animación con los límites y duración especificados.
    _animationController = AnimationController(
      vsync: this, // Sincroniza la animación con el estado del widget.
      lowerBound: 1.0, // Tamaño normal del botón.
      upperBound: 1.5, // Tamaño máximo durante la animación.
      duration: const Duration(
          milliseconds: 150), // Duración de la animación al expandir.
      reverseDuration: const Duration(
          milliseconds: 200), // Duración de la animación al contraer.
    );
  }

  @override
  void dispose() {
    // Libera los recursos del controlador de animación cuando el widget se destruye.
    _animationController.dispose();
    super.dispose();
  }

  /// Ejecuta la animación de escala del botón.
  Future<void> _animateButton() async {
    await _animationController.forward(from: 0.0); // Expande el botón.
    await _animationController.reverse(); // Contrae el botón.
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(); // Ejecuta la función proporcionada en onTap.
        _animateButton(); // Inicia la animación del botón.
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            // Escala el botón dinámicamente según el valor de la animación.
            scale: 2 - _animationController.value,
            child: child, // El contenido del botón.
          );
        },
        child: Container(
          // Diseño visual del botón.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), // Esquinas redondeadas.
            gradient: LinearGradient(
              // Gradiente de color para el fondo del botón.
              begin: Alignment
                  .topCenter, // Gradiente empieza en la parte superior.
              end: Alignment
                  .bottomCenter, // Gradiente termina en la parte inferior.
              colors: [
                Colors.orange.withOpacity(
                    0.5), // Naranja con opacidad para la parte superior.
                Colors.orange, // Naranja sólido para la parte inferior.
              ],
            ),
            boxShadow: const [
              // Sombra para darle un efecto de profundidad.
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0, // Suavidad de la sombra.
                offset: Offset(0.0, 4.0), // Desplazamiento de la sombra.
                spreadRadius: 4.0, // Expansión de la sombra.
              ),
            ],
          ),
          child: const Icon(
            // Icono del carrito de compras.
            Icons.add_shopping_cart_outlined, // Ícono del carrito de compras.
            color: Colors.white, // Color blanco para el icono.
            size: 35, // Tamaño del icono.
          ),
        ),
      ),
    );
  }
}
