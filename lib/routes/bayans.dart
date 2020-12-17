import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/models/playlist.dart';
import 'package:hidayat/providers/bayans.dart';
import 'package:hidayat/providers/current_playing.dart';
import 'package:hidayat/providers/playlists.dart';
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
          child: Consumer<BayansProvider>(
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
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                                  child: CircularProgressIndicator(
                            value: progress.downloaded / progress.totalSize,
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
                                    onTap: () {
                                      var state =
                                          Provider.of<PlayingNowProvider>(
                                                  context)
                                              .state;
                                      if (state.playlist == null ||
                                          state.playlist.id != playlist.id ||
                                          state.bayanIndex != index) {
                                        PlayingNowState newState =
                                            PlayingNowState();
                                        newState.playlist = playlist;
                                        newState.bayanIndex = index;
                                      } else {}
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
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
                                            child: Text(
                                              data.state[index].name,
                                              style:
                                                  textTheme.subtitle1.copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
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
          )),
    );
  }
}
