import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_cart_button.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_cart_icon.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_ingredients.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_order_bloc.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_order_provider.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_size_button.dart';
import 'ingredient.dart';

// Tamaño del botón flotante del carrito de pizza.
const _pizzaCartSize = 55.0;

/// Pantalla principal de detalles del pedido de pizza.
class PizzaOrderDetails extends StatefulWidget {
  const PizzaOrderDetails({super.key});

  @override
  State<PizzaOrderDetails> createState() => _PizzaOrderDetailsState();
}

class _PizzaOrderDetailsState extends State<PizzaOrderDetails> {
  // Instancia del bloque (Bloc) para manejar la lógica del pedido de pizza.
  final bloc = PizzaOrderBloc();

  @override
  Widget build(BuildContext context) {
    return PizzaOrderProvider(
      bloc: bloc, // Proporciona el bloc a los widgets descendientes.
      child: Scaffold(
        appBar: AppBar(
          // Título de la aplicación en el centro.
          title: const Center(
            child: Text(
              'New Orleans Pizza',
              style: TextStyle(
                color: Colors.brown,
                fontSize: 24,
              ),
            ),
          ),
          backgroundColor: Colors.white, // Color de fondo del AppBar.
          elevation: 0, // Sin sombra en el AppBar.
          actions: const [
            PizzaCartIcon(), // Ícono del carrito de pizzas.
          ],
        ),
        body: Stack(
          children: [
            // Contenedor principal de los detalles y los ingredientes.
            Positioned.fill(
              bottom: 50, // Deja espacio para el botón flotante.
              left: 10,
              right: 10,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(20), // Bordes redondeados.
                ),
                elevation: 10, // Sombra del Card.
                child: Column(
                  children: [
                    // Detalles de la pizza (ej. tamaño, descripción).
                    Expanded(
                      flex: 4, // Ocupa 4/6 de la altura disponible.
                      child: _PizzaDetails(),
                    ),
                    // Ingredientes de la pizza.
                    const Expanded(
                      flex: 2, // Ocupa 2/6 de la altura disponible.
                      child: PizzaIngredients(),
                    ),
                  ],
                ),
              ),
            ),
            // Botón flotante para añadir la pizza al carrito.
            Positioned(
              bottom: 25,
              height: _pizzaCartSize,
              width: _pizzaCartSize,
              left: MediaQuery.of(context).size.width / 2 -
                  _pizzaCartSize / 2, // Centra el botón.
              child: PizzaCartButton(
                onTap: () {
                  bloc.startPizzaBoxAnimation(); // Inicia la animación del carrito.
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget para los detalles de la pizza (ej. animaciones, ingredientes colocados).
class _PizzaDetails extends StatefulWidget {
  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<_PizzaDetails>
    with TickerProviderStateMixin {
  // Controlador de animaciones para los ingredientes.
  late AnimationController _animationController;
  // Controlador de rotación para animar la pizza.
  late AnimationController _animationRotationController;
  // Precio total inicial de la pizza.
  int total = 15;
  // Lista de animaciones aplicadas a los ingredientes.
  List<Animation> animationList = <Animation>[];
  // Dimensiones de la pizza para calcular posiciones relativas.
  late BoxConstraints _pizzaConstraints;

  // Clave global para acceder al widget de la pizza.
  final _keyPizza = GlobalKey();

  /// Construye los widgets de los ingredientes y los posiciona en la pizza.
  /// Si hay un ingrediente eliminado, se agrega temporalmente a la lista para su animación.
  Widget _buildIngredientsWidget(Ingredient? deletedIngredient) {
    List<Widget> elements = [];
    // Obtiene la lista de ingredientes actual del bloc.
    final listIngredients =
        List.from(PizzaOrderProvider.of(context).listIngredients);

    // Si hay un ingrediente eliminado, se agrega de vuelta para la animación.
    if (deletedIngredient != null) {
      listIngredients.add(deletedIngredient);
    }

    // Verifica si hay animaciones activas.
    if (animationList.isNotEmpty) {
      for (int i = 0; i < listIngredients.length; i++) {
        Ingredient ingredient = listIngredients[i];
        // Widget del ingrediente (imagen).
        final ingredientWidget = Image.asset(ingredient.imageUnit, height: 40);

        // Itera sobre las posiciones del ingrediente.
        for (int j = 0; j < ingredient.positions.length; j++) {
          final animation = animationList[j];
          final position = ingredient.positions[j];
          final positionX = position.dx; // Posición relativa en X.
          final positionY = position.dy; // Posición relativa en Y.

          // Si es el último ingrediente y la animación está activa, aplica movimiento.
          if (i == listIngredients.length - 1 &&
              _animationController.isAnimating) {
            double fromX = 0.0, fromY = 0.0;
            // Calcula el movimiento de las animaciones según su índice.
            if (j < 1) {
              fromX = -_pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = _pizzaConstraints.maxWidth * (1 - animation.value);
            } else if (j < 4) {
              fromY = -_pizzaConstraints.maxHeight * (1 - animation.value);
            } else {
              fromY = _pizzaConstraints.maxHeight * (1 - animation.value);
            }

            // Ajusta la opacidad según el progreso de la animación.
            final opacity = animation.value;

            // Si la animación tiene valor válido, renderiza el ingrediente animado.
            if (animation.value > 0) {
              elements.add(
                Opacity(
                  opacity: opacity,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        fromX + _pizzaConstraints.maxWidth * positionX,
                        fromY + _pizzaConstraints.maxHeight * positionY,
                      ),
                    child: ingredientWidget,
                  ),
                ),
              );
            }
          } else {
            // Si no hay animación activa, renderiza el ingrediente estático.
            elements.add(
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                    _pizzaConstraints.maxWidth * positionX,
                    _pizzaConstraints.maxHeight * positionY,
                  ),
                child: ingredientWidget,
              ),
            );
          }
        }
      }
      return Stack(
        children: elements, // Devuelve todos los ingredientes posicionados.
      );
    }
    return SizedBox
        .fromSize(); // Retorna un widget vacío si no hay animaciones.
  }

  /// Construye las animaciones para los ingredientes de la pizza.
  /// Cada ingrediente obtiene una animación con un intervalo y curva de movimiento específicos.
  void _buildIngredientsAnimation() {
    // Limpia la lista de animaciones previas para evitar duplicados.
    animationList.clear();

    // Agrega animaciones para cada ingrediente utilizando diferentes intervalos y curvas.
    animationList.add(CurvedAnimation(
      // Define el intervalo de tiempo (proporción del total) durante el cual esta animación ocurre.
      curve: const Interval(0.0, 0.8, curve: Curves.decelerate),
      // Asocia la animación al controlador principal (_animationController).
      parent: _animationController,
    ));
    animationList.add(CurvedAnimation(
      // Esta animación comienza más tarde en el tiempo (0.2) y termina en 0.8.
      curve: const Interval(0.2, 0.8, curve: Curves.decelerate),
      parent: _animationController,
    ));
    animationList.add(CurvedAnimation(
      // Esta animación tiene un inicio tardío (0.4) y cubre el resto del tiempo hasta 1.0.
      curve: const Interval(0.4, 1.0, curve: Curves.decelerate),
      parent: _animationController,
    ));
    animationList.add(CurvedAnimation(
      // Esta animación tiene un rango más corto (0.1 a 0.7).
      curve: const Interval(0.1, 0.7, curve: Curves.decelerate),
      parent: _animationController,
    ));
    animationList.add(CurvedAnimation(
      // Similar a las demás, pero comienza en 0.3 y dura hasta el final (1.0).
      curve: const Interval(0.3, 1.0, curve: Curves.decelerate),
      parent: _animationController,
    ));
  }

  /// Configuración inicial del estado del widget.
  @override
  void initState() {
    // Controlador para las animaciones de ingredientes.
    _animationController = AnimationController(
      vsync: this, // Sincroniza con el ticker del widget.
      duration: const Duration(milliseconds: 700), // Duración de la animación.
    );

    // Controlador para la animación de rotación de la pizza.
    _animationRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Duración de la rotación.
    );

    // Configuración inicial después de que se renderice el widget.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = PizzaOrderProvider.of(context);

      // Escucha cambios en el estado de la animación de la caja de pizza.
      bloc.notifierPizzaBoxAnimation.addListener(() {
        if (bloc.notifierPizzaBoxAnimation.value) {
          _addPizzaToCart(); // Inicia la animación de añadir la pizza al carrito.
        }
      });
    });

    // Llama al inicializador del estado padre.
    super.initState();
  }

  /// Limpieza de recursos al destruir el widget.
  @override
  void dispose() {
    // Libera los recursos de los controladores de animación.
    _animationController.dispose();
    _animationRotationController.dispose();
    super.dispose();
  }

  /// Construcción del widget.
  @override
  Widget build(BuildContext context) {
    // Accede al bloc que maneja el estado de la pizza.
    final bloc = PizzaOrderProvider.of(context);

    return Column(
      children: [
        Expanded(
          // Área interactiva donde se arrastran y sueltan los ingredientes.
          child: DragTarget<Ingredient>(
            onAccept: (ingredient) {
              print('onAccept');
              bloc.notifierFocused.value = false; // Marca como no enfocado.
              bloc.addIngredient(ingredient); // Añade el ingrediente.
              _buildIngredientsAnimation(); // Configura la animación de ingredientes.
              _animationController.forward(from: 0.0); // Inicia la animación.
            },
            onWillAccept: (ingredient) {
              print('onWillAccept');
              bloc.notifierFocused.value = true; // Marca como enfocado.
              return !bloc.containsIngredient(
                  ingredient!); // Acepta si no está ya en la pizza.
            },
            onLeave: (ingredient) {
              print('onLeave');
              bloc.notifierFocused.value = false; // Marca como no enfocado.
            },
            builder: (context, list, rejects) {
              return LayoutBuilder(builder: (context, constraints) {
                _pizzaConstraints =
                    constraints; // Guarda las restricciones del área.

                return ValueListenableBuilder<PizzaMetadata?>(
                  valueListenable: bloc.notifierImagePizza,
                  builder: (context, data, child) {
                    // Si hay datos de la pizza, inicia la animación de la caja.
                    if (data != null) {
                      Future.microtask(() => _startPizzaBoxAnimation(data));
                    }

                    return AnimatedOpacity(
                      duration: const Duration(
                          milliseconds: 60), // Animación de opacidad.
                      opacity:
                          data != null ? 0.0 : 1, // Oculta cuando hay datos.
                      child: ValueListenableBuilder<PizzaSizeState>(
                        valueListenable: bloc.notifierPizzaSize,
                        builder: (context, pizzaSize, _) {
                          return RepaintBoundary(
                            key:
                                _keyPizza, // Llave para capturar el área de renderizado.
                            child: RotationTransition(
                              turns: CurvedAnimation(
                                curve: Curves
                                    .elasticInOut, // Curva de rotación elástica.
                                parent: _animationRotationController,
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: ValueListenableBuilder<bool>(
                                      valueListenable: bloc.notifierFocused,
                                      builder: (context, focused, _) {
                                        return AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 400),
                                          height: focused
                                              ? constraints.maxHeight *
                                                  pizzaSize.factor
                                              : constraints.maxHeight *
                                                      pizzaSize.factor -
                                                  10,
                                          child: Stack(
                                            children: [
                                              DecoratedBox(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 15.0,
                                                      color: Colors.black26,
                                                      offset: Offset(0.0, 5.0),
                                                      spreadRadius: 5.0,
                                                    ),
                                                  ],
                                                ),
                                                child: Image.asset(
                                                    'lib/images/dish.png'), // Plato base.
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                    'lib/images/pizza-1.png'), // Pizza base.
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  ValueListenableBuilder<Ingredient?>(
                                    valueListenable:
                                        bloc.notifierDeletedIngredient,
                                    builder: (context, deletedIngredient, _) {
                                      _animateDeletedIngredient(
                                          deletedIngredient); // Maneja animación al eliminar.

                                      return AnimatedBuilder(
                                        animation: _animationController,
                                        builder: (context, _) {
                                          return _buildIngredientsWidget(
                                              deletedIngredient); // Construye los ingredientes.
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              });
            },
          ),
        ),
        const SizedBox(height: 5), // Espaciador.
        ValueListenableBuilder<int>(
          valueListenable: bloc.notifierTotal,
          builder: (context, totalValue, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(0.0, 0.0),
                        end: Offset(
                          0.0,
                          animation.value,
                        ),
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: Text(
                '\$$totalValue', // Total del pedido.
                key: UniqueKey(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 15),
        ValueListenableBuilder<PizzaSizeState>(
          valueListenable: bloc.notifierPizzaSize,
          builder: (context, pizzaSize, _) {
            // Botones para cambiar el tamaño de la pizza.
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PizzaSizeButton(
                  text: 'S',
                  onTap: () {
                    _updatePizzaSize(PizzaSizeValue.s);
                  },
                  selected: pizzaSize.value == PizzaSizeValue.s,
                ),
                PizzaSizeButton(
                  text: 'M',
                  onTap: () {
                    _updatePizzaSize(PizzaSizeValue.m);
                  },
                  selected: pizzaSize.value == PizzaSizeValue.m,
                ),
                PizzaSizeButton(
                  text: 'L',
                  onTap: () {
                    _updatePizzaSize(PizzaSizeValue.l);
                  },
                  selected: pizzaSize.value == PizzaSizeValue.l,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Método para animar la eliminación de un ingrediente.
  Future<void> _animateDeletedIngredient(Ingredient? deletedIngredient) async {
    if (deletedIngredient != null) {
      final bloc = PizzaOrderProvider.of(context);

      // Reproduce la animación en reversa para simular la eliminación.
      await _animationController.reverse(from: 1.0);

      // Actualiza el estado del ingrediente eliminado en el bloc.
      bloc.refreshDeletedIngredient();
    }
  }

  /// Método para actualizar el tamaño de la pizza.
  void _updatePizzaSize(PizzaSizeValue value) {
    final bloc = PizzaOrderProvider.of(context);

    // Cambia el tamaño de la pizza en el bloc.
    bloc.notifierPizzaSize.value = PizzaSizeState(value);

    // Reproduce la animación de rotación para indicar el cambio de tamaño.
    _animationRotationController.forward(from: 0.0);
  }

  /// Método para añadir la pizza al carrito.
  void _addPizzaToCart() {
    final bloc = PizzaOrderProvider.of(context);

    // Obtiene la representación visual del área de la pizza.
    RenderRepaintBoundary? boundary =
        _keyPizza.currentContext!.findRenderObject() as RenderRepaintBoundary?;

    // Convierte la pizza actual en una imagen para el carrito.
    bloc.transformToImage(boundary!);
  }

  /// Variable para manejar la animación de la caja de pizza en la interfaz.
  OverlayEntry? _overlayEntry;

  /// Método para iniciar la animación de la caja de pizza al añadir al carrito.
  void _startPizzaBoxAnimation(PizzaMetadata metadata) {
    final bloc = PizzaOrderProvider.of(context);

    // Comprueba si ya existe una animación en curso.
    if (_overlayEntry == null) {
      // Crea una nueva animación de caja de pizza.
      _overlayEntry = OverlayEntry(builder: (context) {
        return PizzaOrderAnimation(
          metadata: metadata, // Datos necesarios para la animación.
          onComplete: () {
            // Limpia la animación después de completarse.
            _overlayEntry?.remove();
            _overlayEntry = null;

            // Reinicia el estado del pedido en el bloc.
            bloc.reset();
          },
        );
      });

      // Inserta la animación en la superposición de la interfaz.
      Overlay.of(context).insert(_overlayEntry!);
    }
  }
}

/// Clase que representa la animación de agregar la pizza al carrito.
class PizzaOrderAnimation extends StatefulWidget {
  const PizzaOrderAnimation({
    super.key,
    required this.metadata, // Metadatos necesarios para la animación (posición, tamaño e imagen).
    required this.onComplete, // Callback que se ejecuta al completar la animación.
  });

  final PizzaMetadata metadata;
  final VoidCallback onComplete;

  @override
  State<PizzaOrderAnimation> createState() => _PizzaOrderAnimationState();
}

class _PizzaOrderAnimationState extends State<PizzaOrderAnimation>
    with SingleTickerProviderStateMixin {
  // Controlador de animaciones.
  late AnimationController _controller;

  // Animaciones individuales para diferentes etapas de la animación.
  late Animation<double>
      _pizzaScaleAnimation; // Escala de la pizza al reducirse.
  late Animation<double> _pizzaOpacityAnimation; // Desvanecimiento de la pizza.
  late Animation<double>
      _boxEnterScaleAnimation; // Escala inicial al entrar la caja.
  late Animation<double> _boxExitScaleAnimation; // Escala al salir la caja.
  late Animation<double>
      _boxExitToCartAnimation; // Movimiento de la caja hacia el carrito.

  @override
  void initState() {
    super.initState();

    // Configuración del controlador de animaciones.
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 2500), // Duración total de la animación.
    );

    // Configuración de las animaciones específicas.
    _pizzaScaleAnimation = Tween(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        curve:
            const Interval(0.0, 0.2), // Ocurre en los primeros 20% del tiempo.
        parent: _controller,
      ),
    );

    _pizzaOpacityAnimation = CurvedAnimation(
      curve: const Interval(0.2, 0.4), // Desvanecimiento entre el 20% y el 40%.
      parent: _controller,
    );

    _boxEnterScaleAnimation = CurvedAnimation(
      curve:
          const Interval(0.0, 0.2), // Entrada de la caja en los primeros 20%.
      parent: _controller,
    );

    _boxExitScaleAnimation = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        curve:
            const Interval(0.5, 0.7), // Escala de salida entre el 50% y el 70%.
        parent: _controller,
      ),
    );

    _boxExitToCartAnimation = CurvedAnimation(
      curve: const Interval(
          0.8, 1.0), // Movimiento al carrito entre el 80% y el 100%.
      parent: _controller,
    );

    // Listener para detectar cuando la animación se complete.
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete(); // Llama al callback proporcionado.
      }
    });

    // Inicia la animación.
    _controller.forward();
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Libera el controlador cuando el widget se destruye.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.metadata; // Obtiene los metadatos de la pizza.

    // Posiciona la animación en el lugar inicial de la pizza.
    return Positioned(
      top: metadata.position.dy,
      left: metadata.position.dx,
      width: metadata.size.width,
      height: metadata.size.height,
      child: GestureDetector(
        onTap: () {
          widget.onComplete(); // Completa la animación al hacer clic.
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, snapshot) {
            // Calcula la traslación de la caja hacia el carrito.
            final moveToX = _boxExitToCartAnimation.value > 0
                ? metadata.position.dx +
                    metadata.size.width / 2 * _boxExitToCartAnimation.value
                : 0.0;

            final moveToY = _boxExitToCartAnimation.value > 0
                ? -metadata.size.height / 1.5 * _boxExitToCartAnimation.value
                : 0.0;

            return Opacity(
              opacity:
                  1 - _boxExitToCartAnimation.value, // Gradualmente desaparece.
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..translate(
                      moveToX, moveToY) // Mueve la caja hacia el carrito.
                  ..rotateZ(_boxExitToCartAnimation.value) // Rotación opcional.
                  ..scale(_boxExitScaleAnimation
                      .value), // Cambia el tamaño de la caja.
                child: Transform.scale(
                  scale: 1 - _boxExitToCartAnimation.value,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      _buildBox(), // Construye la caja.

                      // Desvanecimiento y reducción de la pizza.
                      Opacity(
                        opacity: 1 - _pizzaOpacityAnimation.value,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..scale(_pizzaScaleAnimation
                                .value) // Cambia el tamaño de la pizza.
                            ..translate(
                              0.0,
                              20 *
                                  (1 -
                                      _pizzaOpacityAnimation
                                          .value), // Desplazamiento vertical.
                            ),
                          child: Image.memory(widget
                              .metadata.imageBytes), // Imagen de la pizza.
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Construye la representación visual de la caja utilizada en la animación.
  Widget _buildBox() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcula las dimensiones de la caja basadas en las restricciones del contenedor.
        final boxHeight = constraints.maxHeight /
            2.0; // Altura de la caja (mitad del contenedor).
        final boxWidth = constraints.maxWidth /
            2.0; // Ancho de la caja (mitad del contenedor).

        // Ángulos en grados para las animaciones de cierre de la caja.
        const minAngle = -45.0; // Ángulo inicial de la tapa de la caja.
        const maxAngle = -125.0; // Ángulo máximo de cierre de la caja.

        // Interpolación entre los ángulos de apertura y cierre según la animación de opacidad.
        final boxClosingValue = lerpDouble(
          minAngle,
          maxAngle,
          1 - _pizzaOpacityAnimation.value, // Calcula el progreso del cierre.
        );

        return Opacity(
          opacity: _boxEnterScaleAnimation
              .value, // Controla la visibilidad inicial de la caja.
          child: Transform.scale(
            scale: _boxEnterScaleAnimation
                .value, // Escala inicial de la caja al entrar.
            child: Stack(
              children: [
                // Parte interna inferior de la caja.
                Center(
                  child: Transform(
                    alignment: Alignment
                        .topCenter, // Ajusta el punto de rotación al centro superior.
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003) // Perspectiva para la rotación.
                      ..rotateX(
                        degreesToRads(
                            minAngle), // Rota la parte inferior un ángulo fijo.
                      ),
                    child: Image.asset(
                      "lib/images/box_inside.png", // Imagen de la parte inferior interna de la caja.
                      height: boxHeight,
                      width: boxWidth,
                    ),
                  ),
                ),
                // Parte superior de la caja, ajustada dinámicamente según el progreso de la animación.
                Center(
                  child: Transform(
                    alignment: Alignment
                        .topCenter, // Ajusta el punto de rotación al centro superior.
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003) // Perspectiva para la rotación.
                      ..rotateX(
                        degreesToRads(
                            boxClosingValue!), // Rota la parte superior según el valor interpolado.
                      ),
                    child: Image.asset(
                      "lib/images/box_inside.png", // Imagen de la parte superior interna de la caja.
                      height: boxHeight,
                      width: boxWidth,
                    ),
                  ),
                ),
                // Parte frontal de la caja, visible solo cuando el ángulo de cierre es mayor o igual a -90°.
                if (boxClosingValue >= -90)
                  Center(
                    child: Transform(
                      alignment: Alignment
                          .topCenter, // Ajusta el punto de rotación al centro superior.
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003) // Perspectiva para la rotación.
                        ..rotateX(
                          degreesToRads(
                              boxClosingValue), // Rota la parte frontal según el valor interpolado.
                        ),
                      child: Image.asset(
                        "lib/images/box_front.png", // Imagen de la parte frontal de la caja.
                        height: boxHeight,
                        width: boxWidth,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Convierte un ángulo en grados a radianes.
degreesToRads(deg) {
  return (deg * pi) / 180.0; // Fórmula de conversión.
}
