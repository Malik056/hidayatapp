import 'package:assets_audio_player/assets_audio_player.dart' as audio_player;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/models/playlist.dart';
import 'package:hidayat/providers/bayans.dart';
import 'package:hidayat/providers/current_playing.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class BayansRoute extends StatelessWidget {
  final Playlist playlist;

  const BayansRoute({Key key, this.playlist}) : super(key: key);

  bool isLoading(BayansProvider data) {
    return (data.connectionState == ConnectionState.waiting &&
        (data.state == null || data.state.isEmpty));
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: ChangeNotifierProvider<BayansProvider>(
          create: (context) => BayansProvider(playlist.id),
          child: Consumer<PlayingNowProvider>(
            builder: (ctx, playingNow, _) => Consumer<BayansProvider>(
              builder: (ctx, data, _) {
                return NestedScrollView(
                  headerSliverBuilder: (ctx, _) {
                    return [
                      SliverAppBar(
                        floating: true,
                        pinned: true,
                        expandedHeight: mediaQuery.height * 0.3,
                        flexibleSpace: FlexibleSpaceBar(
                          background: CachedNetworkImage(
                            imageUrl: playlist.image ?? '',
                            fadeInDuration: Duration.zero,
                            fadeOutDuration: Duration.zero,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                                    child: CircularProgressIndicator(
                              value: (progress?.downloaded ?? 0.0) /
                                  (progress?.totalSize ?? 1),
                            )),
                            errorWidget: (context, url, error) => Image.asset(
                                'images/placeholder_playlist.jpg',
                                fit: BoxFit.cover),
                            // placeholder: (ctx, url) => Image.asset(
                            //     'images/placeholder_playlist.jpg',
                            //     fit: BoxFit.cover),
                          ),
                        ),
                        title: Text(playlist.name ?? 'Playlist'),
                      )
                    ];
                  },
                  body: isLoading(data)
                      ? Center(child: CircularProgressIndicator())
                      : (data.state?.isEmpty ?? true)
                          ? Center(
                              child: Text(
                                "Nothing Found",
                                style: textTheme.headline5.copyWith(
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: data.state.length,
                              itemBuilder: (ctx, index) {
                                playlist.bayans = data.state;
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        var provider =
                                            Provider.of<PlayingNowProvider>(
                                                context,
                                                listen: false);

                                        provider.addPlaylist(
                                            playlist.bayans
                                                .map((e) => audio_player.Audio
                                                    .liveStream(e.link))
                                                .toList(),
                                            index,
                                            playlist);
                                      },
                                      child: Container(
                                        height: 40,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "${index + 1}",
                                                  textAlign: TextAlign.center,
                                                  style: textTheme.subtitle1
                                                      .copyWith(
                                                    color: Colors.grey,
                                                  ),
                                                )),
                                            Expanded(
                                              flex: 4,
                                              child: (playingNow?.state
                                                              ?.playlist?.id ==
                                                          playlist.id &&
                                                      playingNow.state
                                                              .bayanIndex ==
                                                          index)
                                                  ? Marquee(
                                                      text: data.state[index]
                                                              .name ??
                                                          "Anonymous",
                                                      style: textTheme.subtitle1
                                                          .copyWith(
                                                        color: Colors.black,
                                                      ),
                                                      blankSpace: 200,
                                                    )
                                                  : Text(
                                                      data.state[index].name ??
                                                          "Anonymous",
                                                      style: textTheme.subtitle1
                                                          .copyWith(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                            ),
                                            if (playingNow
                                                        ?.state?.playlist?.id ==
                                                    playlist.id &&
                                                playingNow.state.bayanIndex ==
                                                    index)
                                              Icon(Icons.volume_up)
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                );
                              },
                            ),
                );
              },
            ),
          )),
    );
  }
}
