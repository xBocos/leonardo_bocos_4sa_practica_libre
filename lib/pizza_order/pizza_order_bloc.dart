import 'package:flutter/material.dart' show ChangeNotifier, ValueNotifier;
import 'package:leonardo_bocos_4sa_practica_libre/pizza_order/ingredient.dart';

class PizzaOrderBloc extends ChangeNotifier {
  final listIngredients = <Ingredient>[];
  final notifierTotal = ValueNotifier(15);
  final notifierDeletedIngredient = ValueNotifier<Ingredient?>(null);

  get bloc => null;

  void addIngredient(Ingredient ingredient) {
    listIngredients.add(ingredient);
    notifierTotal.value++;
  }

  void removeIngredient(Ingredient ingredient) {
    listIngredients.remove(ingredient);
    notifierTotal.value--;
    notifierDeletedIngredient.value = ingredient;
  }

  void refreshDeletedIngredient() {
    notifierDeletedIngredient.value = null;
  }

  bool containsIngredient(Ingredient ingredient) {
    for (Ingredient i in listIngredients) {
      if (i.compare(ingredient)) {
        return true;
      }
    }
    return false;
  }
}
