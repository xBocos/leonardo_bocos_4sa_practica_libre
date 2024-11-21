import 'package:flutter/material.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_order_details.dart';

class MainPizzaOrder extends StatelessWidget {
  const MainPizzaOrder({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: PizzaOrderDetails(),
    );
  }
}
