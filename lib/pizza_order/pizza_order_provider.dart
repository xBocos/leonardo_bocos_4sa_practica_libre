import 'package:flutter/material.dart';
import 'pizza_order_bloc.dart';

// Clase que proporciona el bloc de la orden de pizza a los widgets descendientes usando un InheritedWidget.
class PizzaOrderProvider extends InheritedWidget {
  final PizzaOrderBloc
      bloc; // El BLoC que maneja el estado de la orden de pizza.
  @override
  final Widget
      child; // El widget hijo que recibirá el bloc a través del árbol de widgets.

  // Constructor de la clase, recibe el bloc y el widget hijo.
  const PizzaOrderProvider({super.key, required this.bloc, required this.child})
      : super(child: child);

  // Método estático para acceder al bloc desde cualquier parte del árbol de widgets.
  static PizzaOrderBloc of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<PizzaOrderProvider>()!.bloc;

  // Este método se usa para decidir si debe notificarse a los widgets descendientes sobre una actualización.
  @override
  bool updateShouldNotify(covariant PizzaOrderProvider oldWidget) => true;
}
