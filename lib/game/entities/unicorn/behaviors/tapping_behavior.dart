import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:meteors_game/game/game.dart';
import 'package:meteors_game/gen/assets.gen.dart';

class TappingBehavior extends TappableBehavior<Unicorn>
    with HasGameRef<VeryGoodFlameGame> {
  @override
  bool onTapDown(TapDownInfo info) {
    if (parent.isAnimationPlaying()) {
      return true;
    }
    gameRef.counter++;
    parent.playAnimation();

    gameRef.effectPlayer.play(AssetSource(Assets.audio.effect));

    return false;
  }
}
