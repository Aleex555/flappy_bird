import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  Color color = Colors.white;

  Player() : super(position: Vector2.all(100), size: Vector2.all(50));

  final velocity = Vector2(0, 150);
  bool perdido = false;

  @override
  Future<void> onLoad() async {
    String imagePath = _getImagePathForColor(color);
    animation = await SpriteAnimation.load(
      imagePath,
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

  //@override
  //void render(Canvas canvas) {
  //final paint = Paint()
  //..colorFilter = ui.ColorFilter.mode(color, ui.BlendMode.modulate);
  //super.render(canvas, overridePaint: paint);
  //}

  void changeColor(Color newColor) {
    color = newColor;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += velocity.y * dt;
  }

  @override
  void onCollisionStart(Set<Vector2> _, PositionComponent other) {
    super.onCollisionStart(_, other);
    perdido = true;
    gameRef.pauseEngine();
    onLose();
  }

  void fly() {
    add(
      MoveByEffect(
        Vector2(0, -100),
        EffectController(
          duration: 0.2,
          curve: Curves.decelerate,
        ),
      ),
    );
  }

  void onLose() {
    gameRef.overlays.add('rankingOverlay');
  }

  
}
