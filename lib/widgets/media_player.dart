import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    // ignore: unused_local_variable
    var textTheme = Theme.of(context).textTheme;
    return Consumer<PlayingNowProvider>(builder: (ctx, providerData, _) {
      return _Player(data: providerData);
    });
  }
}

class _Player extends StatelessWidget {
  final PlayingNowProvider data;

  const _Player({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 12.0,
      margin: EdgeInsets.zero,
      child: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<PlayerState>(
            initialData: data.playerState,
            stream: data.playerStateStream,
            builder: (context, playerState) {
              final state = playerState.data ?? PlayerState.stop;
              return Row(
                children: [
                  Expanded(
                    child: Marquee(
                      text: state == PlayerState.stop
                          ? "плейлист ба поён расид"
                          : data.bayanName ?? "Anonymous",
                      style: textTheme.subtitle1,
                      scrollAxis: Axis.horizontal,
                      blankSpace: 200,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.replay_10),
                    onPressed:
                        (state == PlayerState.stop || !data.isPlayerReady)
                            ? null
                            : () => data.rewind(Duration(seconds: 10)),
                  ),
                  IconButton(
                    icon: Icon(
                      state == PlayerState.play
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    onPressed:
                        (state == PlayerState.stop || !data.isPlayerReady)
                            ? null
                            : data.togglePlayback,
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_10),
                    onPressed:
                        (state == PlayerState.stop || !data.isPlayerReady)
                            ? null
                            : () => data.forward(
                                  Duration(seconds: 10),
                                ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
