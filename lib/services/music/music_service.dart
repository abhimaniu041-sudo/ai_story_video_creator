import 'package:just_audio/just_audio.dart';

class MusicService {
  final AudioPlayer _player = AudioPlayer();
  double _musicVolume = 0.5;
  bool _isDucking = false;

  static const Map<String, String> musicAssets = {
    'emotional': 'assets/music/emotional.mp3',
    'horror': 'assets/music/horror.mp3',
    'action': 'assets/music/action.mp3',
    'comedy': 'assets/music/comedy.mp3',
    'motivation': 'assets/music/motivation.mp3',
    'adventure': 'assets/music/adventure.mp3',
    'fantasy': 'assets/music/fantasy.mp3',
  };

  Future<void> playMusic(String category) async {
    final asset = musicAssets[category] ?? musicAssets['emotional']!;
    try {
      await _player.setAsset(asset);
      await _player.setLoopMode(LoopMode.one);
      await _player.setVolume(_musicVolume);
      await _player.play();
    } catch (e) {
      // Music asset not found, skip silently
    }
  }

  Future<void> duck() async {
    if (!_isDucking) {
      _isDucking = true;
      await _player.setVolume(_musicVolume * 0.2);
    }
  }

  Future<void> unduck() async {
    if (_isDucking) {
      _isDucking = false;
      await _player.setVolume(_musicVolume);
    }
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
