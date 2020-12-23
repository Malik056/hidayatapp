import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../globals/config.dart' as globals;
import 'package:hidayat/models/playlist.dart' as myPlaylist;

enum AudioState { loading, none, pause, play }

class PlayingNowState {
  myPlaylist.Playlist playlist;
  int bayanIndex;
  Duration duration;
  Duration position;
  AudioState audioState = AudioState.none;
}

class PlayingNowProvider extends ChangeNotifier {
  PlayingNowState _state = PlayingNowState();
  AssetsAudioPlayer player;

  PlayingNowProvider() {
    // player.setVolume(globals.volume);
    // player = AssetsAudioPlayer();
  }

  addPlaylist(
      List<Audio> audios, int startIndex, myPlaylist.Playlist playlist) async {
    await player?.dispose();
    player = AssetsAudioPlayer.newPlayer();
    var state = PlayingNowState();
    state.playlist = playlist;
    state.bayanIndex = startIndex;
    state.position = Duration.zero;
    state.duration = null;
    state.audioState = AudioState.loading;
    this.state = state;
    player.open(
      Playlist(
        audios: audios,
        startIndex: startIndex,
      ),
      autoStart: true,
      loopMode: LoopMode.none,
      showNotification: true,
      volume: globals.volume,
    );
    player.onReadyToPlay.listen((event) {
      if (event == null) {
        print("Null Event");
        return;
      }
      print("***********************************************");
      print("############### Ready to Play #################");
      print("***********************************************");
      final newState = PlayingNowState();
      newState.bayanIndex = _state.bayanIndex;
      newState.playlist = _state.playlist;
      newState.duration = event?.duration ?? Duration(seconds: 1);
      newState.position = Duration.zero;
      newState.audioState = AudioState.play;
      this.state = newState;
      notifyListeners();
    });
    // player.playlistFinished.listen((event) async {
    //   if (event) {
    //     print("***********************************************");
    //     print("############## Playlist Finished ##############");
    //     print("***********************************************");
    //     final newState = PlayingNowState();
    //     newState.audioState = AudioState.none;
    //     //   newState.bayanIndex = 0;
    //     newState.playlist = null;
    //     this.state = newState;
    //     newState.position = Duration.zero;
    //     // await player.stop();
    //     await player.dispose();
    //     notifyListeners();
    //   }
    // });
    player.playlistAudioFinished.listen((event) async {
      print("***********************************************");
      print("############### Audio Finished ################");
      print("***********************************************");
      if (_state == null ||
          _state.playlist == null ||
          _state.bayanIndex == null) {
        return;
      }
      if (_state.bayanIndex + 1 < _state.playlist.bayans.length) {
        final newState = PlayingNowState();
        newState.bayanIndex = _state.bayanIndex + 1;
        newState.playlist = _state.playlist;
        newState.position = Duration.zero;
        newState.audioState = AudioState.play;
        this.state = newState;
        notifyListeners();
      } else {
        if (_state.bayanIndex + 1 >= _state.playlist.bayans.length) {
          print("***********************************************");
          print("############## Playlist Finished ##############");
          print("***********************************************");
          final newState = PlayingNowState();
          newState.audioState = AudioState.none;
          //   newState.bayanIndex = 0;
          newState.playlist = null;
          this.state = newState;
          newState.position = Duration.zero;
          // await player.stop();
          await player.dispose();
          notifyListeners();
        }
      }
    });
  }

  setVolume(double volume) async {
    if (player != null) {
      player.setVolume(volume).then((value) async {
        globals.volume = volume;
        notifyListeners();
        SharedPreferences.getInstance().then(
          (value) => value.setDouble("volume", volume),
        );
      });
    } else {
      globals.volume = volume;
      notifyListeners();
    }
  }

  double getVolume() => player?.volume?.value ?? globals.volume;

  Future<void> seekTo(Duration newDuration) async {
    if (player != null) {
      if (player.playerState.value != PlayerState.stop) {
        player.seek(newDuration).then((value) => notifyListeners);
      } else {}
    }
  }

  Future<void> forward(Duration forwardBy) async {
    if (player != null) {
      if (player.playerState.value != PlayerState.stop) {
        player.seekBy(forwardBy).then((value) => notifyListeners);
      } else {}
    }
  }

  Future<void> rewind(Duration rewindBy) async {
    if (player != null) {
      Duration result = (player.currentPosition.value - rewindBy);
      if (player.playerState.value != PlayerState.stop) {
        player
            .seek(result.inMilliseconds < 0 ? 0 : result)
            .then((value) => notifyListeners());
      } else {}
    }
  }

  Future<void> next() async {
    if (player != null &&
        state.playlist != null &&
        state.playlist.bayans != null &&
        state.playlist.bayans.isNotEmpty) {
      if (state.playlist.bayans.length > state.bayanIndex + 1) {
        state.bayanIndex += 1;
        player.next();
      }
    }
  }

  Future<void> previous() async {
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

  Future<void> startPausePlayer() async {
    PlayerState playing = player.playerState.value;
    _state.audioState = AudioState.loading;
    notifyListeners();
    player.playOrPause().then((value) {
      PlayingNowState state = PlayingNowState();
      if (playing == PlayerState.play) {
        state.audioState = AudioState.pause;
        state.bayanIndex = _state.bayanIndex;
        state.playlist = _state.playlist;
        state.duration = _state.duration;
        state.position = _state.position;
        notifyListeners();
      } else if (playing == PlayerState.pause) {
        state.audioState = AudioState.play;
        state.bayanIndex = _state.bayanIndex;
        state.playlist = _state.playlist;
        state.duration = _state.duration;
        state.position = _state.position;
        notifyListeners();
      } else {
        _state.audioState = AudioState.none;
      }
      notifyListeners();
    });
  }

  set state(PlayingNowState pState) {
    _state = pState;
    notifyListeners();
  }

  PlayingNowState get state => _state;
}
