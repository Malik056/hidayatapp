import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals/config.dart' as globals;
import 'package:hidayat/models/playlist.dart' as myPlaylist;

// enum AudioState { loading, none, pause, play }

// class PlayingNowState {
//   myPlaylist.Playlist playlist;
//   int bayanIndex;
//   Duration duration;
//   Duration position;
//   // AudioState audioState = AudioState.none;
// }

class PlayingNowProvider extends ChangeNotifier {
  // PlayingNowState _state = PlayingNowState();
  AssetsAudioPlayer _player;
  bool _isReady = false;
  PlayerState get playerState => _player?.playerState?.value;
  StreamSubscription<PlayingAudio> _subscription;
  Stream<PlayerState> get playerStateStream =>
      _player?.playerState?.asBroadcastStream();

  String get id => _player?.current?.value?.audio?.audio?.metas?.id;

  bool get isPlayerReady => _isReady;

  Duration get position => _player?.currentPosition?.value;

  int get fileIndex => _player?.current?.value?.index;

  String get playlistId {
    String id = (_player?.current?.value?.audio?.audio?.metas?.extra ??
        {})['playlistId'];
    return id;
  }

  Future<void> playAtIndex(int index) async {
    if (_isReady) {
      _isReady = false;
      await _player?.pause();
      notifyListeners();
      await _player?.playlistPlayAtIndex(index);
      _isReady = true;
    }
  }

  String get playlistName {
    String album = _player?.current?.value?.audio?.audio?.metas?.album;
    return (album ?? '').isEmpty ? "Anonymous" : album;
  }

  String get bayanName {
    String title = _player?.current?.value?.audio?.audio?.metas?.title;
    return (title ?? '').isEmpty ? "Anonymous" : title;
  }

  Stream<Duration> get positionStream =>
      _player?.currentPosition?.asBroadcastStream();

  Duration get duration =>
      _player?.current?.value?.audio?.duration ?? Duration.zero;

  double get volume => _player?.volume?.value;

  Stream<double> get volumeStream => _player?.volume?.asBroadcastStream();

  Future<void> _openNewPlayer(
      List<Audio> audios, int startIndex, myPlaylist.Playlist playlist) async {
    _isReady = false;
    _player = AssetsAudioPlayer.newPlayer();
    try {
      await _player.open(
        Playlist(
          audios: audios,
          startIndex: startIndex,
        ),
        autoStart: false,
        loopMode: LoopMode.none,
        showNotification: true,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        volume: globals.volume,
        notificationSettings: NotificationSettings(
          customNextAction: (player) async {
            next();
          },
          customPrevAction: (player) {
            previous();
          },
        ),
      );
    } catch (ex) {
      print(ex);
    }
    _subscription = _player.onReadyToPlay.listen((event) {
      print("OpenNewPlayer On Ready To Play");
      if (!(_player?.isPlaying?.value ?? true)) {
        _player?.play();
      }
      if (_player != null && event != null && event.audio != null) {
        _isReady = true;
      }
    });
    _player.playlistFinished.listen((event) {
      if (event != null && event) {
        _player?.dispose();
        _player = null;
      }
    });

    notifyListeners();
  }

  Future<void> addPlaylist(
      List<Audio> audios, int startIndex, myPlaylist.Playlist playlist) async {
    if (_player != null) {
      await _subscription?.cancel();
      if (_isReady) {
        await _player.dispose();
        await _openNewPlayer(audios, startIndex, playlist);
      } else {
        await _player.dispose();
        await _openNewPlayer(audios, startIndex, playlist);
        // await _player.onReadyToPlay.first.then((event) async {
        //   print("Disposing On Ready To Play");
        // });
      }
    } else {
      _openNewPlayer(audios, startIndex, playlist);
    }
  }

  Future<void> setVolume(double volume) async {
    if (_player != null) {
      _player.setVolume(volume).then((_) async {
        globals.volume = volume;
        notifyListeners();
        await SharedPreferences.getInstance().then(
          (value) => value.setDouble("volume", volume),
        );
      });
    } else {
      globals.volume = volume;
      notifyListeners();
      await SharedPreferences.getInstance().then(
        (value) => value.setDouble("volume", volume),
      );
    }
  }

  double getVolume() => _player?.volume?.value ?? globals.volume;

  Future<void> seekTo(Duration newDuration) async {
    if (_player != null) {
      if (_player.playerState.value != PlayerState.stop) {
        _player.seek(newDuration).then((value) => notifyListeners);
      } else {}
    }
  }

  Future<void> forward(Duration forwardBy) async {
    if (_player != null) {
      if (_player.playerState.value != PlayerState.stop) {
        _player.seekBy(forwardBy).then((value) => notifyListeners);
      }
    }
  }

  Future<void> rewind(Duration rewindBy) async {
    if (_player != null) {
      Duration result = (_player.currentPosition.value - rewindBy);
      if (_player.playerState.value != PlayerState.stop) {
        _player
            .seek(result.inMilliseconds < 0 ? 0 : result)
            .then((value) => notifyListeners());
      }
    }
  }

  Future<void> next() async {
    if (_isReady) {
      _isReady = false;
      await _player?.pause();
      notifyListeners();
      _player?.next(stopIfLast: true);
    }
  }

  Future<void> previous() async {
    if (_isReady) {
      // _isReady = false;
      // await _player?.pause();
      notifyListeners();
      _player?.previous();
    }
  }

  Future<void> pause() async {
    await _player?.pause();
  }

  Future<void> togglePlayback() async {
    await _player?.playOrPause();
  }

  Future<void> play() async {
    await _player?.play();
  }
}
