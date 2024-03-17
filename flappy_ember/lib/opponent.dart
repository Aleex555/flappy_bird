import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Opponent extends SpriteAnimationComponent {
  final String id;
  // Color inicial, puedes ajustarlo según necesites.
  Color color = Colors.white;
  final double opacity = 0.5;

  Opponent({required this.id, required Color color})
      : super(position: Vector2.all(100), size: Vector2.all(50)) {
    this.color = color;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    // Obtén el path de la imagen basado en el color
    String imagePath = _getImagePathForColor(color);
    animation = await SpriteAnimation.load(
      imagePath,
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );

    // Aplica la opacidad al pintar el componente
    paint = Paint()..color = color.withOpacity(opacity);
  }

  String _getImagePathForColor(Color color) {
    // Asignación del path de la imagen basada en el color proporcionado.
    // Esto es un ejemplo; necesitas ajustar los nombres de los archivos según tus necesidades.
    if (color == Colors.red) {
      return 'embervermell.png';
    } else if (color == Colors.blue) {
      return 'emberblau.png';
    } else if (color == Colors.orange) {
      return 'embertaronja.png';
    } else if (color == Colors.green) {
      return 'emberverd.png';
    } else {
      // Un color por defecto si no se reconoce el color
      return 'ember.png';
    }
  }
}
