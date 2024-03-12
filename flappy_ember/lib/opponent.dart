import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Opponent extends SpriteAnimationComponent {
  final String id;
  Color color = Colors.white;

  Opponent({required this.id, required this.color})
      : super(position: Vector2.all(100), size: Vector2.all(50));

  @override
  Future<void> onLoad() async {
    String imagePath = _getImagePathForColor(color);
    animation = await SpriteAnimation.load(
      'embervermell.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
    add(CircleHitbox());
  }

  String _getImagePathForColor(Color color) {
    // Asumiendo que 'color' es el Color de Flutter y que mapeas estos a tus colores definidos
    if (color == Colors.red) {
      // Vermell
      return 'embervermell.png';
    } else if (color == Colors.blue) {
      // Blau
      return 'emberblau.png';
    } else if (color == Colors.orange) {
      // Taronja
      return 'embertaronja.png';
    } else if (color == Colors.green) {
      // Verd
      return 'emberverd.png';
    } else {
      return 'ember.png'; // Un color por defecto si no se reconoce el color
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
