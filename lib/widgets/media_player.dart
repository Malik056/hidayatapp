import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/models/bayan.dart';
import 'package:hidayat/models/playlist.dart';
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
    return Consumer<PlayingNowProvider>(builder: (ctx, data, _) {
      Playlist playlist = data.state?.playlist;
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

      if (bayan == null || bayan.link == null || bayan.link.isEmpty) {
        return Container(
          child: Center(
            child: Marquee(
              text: "Select an audio to play",
              style: textTheme.subtitle1.copyWith(color: Colors.black),
              blankSpace: 200,
            ),
          ),
        );
      }

      return Card(
        elevation: 12.0,
        margin: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Marquee(
                  text: bayan.name ?? "Anonymous",
                  scrollAxis: Axis.horizontal,
                  blankSpace: 200,
                ),
              ),
              IconButton(icon: Icon(Icons.replay_10), onPressed: () {}),
              IconButton(icon: Icon(Icons.play_arrow), onPressed: () {}),
              IconButton(icon: Icon(Icons.forward_10), onPressed: () {}),
            ],
          ),
        ),
      );
    });
  }
}
