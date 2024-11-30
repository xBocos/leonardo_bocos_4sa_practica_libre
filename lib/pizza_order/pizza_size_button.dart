import 'package:flutter/material.dart';

class PizzaSizeButton extends StatelessWidget {
  const PizzaSizeButton({
    super.key, // Clave única para el widget
    required this.selected, // Si el botón está seleccionado o no
    required this.text, // El texto que se muestra en el botón
    required this.onTap, // Callback que se ejecuta cuando se toca el botón
  });

  final bool selected; // Estado que indica si el botón está seleccionado
  final String
      text; // El texto que representa el tamaño de la pizza (ejemplo: "S", "M", "L")
  final VoidCallback onTap; // Función que se ejecuta cuando el botón es tocado

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10.0), // Espaciado entre los botones
      child: GestureDetector(
        onTap: onTap, // Acción al tocar el botón
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle, // El botón tiene forma circular
            color: Colors.white, // Color de fondo blanco para el botón
            boxShadow:
                selected // Si el botón está seleccionado, se agrega una sombra
                    ? [
                        const BoxShadow(
                          spreadRadius: 2.0, // El área que se expande la sombra
                          color: Colors.black12, // Color de la sombra
                          offset:
                              Offset(0.0, 2.0), // Desplazamiento de la sombra
                          blurRadius: 10.0, // Difusión de la sombra
                        ),
                      ]
                    : null, // Si no está seleccionado, no hay sombra
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0), // Espaciado interno del botón
            child: Text(
              text, // El texto que se muestra en el botón
              style: TextStyle(
                color: Colors.brown, // Color del texto
                fontWeight:
                    selected // Si el botón está seleccionado, el texto tiene un peso mayor
                        ? FontWeight.bold
                        : FontWeight
                            .w300, // Peso de la fuente cuando no está seleccionado
              ),
            ),
          ),
        ),
      ),
    );
  }
}
