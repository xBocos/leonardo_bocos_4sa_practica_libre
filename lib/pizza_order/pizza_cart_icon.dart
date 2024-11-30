import 'package:flutter/material.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_order_provider.dart';

/// Widget que representa el ícono del carrito de compras, con una animación
/// de escala cuando el número de productos cambia. Además, muestra el contador
/// de elementos en el carrito sobre el ícono.
class PizzaCartIcon extends StatefulWidget {
  const PizzaCartIcon({super.key});

  @override
  State<PizzaCartIcon> createState() => _PizzaCartIconState();
}

class _PizzaCartIconState extends State<PizzaCartIcon>
    with SingleTickerProviderStateMixin {
  // Controlador de animación para la animación de escala del ícono del carrito.
  late AnimationController _controller;

  // Animaciones de escala para hacer crecer y encoger el ícono del carrito.
  late Animation<double> _animationScaleOut;
  late Animation<double> _animationScaleIn;

  // Contador de elementos en el carrito, que se actualiza dinámicamente.
  int counter = 0;

  @override
  void initState() {
    super.initState();

    // Inicializa el controlador de animación, con una duración de 600 ms.
    _controller = AnimationController(
      vsync: this, // Sincroniza la animación con el ciclo de vida del widget.
      duration: const Duration(milliseconds: 600),
    );

    // Animación para hacer que el ícono crezca (escala hacia afuera).
    _animationScaleOut = CurvedAnimation(
      curve: const Interval(0.0, 0.5),
      parent: _controller,
    );

    // Animación para hacer que el ícono vuelva a su tamaño original (escala hacia adentro).
    _animationScaleIn = CurvedAnimation(
      curve: const Interval(0.5, 1.0),
      parent: _controller,
    );

    // Después de que se renderice el widget, se registra un listener para actualizar el contador
    // del ícono del carrito a partir de un estado de bloc.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = PizzaOrderProvider.of(context);

      // Escucha cambios en el valor de notifierCartIconAnimation del bloc y actualiza el contador.
      bloc.notifierCartIconAnimation.addListener(() {
        counter = bloc.notifierCartIconAnimation.value;
        _controller.forward(from: 0.0); // Inicia la animación de escala.
      });
    });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Libera los recursos del controlador de animación cuando el widget se destruye.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder es usado para reconstruir el widget cuando la animación cambia.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, snapshot) {
        double? scale;
        const scaleFactor = 0.5;

        // Determina el valor de la escala según el progreso de la animación.
        if (_animationScaleOut.value < 1.0) {
          scale =
              1.0 + scaleFactor * _animationScaleOut.value; // Expande el ícono.
        } else if (_animationScaleIn.value <= 1.0) {
          scale = (1.0 + scaleFactor) -
              scaleFactor * _animationScaleIn.value; // Contrae el ícono.
        }

        return Transform.scale(
          alignment: Alignment.center,
          scale: scale, // Aplica la escala calculada al ícono.
          child: Stack(
            children: [
              // Ícono del carrito de compras.
              IconButton(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.brown,
                ),
                onPressed: () {
                  // Aquí podrías añadir lógica para mostrar el carrito de compras.
                },
              ),

              // Si la animación de expansión está en progreso, muestra el contador de elementos.
              if (_animationScaleOut.value > 0)
                Positioned(
                  top: 7,
                  right: 7,
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: _animationScaleOut
                        .value, // Escala la burbuja del contador.
                    child: CircleAvatar(
                      radius: 7,
                      backgroundColor:
                          Colors.red, // Fondo rojo para resaltar el contador.
                      child: Text(
                        counter
                            .toString(), // Muestra el número de elementos en el carrito.
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
