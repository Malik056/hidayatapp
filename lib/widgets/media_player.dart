import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/models/bayan.dart';
import 'package:hidayat/models/playlist.dart' as my_playlist;
import 'package:hidayat/providers/current_playing.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class MediaPlayerBarWidget extends StatefulWidget {
  MediaPlayerBarWidget({Key key}) : super(key: key);

  @override
  _MediaPlayerBarWidgetState createState() => _MediaPlayerBarWidgetState();
}

class _MediaPlayerBarWidgetState extends State<MediaPlayerBarWidget> {
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Consumer<PlayingNowProvider>(builder: (ctx, providerData, _) {
      print(providerData.state.audioState);
      if (providerData.state == null ||
          providerData.state.playlist?.bayans == null ||
          providerData.state.playlist.bayans.isEmpty ||
          providerData.state.audioState == AudioState.none) {
        return _Player(
          bayanName: "No Audio File",
          position: Duration.zero,
          state: providerData?.state?.audioState ?? AudioState.none,
        );
      }

      my_playlist.Playlist playlist = providerData.state.playlist;
      Bayan bayan = playlist.bayans[providerData.state.bayanIndex];
      Duration position =
          providerData.player.currentPosition.value ?? Duration.zero;
      return _Player(
        bayanName: bayan.name,
        state: providerData.state.audioState,
        onSeekForward: () {
          // var newDuration = position + Duration(seconds: 15);
          providerData.forward(Duration(seconds: 15));
          // if (newDuration > duration) {
          //   newDuration = duration;
          // }
        },
        onSeekBackward: () {
          var newDuration = position - Duration(seconds: 15);
          if (newDuration < Duration.zero) {
            newDuration = Duration.zero;
          }
          providerData.rewind(Duration(seconds: 15));
        },
        position: position,
        onPlayPressed: () {
          providerData.startPausePlayer();
          // if (playing) {
          //   AudioService.pause();
          // } else {
          //   AudioService.play();
          // }
        },
      );
    });
  }
}

class _Player extends StatelessWidget {
  final Duration position;
  final String bayanName;
  final Function() onPlayPressed;
  final Function() onSeekBackward;
  final Function() onSeekForward;
  final AudioState state;

  const _Player(
      {Key key,
      this.position,
      this.bayanName,
      this.onPlayPressed,
      this.onSeekBackward,
      this.onSeekForward,
      this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 12.0,
      margin: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Marquee(
                text: bayanName ?? "Anonymous",
                style: textTheme.subtitle1,
                scrollAxis: Axis.horizontal,
                blankSpace: 200,
              ),
            ),
            if (state != AudioState.none)
              IconButton(
                icon: Icon(Icons.replay_10),
                onPressed: onSeekBackward,
              ),
            if (state != AudioState.none)
              IconButton(
                  icon: state == AudioState.loading
                      ? AspectRatio(
                          child: CircularProgressIndicator(),
                          aspectRatio: 1.0,
                        )
                      : Icon(state == AudioState.play
                          ? Icons.pause
                          : Icons.play_arrow),
                  onPressed: onPlayPressed),
            if (state != AudioState.none)
              IconButton(
                  icon: Icon(Icons.forward_10), onPressed: onSeekForward),
          ],
        ),
      ),
    );
  }
}
