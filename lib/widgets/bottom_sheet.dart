import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/providers/current_playing.dart';
import 'package:hidayat/providers/volume.dart';
import 'package:provider/provider.dart';
import '../globals/config.dart' as globals;

class MediaPlayerSheet extends StatefulWidget {
  @override
  _MediaPlayerSheetState createState() => _MediaPlayerSheetState();
}

class _MediaPlayerSheetState extends State<MediaPlayerSheet> {
  @override
  Widget build(BuildContext context) {
    // var textTheme = Theme.of(context).textTheme;
    return Consumer<PlayingNowProvider>(
      builder: (ctx, data, _) {
        // myPlaylist.Playlist playlist = data.state?.playlist;
        // Bayan bayan;
        // if (playlist != null &&
        //     playlist.bayans != null &&
        //     playlist.bayans.isNotEmpty) {
        //   int index = data.state.bayanIndex ?? 0;
        //   if (index >= playlist.bayans.length) {
        //     index = 0;
        //   }
        //   bayan = playlist.bayans[index];
        // }

        // if (data.playerState == PlayerState.stop) {
        //   return _PlayerSheet(
        //     position: Duration.zero,
        //     volume: data.getVolume(),
        //     audioState: AudioState.none,
        //     onVolumeUpdate: (value) {
        //       data.setVolume(value);
        //     },
        //     duration: Duration.zero,
        //     playlistName: "No Playlist Selected",
        //     bayanName: "No Audio Selected",
        //   );
        // }

        // int index = data?.fileIndex;
        // // List<Bayan> bayans = playlist?.bayans;

        // // if (bayans != null && bayans.isNotEmpty) {
        // //   bayan = bayans[index];
        // // }

        // if (index == null) {
        //   return _PlayerSheet(
        //     position: Duration.zero,
        //     audioState: AudioState.none,
        //     volume: data.getVolume(),
        //     onVolumeUpdate: (value) {
        //       data.setVolume(value);
        //     },
        //     duration: Duration.zero,
        //     playlistName: "No Playlist Selected",
        //     bayanName: "No Audio Selected",
        //   );
        // }

        // Duration position = data.position;

        return _PlayerSheet(
          data: data,
          // position: position,
          // playlistName: data.pla
          // volume: data.getVolume(),
          // duration: data.state.duration ?? Duration.zero,
          // onVolumeUpdate: (value) {
          //   data.setVolume(value);
          // },
          // audioState: data.state.audioState,
          // bayanName: "${index + 1}. ${bayan.name ?? "Anonymous"}",
          // onPlayPressed: () {
          //   data.player.playOrPause();
          // },
          // onSkipPrevious: index == 0
          //     ? null
          //     : () async {
          //         data.previous();
          //         // var state = PlayingNowState();
          //         // if (!(AudioService.running ?? false)) {
          //         //   await AudioService.start(
          //         //       backgroundTaskEntrypoint: entrypoint);
          //         // }
          //         // if ((index - 1) >= 0) {
          //         //   if (!(AudioService.running ?? false)) {
          //         //     await AudioService.start(
          //         //         backgroundTaskEntrypoint: entrypoint);
          //         //   }
          //         //   state.duration = Duration(
          //         //       seconds:
          //         //           await AudioService.customAction("skipPrevious") ??
          //         //               0);
          //         //   state.bayanIndex = index - 1;
          //         //   state.playlist = playlist;
          //         //   state.duration = duration;
          //         //   data.state = state;
          //         // }
          //       },
          // onSkipNext: index == bayans.length - 1
          //     ? null
          //     : () async {
          //         data.next();
          //         // var state = PlayingNowState();
          //         // if ((index + 1) < bayans.length) {
          //         //   if (!(AudioService.running ?? false)) {
          //         //     await AudioService.start(
          //         //         backgroundTaskEntrypoint: entrypoint);
          //         //   }
          //         //   state.duration = Duration(
          //         //       seconds:
          //         //           await AudioService.customAction("skipNext") ?? 0);
          //         //   state.bayanIndex = index + 1;
          //         //   state.playlist = playlist;
          //         //   state.duration = duration;
          //         //   data.state = state;
          //         // }
          //       },
          // onSeekForward: () {
          //   data.forward(Duration(seconds: 15));
          //   // var newDuration = position + Duration(seconds: 15);
          //   // if (newDuration > duration) {
          //   //   newDuration = duration;
          //   // }
          //   // AudioService.seekTo(newDuration);
          // },
          // onSeekBackward: () {
          //   data.rewind(Duration(seconds: 15));
          //   // var newDuration = position - Duration(seconds: 15);
          //   // if (newDuration < Duration.zero) {
          //   //   newDuration = Duration.zero;
          //   // }
          //   // AudioService.seekTo(newDuration);
          // },
        );
      },
    );
  }
}

