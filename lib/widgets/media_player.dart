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
      if (providerData.state == null ||
          providerData.state.playlist?.bayans == null ||
          providerData.state.playlist.bayans.isEmpty) {
        return _Player(
          bayanName: "No Audio File",
          position: Duration.zero,
          playing: false,
        );
      }

      my_playlist.Playlist playlist = providerData.state.playlist;
      Bayan bayan = playlist.bayans[providerData.state.bayanIndex];
      bool playing = providerData.player.isPlaying.value;
      print("playing: $playing");
      Duration position =
          providerData.player.currentPosition.value ?? Duration.zero;
      return _Player(
        bayanName: bayan.name,
        playing: playing,
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
          providerData.pausePlayPlayer();
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
  final bool playing;

  const _Player(
      {Key key,
      this.position,
      this.bayanName,
      this.onPlayPressed,
      this.onSeekBackward,
      this.onSeekForward,
      this.playing})
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
            IconButton(
              icon: Icon(Icons.replay_10),
              onPressed: onSeekBackward,
            ),
            IconButton(
                icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                onPressed: onPlayPressed),
            IconButton(icon: Icon(Icons.forward_10), onPressed: onSeekForward),
          ],
        ),
      ),
    );
  }
}
