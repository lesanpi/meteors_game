import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:flutter/material.dart';
import 'package:meteors_game/game/entities/unicorn/behaviors/tapping_behavior.dart';
import 'package:meteors_game/gen/assets.gen.dart';

class Unicorn extends PositionedEntity with HasGameRef, CollisionCallbacks {
  Unicorn({
    required super.position,
    required this.joystick,
  }) : super(
          anchor: Anchor.center,
          size: Vector2.all(32),
          behaviors: [
            TappingBehavior(),
          ],
        );

  @visibleForTesting
  Unicorn.test({
    required super.position,
    required this.joystick,
    super.behaviors,
  }) : super(size: Vector2.all(32));

  final JoystickComponent joystick;

  late SpriteAnimationComponent _animationComponent;

  @visibleForTesting
  SpriteAnimationTicker get animationTicker =>
      _animationComponent.animationTicker!;

  /// Pixels/s
  double maxSpeed = 300;
  late final Vector2 _lastSize = size.clone();
  late final Transform2D _lastTransform = transform.clone();

  @override
  void update(double dt) {
    if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
      _lastSize.setFrom(size);
      _lastTransform.setFrom(transform);
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
  }

  @override
  Future<void> onLoad() async {
    final animation = await gameRef.loadSpriteAnimation(
      Assets.images.unicornAnimation.path,
      SpriteAnimationData.sequenced(
        amount: 16,
        stepTime: 0.1,
        textureSize: Vector2.all(32),
        loop: false,
      ),
    );

    await add(
      _animationComponent = SpriteAnimationComponent(
        animation: animation,
        size: size,
      ),
    );

    resetAnimation();
  }

  void resetAnimation() {
    animationTicker
      ..currentIndex = animationTicker.spriteAnimation.frames.length - 1
      ..update(0.1)
      ..currentIndex = 0;
  }

  /// Plays the animation.
  void playAnimation() => animationTicker.reset();

  /// Returns whether the animation is playing or not.
  bool isAnimationPlaying() => !animationTicker.done();
}
