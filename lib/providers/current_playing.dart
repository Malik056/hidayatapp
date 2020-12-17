import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:hidayat/models/playlist.dart';

class PlayingNowState {
  Playlist playlist;
  int bayanIndex;
}

class PlayingNowProvider extends ChangeNotifier {
  PlayingNowState _state = PlayingNowState();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  FlutterSoundPlayer player;
  Future<bool> initialized;
  double currentVolume = 0;

  PlayingNowProvider() {
    player = FlutterSoundPlayer();

    initialized = player.openAudioSession().then<bool>((value) {
      player.onProgress.listen((event) {
        duration = event.duration;
        position = event.position;
        notifyListeners();
      });
      return true;
    }).catchError((err) {
      return false;
    });
  }

  setVolume(double volume) {
    if (player != null)
      player.setVolume(volume).then((value) => notifyListeners());
  }

  seekTo(Duration newDuration) async {
    if (player != null) {
      if (player.isPlaying || player.isPaused) {
        player.seekToPlayer(newDuration).then((value) => notifyListeners);
      } else {}
    }
  }

  forward(Duration forwardBy) async {
    if (player != null) {
      if (player.isPlaying || player.isPaused) {
        player
            .seekToPlayer(duration + forwardBy)
            .then((value) => notifyListeners);
      } else {}
    }
  }

  rewind(Duration rewindBy) async {
    if (player != null) {
      Duration result = (duration - rewindBy);
      if (player.isPlaying || player.isPaused) {
        player
            .seekToPlayer(result.inMilliseconds < 0 ? 0 : result)
            .then((value) => notifyListeners());
      } else {}
    }
  }

  void next() async {
    if (player != null &&
        state.playlist != null &&
        state.playlist.bayans != null &&
        state.playlist.bayans.isNotEmpty) {
      if (state.playlist.bayans.length > state.bayanIndex + 1) {
        state.bayanIndex += 1;
        play();
      }
    }
  }

  void previous() async {
    if (player != null &&
        state.playlist != null &&
        state.playlist.bayans != null &&
        state.playlist.bayans.isNotEmpty) {
      if (state.bayanIndex > 0) {
        state.bayanIndex -= 1;
        play();
      }
    }
  }

  Future<void> stopPlayer() async {
    if (player != null) {
      await pausePlayer().then((value) {
        position = Duration.zero;
        notifyListeners();
      });
    }
  }

  Future<void> play() async {
    await player
        .startPlayer(
            fromURI: state.playlist.bayans[state.bayanIndex].link,
            whenFinished: () {
              notifyListeners();
            })
        .then((value) => duration = value);
    notifyListeners();
  }

  pausePlayer() async {
    if (player != null) {
      await player.pausePlayer();
    }
  }

  startPausePlayer() {
    player.isPlaying
        ? pausePlayer().then((value) => notifyListeners())
        : play().then((value) => notifyListeners);
  }

  set state(PlayingNowState pState) {
    _state = pState;
    notifyListeners();
  }

  PlayingNowState get state => _state;
}
