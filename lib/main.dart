import 'package:flutter/material.dart';
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/pizza_order_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza Order App',
      debugShowCheckedModeBanner: false, // Esto elimina la marca de agua
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const PizzaOrderDetails(),
    );
  }
}
