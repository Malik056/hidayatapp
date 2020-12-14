import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/models/playlist.dart';

class PlaylistWidget extends StatelessWidget {
  final Playlist playlist;

  const PlaylistWidget({Key key, this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) {
            return Center(
              child: Text("Hello"),
            );
          },
        ));
      },
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                imageUrl: playlist.imageUrl ?? '',
                errorWidget: (context, url, error) {
                  print(error);
                  return Image.asset(
                    'images/placeholder_playlist.jpg',
                    fit: BoxFit.fitHeight,
                  );
                },
                placeholder: (context, url) {
                  return Image.asset(
                    'images/placeholder_playlist.jpg',
                    fit: BoxFit.fitHeight,
                  );
                },
                fit: BoxFit.fitHeight,
                alignment: Alignment.center,
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    playlist.name ?? '',
                    textAlign: TextAlign.start,
                    style: theme.subtitle1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "This is description of this playlist, igone this beharvious",
                    textAlign: TextAlign.start,
                    style: theme.bodyText2.copyWith(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
