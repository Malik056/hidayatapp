import 'package:flutter/material.dart';
import 'package:hidayat/models/bayan.dart';
import 'package:hidayat/models/playlist.dart';
import 'package:hidayat/providers/current_playing.dart';
import 'package:hidayat/providers/volume.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class MediaPlayerSheet extends StatefulWidget {
  @override
  _MediaPlayerSheetState createState() => _MediaPlayerSheetState();
}

class _MediaPlayerSheetState extends State<MediaPlayerSheet> {
  double sliderValue = 0;
  double volume = 100;

  String getTimeFromDuration(Duration time) {
    int totalSeconds = time.inSeconds;
    int totalMinutes = time.inMinutes;
    int seconds = totalSeconds - (totalMinutes * 60);
    return "${totalMinutes < 10 ? '0$totalMinutes' : totalMinutes}:${seconds < 10 ? '0$seconds' : seconds}";
  }

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

      if (bayan == null) {
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
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Slider(
              value: data.position.inSeconds.toDouble(),
              max: data.duration.inSeconds.toDouble(),
              min: 0,
              onChanged: (value) {
                data.forward(Duration(seconds: value.toInt()));
              },
            ),
            Text(getTimeFromDuration(data.position)),
            SizedBox(height: 10),
            Text(bayan?.name, textAlign: TextAlign.center),
            Text(
              playlist.name ?? "Anonymous Playlist",
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
                  onPressed: () {},
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {},
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.fast_forward),
                  onPressed: () {},
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: Consumer<VolumeProvider>(
                builder: (ctx, volume, _) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_down),
                      onPressed: () {
                        double vol = volume.volume;
                        vol -= VolumeProvider.STEP;
                        if (vol < 0) {
                          vol = 0;
                        }
                        volume.volume = vol;
                        data.setVolume(vol);
                      },
                    ),
                    SizedBox(width: 4),
                    Slider(
                      value: volume.volume,
                      onChanged: (value) {
                        volume.volume = value;
                        data.setVolume(value);
                      },
                    ),
                    SizedBox(width: 4),
                    IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: () {
                          double vol = volume.volume;
                          vol += VolumeProvider.STEP;
                          if (vol > volume.maxVolume) {
                            vol = volume.maxVolume;
                          }
                          volume.volume = vol;
                          data.setVolume(vol);
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
