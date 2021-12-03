// import 'dart:async';
//
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals/config.dart' as globals;
// import 'package:hidayat/models/playlist.dart' as myPlaylist;
//
// // enum AudioState { loading, none, pause, play }
//
// // class PlayingNowState {
// //   myPlaylist.Playlist playlist;
// //   int bayanIndex;
// //   Duration duration;
// //   Duration position;
// //   // AudioState audioState = AudioState.none;
// // }
//
// class PlayingNowProvider extends ChangeNotifier {
//   // PlayingNowState _state = PlayingNowState();
//   AssetsAudioPlayer _player;
//   bool _isReady = false;
//   PlayerState get playerState => _player?.playerState?.valueWrapper?.value;
//   StreamSubscription<PlayingAudio> _subscription;
//   Stream<PlayerState> get playerStateStream =>
//       _player?.playerState?.asBroadcastStream();
//
//   String get id =>
//       _player?.current?.valueWrapper?.value?.audio?.audio?.metas?.id;
//
//   bool get isPlayerReady => _isReady;
//
//   Duration get position => _player?.currentPosition?.valueWrapper?.value;
//
//   int get fileIndex => _player?.current?.valueWrapper?.value?.index;
//
//   String get playlistId {
//     String id =
//         (_player?.current?.valueWrapper?.value?.audio?.audio?.metas?.extra ??
//             {})['playlistId'];
//     return id;
//   }
//
//   Future<void> playAtIndex(int index) async {
//     if (_isReady) {
//       _isReady = false;
//       await _player?.pause();
//       notifyListeners();
//       await _player?.playlistPlayAtIndex(index);
//       _isReady = true;
//     }
//   }
//
//   String get playlistName {
//     String album =
//         _player?.current?.valueWrapper?.value?.audio?.audio?.metas?.album;
//     return (album ?? '').isEmpty ? "Anonymous" : album;
//   }
//
//   String get bayanName {
//     String title =
//         _player?.current?.valueWrapper?.value?.audio?.audio?.metas?.title;
//     return (title ?? '').isEmpty ? "Anonymous" : title;
//   }
//
//   Stream<Duration> get positionStream =>
//       _player?.currentPosition?.asBroadcastStream();
//
//   Duration get duration =>
//       _player?.current?.valueWrapper?.value?.audio?.duration ?? Duration.zero;
//
//   double get volume => _player?.volume?.valueWrapper?.value;
//
//   Stream<double> get volumeStream => _player?.volume?.asBroadcastStream();
//
//   Future<void> _openNewPlayer(
//       List<Audio> audios, int startIndex, myPlaylist.Playlist playlist) async {
//     _isReady = false;
//     _player = AssetsAudioPlayer.newPlayer();
//     try {
//       await _player.open(
//         Playlist(
//           audios: audios,
//           startIndex: startIndex,
//         ),
//         autoStart: false,
//         loopMode: LoopMode.none,
//         showNotification: true,
//         headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
//         volume: globals.volume,
//         notificationSettings: NotificationSettings(
//           customNextAction: (player) async {
//             next();
//           },
//           customPrevAction: (player) {
//             previous();
//           },
//         ),
//       );
//     } catch (ex) {
//       print(ex);
//     }
//     _subscription = _player.onReadyToPlay.listen((event) {
//       print("OpenNewPlayer On Ready To Play");
//       if (!(_player?.isPlaying?.valueWrapper?.value ?? true)) {
//         try {
//           _player?.play();
//         } catch (ex) {
//           print(ex);
//         }
//       }
//       if (_player != null && event != null && event.audio != null) {
//         _isReady = true;
//       }
//     });
//     _player.playlistFinished.listen((event) {
//       if (event != null && event) {
//         _player?.dispose();
//         _player = null;
//       }
//     });
//
//     notifyListeners();
//   }
//
//   Future<void> addPlaylist(
//       List<Audio> audios, int startIndex, myPlaylist.Playlist playlist) async {
//     if (_player != null) {
//       await _subscription?.cancel();
//       if (_isReady) {
//         await _player.dispose();
//         await _openNewPlayer(audios, startIndex, playlist);
//       } else {
//         await _player.dispose();
//         await _openNewPlayer(audios, startIndex, playlist);
//         // await _player.onReadyToPlay.first.then((event) async {
//         //   print("Disposing On Ready To Play");
//         // });
//       }
//     } else {
//       _openNewPlayer(audios, startIndex, playlist);
//     }
//   }
//
//   Future<void> setVolume(double volume) async {
//     if (_player != null) {
//       _player.setVolume(volume).then((_) async {
//         globals.volume = volume;
//         notifyListeners();
//         await SharedPreferences.getInstance().then(
//           (value) => value.setDouble("volume", volume),
//         );
//       });
//     } else {
//       globals.volume = volume;
//       notifyListeners();
//       await SharedPreferences.getInstance().then(
//         (value) => value.setDouble("volume", volume),
//       );
//     }
//   }
//
//   double getVolume() => _player?.volume?.valueWrapper?.value ?? globals.volume;
//
//   Future<void> seekTo(Duration newDuration) async {
//     if (_player != null) {
//       if (_player.playerState.valueWrapper.value != PlayerState.stop) {
//         _player.seek(newDuration).then((value) => notifyListeners);
//       } else {}
//     }
//   }
//
//   Future<void> forward(Duration forwardBy) async {
//     if (_player != null) {
//       if (_player.playerState.valueWrapper.value != PlayerState.stop) {
//         _player.seekBy(forwardBy).then((value) => notifyListeners);
//       }
//     }
//   }
//
//   Future<void> rewind(Duration rewindBy) async {
//     if (_player != null) {
//       Duration result = (_player.currentPosition.valueWrapper.value - rewindBy);
//       if (_player.playerState.valueWrapper.value != PlayerState.stop) {
//         _player
//             .seek(result.inMilliseconds < 0 ? 0 : result)
//             .then((value) => notifyListeners());
//       }
//     }
//   }
//
//   Future<void> next() async {
//     if (_isReady) {
//       _isReady = false;
//       await _player?.pause();
//       notifyListeners();
//       _player?.next(stopIfLast: true);
//     }
//   }
//
//   Future<void> previous() async {
//     if (_isReady) {
//       // _isReady = false;
//       // await _player?.pause();
//       notifyListeners();
//       _player?.previous();
//     }
//   }
//
//   Future<void> pause() async {
//     await _player?.pause();
//   }
//
//   Future<void> togglePlayback() async {
//     await _player?.playOrPause();
//   }
//
//   Future<void> play() async {
//     await _player?.play();
//   }
// }

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayingNowProvider extends ChangeNotifier {
  AudioPlayer _player = AudioPlayer();

  PlayerState get playerState => _player.playerState;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Duration? get position => _player.position;
  Stream<Duration?> get positionStream => _player.positionStream;

  Duration? get duration => _player.duration;
  Stream<Duration?> get durationStream => _player.durationStream;

  double get volume => _player.volume;
  Stream<double> get volumeStream => _player.volumeStream;

  Stream<int?> get getCurrentIndexStream => _player.currentIndexStream;

  Future<void> playPlaylist(List<AudioSource> audios, int startIndex) async {
    try {
      await _player.dispose();
    } catch (ex) {
      print(ex);
    }
    _player = AudioPlayer();
    notifyListeners();
    _player.setAudioSource(
      ConcatenatingAudioSource(children: audios),
      initialIndex: startIndex,
    );
    _player.play();
  }

  Future<void> playAtIndex(int index) async {
    await _player.seek(null, index: index);
    _player.play();
  }

  String? get id {
    try {
      return (_player.audioSource?.sequence[_player.currentIndex!].tag
              as MediaItem?)
          ?.id;
    } catch (ex) {
      print(ex);
    }
  }

  String get bayanName {
    try {
      return (_player.audioSource?.sequence[_player.currentIndex!].tag
                  as MediaItem?)
              ?.title ??
          "Anonymous";
    } catch (ex) {
      print(ex);
      return "Anonymous";
    }
  }

  String get playlistName {
    try {
      return (_player.audioSource?.sequence[_player.currentIndex!].tag
                  as MediaItem?)
              ?.album ??
          "Anonymous";
    } catch (ex) {
      print(ex);
      return "Anonymous";
    }
  }

  String? get playlistId {
    try {
      return (_player.audioSource?.sequence[_player.currentIndex!].tag
              as MediaItem?)
          ?.extras?["playlistId"];
    } catch (ex) {
      print(ex);
    }
  }

  Future<void> pause() async {
    return _player.pause();
  }

  Future<void> stop() async {
    await _player.pause();
    await _player.seek(Duration.zero);
  }

  Future<void> rewind() {
    Duration position = _player.position;
    Duration seekDuration;
    if (position.inSeconds < 10) {
      seekDuration = Duration.zero;
    } else {
      seekDuration = position - Duration(seconds: 10);
    }
    return _player.seek(seekDuration);
  }

  Future<void> forward() {
    Duration position = _player.position;
    Duration? duration = _player.duration;
    Duration seekDuration;
    if (duration == null) {
      seekDuration = Duration(seconds: position.inSeconds + 10);
    } else {
      if (duration.inSeconds - position.inSeconds < 10) {
        seekDuration = duration;
      } else {
        seekDuration = Duration(seconds: 10 + position.inSeconds);
      }
    }
    return _player.seek(seekDuration);
  }

  Future<void> togglePlayback() async {
    if (_player.playing) {
      _player.pause();
    } else {
      _player.play();
    }
  }

  Future<void> seekTo(Duration seekBy) async {
    // Duration position = _player.position;
    // Duration? duration = _player.duration;
    // Duration seekDuration;
    // if (duration == null) {
    //   seekDuration = Duration(seconds: position.inSeconds + seekBy.inSeconds);
    // } else {
    //   if (duration.inSeconds - position.inSeconds < seekBy.inSeconds) {
    //     seekDuration = duration;
    //   } else {
    //     seekDuration = Duration(seconds: seekBy.inSeconds + position.inSeconds);
    //   }
    // }
    return _player.seek(seekBy);
  }

  void previous() {
    if (_player.hasPrevious) {
      _player.seekToPrevious();
    } else {
      stop();
    }
  }

  void next() {
    if (_player.hasNext) {
      _player.seekToNext();
    } else {
      stop();
    }
  }

  Future<void> setVolume(double vol) async {
    // if (_player) {
    _player.setVolume(vol).then((_) async {
      globals.volume = vol;
      notifyListeners();
      await SharedPreferences.getInstance().then(
        (value) => value.setDouble("volume", vol),
      );
    });
    // } else {
    // globals.volume = volume;
    // notifyListeners();
    // await SharedPreferences.getInstance().then(
    //   (value) => value.setDouble("volume", volume),
    // );
    // }
  }

  @override
  void dispose() {
    super.dispose();
    try {
      _player.dispose();
    } catch (ex) {
      print(ex);
    }
  }


}
