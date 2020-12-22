import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/models/playlist.dart' as myPlaylist;

class PlayingNowState {
  myPlaylist.Playlist playlist;
  int bayanIndex;
}

class PlayingNowProvider extends ChangeNotifier {
  PlayingNowState _state = PlayingNowState();
  double currentVolume = 0;
  AssetsAudioPlayer player;

  setVolume(double volume) {
    if (player != null)
      player.setVolume(volume).then((value) => notifyListeners());
  }

  seekTo(Duration newDuration) async {
    if (player != null) {
      if (player.playerState.value != PlayerState.stop) {
        player.seek(newDuration).then((value) => notifyListeners);
      } else {}
    }
  }

  forward(Duration forwardBy) async {
    if (player != null) {
      if (player.playerState.value != PlayerState.stop) {
        player.seekBy(forwardBy).then((value) => notifyListeners);
      } else {}
    }
  }

  rewind(Duration rewindBy) async {
    if (player != null) {
      Duration result = (player.currentPosition.value - rewindBy);
      if (player.playerState.value != PlayerState.stop) {
        player
            .seek(result.inMilliseconds < 0 ? 0 : result)
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
      await player.pause().then((value) {
        notifyListeners();
      });
    }
  }

  Future<void> play() async {
    await player.open(
      Audio.liveStream(_state.playlist.bayans[_state.bayanIndex].link),
      autoStart: true,
      showNotification: true,
    );

    notifyListeners();
  }

  pausePlayPlayer() async {
    if (player != null) {
      await player.pause;
    }
  }

  startPausePlayer() {
    player.playOrPause().then((value) => notifyListeners());
  }

  set state(PlayingNowState pState) {
    _state = pState;
    notifyListeners();
  }

  PlayingNowState get state => _state;
}
