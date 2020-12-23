import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/models/bayan.dart';
import 'package:hidayat/models/playlist.dart' as myPlaylist;
import 'package:hidayat/providers/current_playing.dart';
import 'package:hidayat/providers/volume.dart';
import 'package:provider/provider.dart';

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
        myPlaylist.Playlist playlist = data.state?.playlist;
        Bayan bayan;
        if (playlist != null &&
            playlist.bayans != null &&
            playlist.bayans.isNotEmpty) {
          int index = data.state.bayanIndex ?? 0;
          if (index >= playlist.bayans.length) {
            index = 0;
          }
          bayan = playlist.bayans[index];
        }

        if (bayan == null) {
          return _PlayerSheet(
            position: Duration.zero,
            volume: data.getVolume(),
            audioState: data.state.audioState,
            onVolumeUpdate: (value) {
              data.setVolume(value);
            },
            duration: Duration.zero,
            playlistName: "No Playlist Selected",
            bayanName: "No Audio Selected",
          );
        }

        int index = data?.state?.bayanIndex;
        List<Bayan> bayans = playlist?.bayans;

        if (bayans != null && bayans.isNotEmpty) {
          bayan = bayans[index];
        }

        if (data?.state?.bayanIndex == null || bayan == null) {
          return _PlayerSheet(
            position: Duration.zero,
            audioState: data.state.audioState,
            volume: data.getVolume(),
            onVolumeUpdate: (value) {
              data.setVolume(value);
            },
            duration: Duration.zero,
            playlistName: "No Playlist Selected",
            bayanName: "No Audio Selected",
          );
        }

        Duration position = data.player.currentPosition.value ?? Duration.zero;

        return _PlayerSheet(
          position: position,
          playlistName: playlist.name,
          volume: data.getVolume(),
          duration: data.state.duration ?? Duration.zero,
          onVolumeUpdate: (value) {
            data.setVolume(value);
          },
          audioState: data.state.audioState,
          bayanName: "${index + 1}. ${bayan.name ?? "Anonymous"}",
          onPlayPressed: () {
            data.player.playOrPause();
          },
          onSkipPrevious: index == 0
              ? null
              : () async {
                  data.previous();
                  // var state = PlayingNowState();
                  // if (!(AudioService.running ?? false)) {
                  //   await AudioService.start(
                  //       backgroundTaskEntrypoint: entrypoint);
                  // }
                  // if ((index - 1) >= 0) {
                  //   if (!(AudioService.running ?? false)) {
                  //     await AudioService.start(
                  //         backgroundTaskEntrypoint: entrypoint);
                  //   }
                  //   state.duration = Duration(
                  //       seconds:
                  //           await AudioService.customAction("skipPrevious") ??
                  //               0);
                  //   state.bayanIndex = index - 1;
                  //   state.playlist = playlist;
                  //   state.duration = duration;
                  //   data.state = state;
                  // }
                },
          onSkipNext: index == bayans.length - 1
              ? null
              : () async {
                  data.next();
                  // var state = PlayingNowState();
                  // if ((index + 1) < bayans.length) {
                  //   if (!(AudioService.running ?? false)) {
                  //     await AudioService.start(
                  //         backgroundTaskEntrypoint: entrypoint);
                  //   }
                  //   state.duration = Duration(
                  //       seconds:
                  //           await AudioService.customAction("skipNext") ?? 0);
                  //   state.bayanIndex = index + 1;
                  //   state.playlist = playlist;
                  //   state.duration = duration;
                  //   data.state = state;
                  // }
                },
          onSeekForward: () {
            data.forward(Duration(seconds: 15));
            // var newDuration = position + Duration(seconds: 15);
            // if (newDuration > duration) {
            //   newDuration = duration;
            // }
            // AudioService.seekTo(newDuration);
          },
          onSeekBackward: () {
            data.rewind(Duration(seconds: 15));
            // var newDuration = position - Duration(seconds: 15);
            // if (newDuration < Duration.zero) {
            //   newDuration = Duration.zero;
            // }
            // AudioService.seekTo(newDuration);
          },
        );
      },
    );
  }
}

class _PlayerSheet extends StatelessWidget {
  final AudioState audioState;
  final Duration position;
  final String bayanName;
  final String playlistName;
  final Duration duration;
  final Function() onPlayPressed;
  final Function() onSeekBackward;
  final Function() onSeekForward;
  final Function() onSkipNext;
  final Function() onSkipPrevious;
  final Function(Duration) seekTo;
  final Function(double) onVolumeUpdate;
  final double volume;

  const _PlayerSheet({
    Key key,
    @required this.audioState,
    this.position,
    this.bayanName,
    @required this.playlistName,
    this.duration,
    this.onPlayPressed,
    this.onSeekBackward,
    this.onSeekForward,
    this.onSkipNext,
    @required this.volume,
    this.seekTo,
    @required this.onVolumeUpdate,
    this.onSkipPrevious,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Slider(
            value: position.inSeconds > duration.inSeconds
                ? duration.inSeconds.toDouble()
                : position.inSeconds.toDouble(),
            max: duration.inSeconds.toDouble(),
            min: 0,
            onChanged: (value) {
              seekTo(Duration(seconds: value.toInt()));
            },
          ),
          audioState == AudioState.play
              ? Text(getTimeFromDuration(position))
              : Text("0:00"),
          SizedBox(height: 10),
          Text(
            '$bayanName',
            textAlign: TextAlign.center,
            style: textTheme.headline6,
          ),
          Text(
            playlistName,
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
                onPressed: onSkipPrevious,
              ),
              Spacer(),
              AudioState.loading == audioState
                  ? IconButton(
                      onPressed: null,
                      icon: AspectRatio(
                        aspectRatio: 1.0,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : IconButton(
                      icon: Icon(audioState == AudioState.play
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: onPlayPressed,
                    ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.fast_forward),
                onPressed: onSkipNext,
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
                Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_down),
                  onPressed: () {
                    double vol = volume;
                    vol -= VolumeProvider.STEP;
                    if (vol < 0) {
                      vol = 0;
                    }
                    // volume = vol;
                    onVolumeUpdate(vol);
                  },
                ),
                SizedBox(width: 4),
                Slider(
                  value: volume,
                  min: 0,
                  max: 1.0,
                  onChanged: (value) {
                    // volume.volume = value;
                    onVolumeUpdate(value);
                  },
                ),
                SizedBox(width: 4),
                IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: () {
                      double vol = volume;
                      vol += VolumeProvider.STEP;
                      if (vol > 1.0) {
                        vol = 1.0;
                      }
                      // volume.volume = vol;
                      onVolumeUpdate(vol);
                    }),
              ],
            ),
            // ),
          ),
        ],
      ),
    );
  }
}
