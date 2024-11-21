import 'package:flutter/material.dart';
import 'ingredient.dart';

const _PizzaCartSize = 55.0;

class PizzaOrderDetails extends StatelessWidget {
  const PizzaOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Orleans Pizza',
          style: TextStyle(
            color: Colors.brown,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            color: Colors.brown,
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 50,
            left: 10,
            right: 10,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: _PizzaDetails(),
                  ),
                  Expanded(
                    flex: 2,
                    child: _PizzaIngredients(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            height: _PizzaCartSize,
            width: _PizzaCartSize,
            left: MediaQuery.of(context).size.width / 2 - _PizzaCartSize / 2,
            child: _PizzaCartButton(),
          ),
        ],
      ),
    );
  }
}

class _PizzaDetails extends StatefulWidget {
  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<_PizzaDetails>
    with SingleTickerProviderStateMixin {
  final _listIngredients = <Ingredient>[];
  late AnimationController _animationController;
  int _total = 15;
  final _notifierFocused = ValueNotifier(false);
  List<Animation> _animationList = <Animation>[];

  void _buildIngredientsAnimation() {
    _animationList.clear();
    _animationList.add(CurvedAnimation(
      curve: Interval(0.0, 0.8, curve: Curves.decelerate),
      parent: _animationController,
    ));
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: DragTarget<Ingredient>(
            onAccept: (ingredient) {
              print('onAccept');
              _notifierFocused.value = false;
              setState(() {
                _listIngredients.add(ingredient);
                _total++;
              });
            },
            onWillAccept: (ingredient) {
              print('onWillAccept');
              _notifierFocused.value = true;
              for (Ingredient i in _listIngredients) {
                if (i.compare(ingredient!)) {
                  return false;
                }
              }
              return true;
            },
            onLeave: (ingredient) {
              print('onLeave');
              _notifierFocused.value = false;
            },
            builder: (context, list, rejects) {
              return LayoutBuilder(builder: (context, constraints) {
                return Center(
                  child: ValueListenableBuilder<bool>(
                      valueListenable: _notifierFocused,
                      builder: (context, focused, _) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          height: focused
                              ? constraints.maxHeight
                              : constraints.maxHeight - 10,
                          child: Stack(
                            children: [
                              Image.asset('lib/images/dish.png'),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset('lib/images/pizza-1.png'),
                              ),
                            ],
                          ),
                        );
                      }),
                );
              });
            },
          ),
        ),
        const SizedBox(height: 5),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: Offset(0.0, 0.0),
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
            '\$$_total',
            key: UniqueKey(),
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
        ),
      ],
    );
  }
}

class _PizzaCartButton extends StatelessWidget {
  const _PizzaCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orange.withOpacity(0.5),
            Colors.orange,
          ],
        ),
      ),
      child: Icon(
        Icons.add_shopping_cart_outlined,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

class _PizzaIngredients extends StatelessWidget {
  const _PizzaIngredients({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return _PizzaIngredientItem(ingredient: ingredient);
      },
    );
  }
}

class _PizzaIngredientItem extends StatelessWidget {
  const _PizzaIngredientItem({super.key, required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final child = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.0),
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Color(0xFFF5EED3),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Image.asset(
            ingredient.image,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );

    return Center(
      child: Draggable(
        feedback: DecoratedBox(
          decoration: BoxDecoration(
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
        ),
        data: ingredient,
        child: child,
      ),
    );
  }
}