class _PlayerSheet extends StatelessWidget {
  // final PlayerState audioState;
  // final Duration position;
  // final String bayanName;
  // final String playlistName;
  // final Duration duration;
  // final Function() onPlayPressed;
  // final Function() onSeekBackward;
  // final Function() onSeekForward;
  // final Function() onSkipNext;
  // final Function() onSkipPrevious;
  // final Function(Duration) seekTo;
  // final Function(double) onVolumeUpdate;
  // final double volume;
  final PlayingNowProvider data;

  const _PlayerSheet({
    Key key,
    @required this.data,
    // @required this.audioState,
    // this.position,
    // this.bayanName,
    // @required this.playlistName,
    // this.duration,
    // this.onPlayPressed,
    // this.onSeekBackward,
    // this.onSeekForward,
    // this.onSkipNext,
    // @required this.volume,
    // this.seekTo,
    // @required this.onVolumeUpdate,
    // this.onSkipPrevious,
  }) : super(key: key);

  String getTimeFromDuration(Duration time) {
    int totalSeconds = time.inSeconds;
    int totalMinutes = time.inMinutes;
    int seconds = totalSeconds - (totalMinutes * 60);
    return "${totalMinutes < 10 ? '0$totalMinutes' : totalMinutes}:${seconds < 10 ? '0$seconds' : seconds}";
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return StreamBuilder<PlayerState>(
        initialData: data.playerState,
        stream: data.playerStateStream,
        builder: (context, snapshot) {
          var state = snapshot.data ?? PlayerState.stop;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StreamBuilder<Duration>(
                  initialData: data.position,
                  stream: data.positionStream,
                  builder: (context, snapshot) {
                    Duration position = snapshot.data ?? Duration.zero;
                    Duration duration = data.duration;
                    return Column(
                      children: [
                        Slider(
                          value: position.inSeconds > duration.inSeconds
                              ? duration.inSeconds.toDouble()
                              : position.inSeconds.toDouble(),
                          max: duration.inSeconds.toDouble(),
                          min: 0,
                          onChanged: (state == PlayerState.stop ||
                                  !data.isPlayerReady)
                              ? null
                              : (value) {
                                  data.seekTo(Duration(seconds: value.toInt()));
                                },
                        ),
                        Row(
                          children: [
                            (state == PlayerState.stop || !data.isPlayerReady)
                                ? Text("0:00")
                                : Text(getTimeFromDuration(position)),
                            Spacer(),
                            (state == PlayerState.stop || !data.isPlayerReady)
                                ? Text("0:00")
                                : Text(getTimeFromDuration(duration)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                Text(
                  state == PlayerState.stop
                      ? "плейлист ба поён расид"
                      : '${data.bayanName}',
                  textAlign: TextAlign.center,
                  style: textTheme.headline6,
                ),
                Text(
                  state == PlayerState.stop ? "" : '${data.playlistName}',
                  textAlign: TextAlign.center,
                  style: textTheme.subtitle1.copyWith(color: Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.fast_rewind),
                      onPressed:
                          (state == PlayerState.stop || !data.isPlayerReady)
                              ? null
                              : data.previous,
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(state == PlayerState.play
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed:
                          (state == PlayerState.stop || !data.isPlayerReady)
                              ? null
                              : data.togglePlayback,
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.fast_forward),
                      onPressed:
                          (state == PlayerState.stop || !data.isPlayerReady)
                              ? null
                              : data.next,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child:
                      // Consumer<VolumeProvider>(
                      //   builder: (ctx, volume, _) =>
                      StreamBuilder<double>(
                          initialData: data.volume,
                          stream: data.volumeStream,
                          builder: (context, snapshot) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: (snapshot.data ?? globals.volume) == 0
                                      ? Icon(Icons.volume_mute)
                                      : Icon(Icons.volume_down),
                                  onPressed: () {
                                    double vol =
                                        snapshot.data ?? globals.volume;
                                    vol -= VolumeProvider.STEP;
                                    if (vol < 0) {
                                      vol = 0;
                                    }
                                    // volume = vol;
                                    data.setVolume(vol);
                                  },
                                ),
                                SizedBox(width: 4),
                                Slider(
                                  value: snapshot.data ?? globals.volume,
                                  min: 0,
                                  max: 1.0,
                                  onChanged: (value) {
                                    data.setVolume(value);
                                  },
                                ),
                                SizedBox(width: 4),
                                IconButton(
                                    icon: Icon(Icons.volume_up),
                                    onPressed: () {
                                      double vol =
                                          snapshot.data ?? globals.volume;
                                      vol += VolumeProvider.STEP;
                                      if (vol > 1.0) {
                                        vol = 1.0;
                                      }
                                      data.setVolume(vol);
                                    }),
                              ],
                            );
                          }),
                  // ),
                ),
              ],
            ),
          );
        });
  }
}
