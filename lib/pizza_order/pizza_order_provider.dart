import 'package:flutter/material.dart';
import 'pizza_order_bloc.dart';

class PizzaOrderProvider extends InheritedWidget {
  final PizzaOrderBloc bloc;
  final Widget child;

  const PizzaOrderProvider({super.key, required this.bloc, required this.child})
      : super(child: child);

  static PizzaOrderBloc of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<PizzaOrderProvider>()!.bloc;

  @override
  bool updateShouldNotify(covariant PizzaOrderProvider oldWidget) => true;
}
