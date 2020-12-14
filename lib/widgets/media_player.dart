import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaPlayerBarWidget extends StatefulWidget {
  MediaPlayerBarWidget({Key key}) : super(key: key);

  @override
  _MediaPlayerBarWidgetState createState() => _MediaPlayerBarWidgetState();
}

class _MediaPlayerBarWidgetState extends State<MediaPlayerBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(""),
            Spacer(),
            Icon(Icons.skip_previous),
            Icon(Icons.replay_10),
            Icon(Icons.play_arrow),
            Icon(Icons.forward_10),
            Icon(Icons.skip_next),
          ],
        ),
      ),
    );
  }
}
