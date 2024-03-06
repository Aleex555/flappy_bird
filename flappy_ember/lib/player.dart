import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class Player extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  Color color =
      Colors.white; // Color predeterminado del jugador, cambiar según necesites

  Player() : super(position: Vector2.all(100), size: Vector2.all(50));

  final velocity = Vector2(0, 150);

  @override
  Future<void> onLoad() async {
    animation = await SpriteAnimation.load(
      'ember.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(16),
        stepTime: 0.12,
      ),
    );
    add(CircleHitbox());
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
    gameRef.pauseEngine();
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
}
