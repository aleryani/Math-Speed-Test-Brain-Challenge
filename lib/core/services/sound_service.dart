import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final soundServiceProvider = Provider<SoundService>((ref) {
  throw UnimplementedError('SoundService must be overridden');
});

class SoundService {
  SoundService({bool enablePlayer = true}) {
    if (enablePlayer) {
      _player = AudioPlayer()..setReleaseMode(ReleaseMode.stop);
    }
  }

  AudioPlayer? _player;
  bool _enabled = true;

  void updateEnabled(bool enabled) {
    _enabled = enabled;
  }

  Future<void> playTap() => _playAsset('assets/sfx/tap.mp3');

  Future<void> playCorrect() => _playAsset('assets/sfx/correct.mp3');

  Future<void> playWrong() => _playAsset('assets/sfx/wrong.mp3');

  Future<void> _playAsset(String assetPath) async {
    if (!_enabled) {
      return;
    }
    try {
      final player = _player;
      if (player == null) {
        return;
      }
      await player.stop();
      await player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    } on PlatformException catch (e) {
      debugPrint('SoundService PlatformException: $e');
    } catch (e) {
      debugPrint('SoundService error: $e');
    }
  }

  Future<void> dispose() async {
    await _player?.dispose();
  }
}
