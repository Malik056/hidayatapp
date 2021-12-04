import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hidayat/models/playlist.dart';
import 'package:hidayat/routes/bayans.dart';

class PlaylistWidget extends StatelessWidget {
  final Playlist playlist;

  const PlaylistWidget({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) {
            return BayansRoute(playlist: playlist);
          },
        ));
      },
      child: Container(
        decoration: ShapeDecoration(
            color: Colors.black45,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )),
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                imageUrl: playlist.image ?? '',
                errorWidget: (context, url, error) {
                  print(error);
                  return Image.asset(
                    'images/placeholder_playlist.jpg',
                    fit: BoxFit.cover,
                  );
                },
                placeholder: (context, url) {
                  return Image.asset(
                    'images/placeholder_playlist.jpg',
                    fit: BoxFit.cover,
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
                    playlist.name ?? 'Номаълум',
                    textAlign: TextAlign.start,
                    style: theme.subtitle1!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    playlist.description,
                    textAlign: TextAlign.start,
                    style: theme.bodyText2!.copyWith(color: Colors.white),
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

class EmptyPlaylistWidget extends StatelessWidget {
  final VoidCallback onReload;
  const EmptyPlaylistWidget({
    Key? key,
    required this.onReload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.7,
            child: SizedBox.expand(
                child: Container(
              decoration: ShapeDecoration(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            )),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: "Плейлист ёфт нашуд!\n"),
                TextSpan(
                  text: "Ба интернет пайваст шавед!\n",
                  style: theme.bodyText2!.copyWith(color: Colors.white),
                ),
                WidgetSpan(
                  child: TextButton(
                    onPressed: onReload,
                    child: Text(
                      "Инҷоро зер кунед".toUpperCase(),
                      style: theme.subtitle1!.copyWith(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ]),
              textAlign: TextAlign.center,
              style: theme.headline5!.copyWith(color: Colors.white),
            ),
          )),
        ],
      ),
    );
  }
}
