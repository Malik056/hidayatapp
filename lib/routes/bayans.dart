// import 'package:assets_audio_player/assets_audio_player.dart' as audio_player;
// import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hidayat/models/bayan.dart';
import 'package:hidayat/models/playlist.dart' as myPlaylist;
import 'package:hidayat/providers/bayans.dart';
import 'package:hidayat/providers/connectivity.dart';
import 'package:hidayat/providers/current_playing.dart';
import 'package:hidayat/providers/download_provider.dart';
import 'package:hidayat/utils/globals.dart';
import 'package:hidayat/utils/utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';

class BayansRoute extends StatefulWidget {
  final myPlaylist.Playlist playlist;

  BayansRoute({Key? key, required this.playlist}) : super(key: key);

  @override
  State<BayansRoute> createState() => _BayansRouteState();
}

class _BayansRouteState extends State<BayansRoute> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading(BayansProvider data) {
    return (data.connectionState == ConnectionState.waiting &&
        (data.state.isEmpty));
  }

  bool _isAudioLoaded(ProcessingState state) {
    if (state == ProcessingState.idle || state == ProcessingState.completed) {
      return false;
    } else {
      return true;
    }
  }

  Widget buildDownloadBar(BuildContext context, BayansProvider provider,
      DownloadProvider downloadProvider) {
    List<Bayan> bayans = provider.state;
    int totalTasks = downloadProvider.totalTasks(widget.playlist.id);
    if (totalTasks == -1 || totalTasks == 0) {
      if (totalTasks == 0) {
        downloadProvider.removeAlltasksForPlaylist(widget.playlist.id);
      }
      bool downloaded = true;
      bayans.forEach((element) {
        if (element.filePath?.isEmpty ?? true) {
          downloaded = false;
        }
      });
      return TextButton.icon(
        onPressed: downloaded
            ? null
            : () async {
                if (Provider.of<ConnectivityProvider>(context, listen: false)
                        .state
                        ?.connected ??
                    false) {
                  try {
                    await downloadProvider.downloadPlaylist(widget.playlist);
                  } catch (ex) {
                    Utils.showInSnackbarError(_scaffoldKey, context,
                        "An Error Occurred while downloading! Please check your internet connection"); // TODO: TRANSLATION
                  }
                } else {
                  Utils.showInSnackbarError(_scaffoldKey, context,
                      "No Internet Connection"); // TODO: TRANSLATION
                }
              },
        icon: Icon(
          downloaded ? Icons.file_download_done : Icons.file_download,
        ),
        label: Text(downloaded ? "скачано" : "скачать"),
      );
    } else {
      double avgProgress = downloadProvider.avgProgress(widget.playlist.id);
      return Row(
        children: [
          Spacer(),
          Text('интизор шавед'),
          SizedBox(width: 10),
          Container(
            margin: EdgeInsets.all(10.0),
            width: 50,
            height: 50,
            child: LiquidCircularProgressIndicator(
              backgroundColor: Colors.white,
              // progressColor: Colors.blue,
              borderColor: Colors.transparent,
              borderWidth: 0.0,
              value: avgProgress,
              // progressValue: avgProgress,
              center: Text(
                '${(avgProgress * 100).toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mediaQuery = MediaQuery.of(context).size;
    final mediaQueryData = MediaQuery.of(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      top: false,
      bottom: true,
      minimum: EdgeInsets.only(bottom: kToolbarHeight),
      child: Scaffold(
        key: _scaffoldKey,
        body: ChangeNotifierProvider<BayansProvider>(
            create: (context) => BayansProvider(widget.playlist.id),
            child: Consumer<PlayingNowProvider>(
              builder: (ctx, PlayingNowProvider playingNow, _) =>
                  Consumer<BayansProvider>(
                builder: (ctx, data, _) {
                  return StreamBuilder<PlayerState>(
                      initialData: playingNow.playerState,
                      stream: playingNow.playerStateStream,
                      builder: (context, snapshot) {
                        return NestedScrollView(
                          headerSliverBuilder: (ctx, _) {
                            return [
                              SliverAppBar(
                                elevation: 0,
                                floating: true,
                                pinned: true,
                                backgroundColor: Colors.transparent,
                                expandedHeight: mediaQuery.height * 0.3,
                                flexibleSpace: CachedNetworkImage(
                                  height: mediaQuery.height * 0.3 +
                                      mediaQueryData.padding.top,
                                  width: mediaQuery.width,
                                  imageUrl: widget.playlist.image ?? '',
                                  fadeInDuration: Duration.zero,
                                  fadeOutDuration: Duration.zero,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                          child: CircularProgressIndicator(
                                    value: (progress.downloaded) /
                                        (progress.totalSize ?? 1),
                                  )),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                          'images/placeholder_playlist.jpg',
                                          fit: BoxFit.cover),
                                  // placeholder: (ctx, url) => Image.asset(
                                  //     'images/placeholder_playlist.jpg',
                                  //     fit: BoxFit.cover),
                                ),
                                title: Text(widget.playlist.name ?? 'Playlist'),
                              ),
                            ];
                          },
                          body: isLoading(data)
                              ? Center(child: CircularProgressIndicator())
                              : (data.state.isEmpty)
                                  ? Center(
                                      child: Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text:
                                                  "Could not load data\n"), // TODO: TRANSLATION
                                          TextSpan(
                                            text:
                                                "Check you internet connection\n", // TODO: TRANSLATION
                                            style:
                                                textTheme.subtitle1!.copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {});
                                              },
                                              child: Text(
                                                "Tap to Reload".toUpperCase(),
                                                style: textTheme.subtitle1!
                                                    .copyWith(
                                                  color: Colors.blue,
                                                  // fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]),
                                        textAlign: TextAlign.center,
                                        style: textTheme.headline4!.copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        Center(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    Consumer<DownloadProvider>(
                                                  builder: (context, provider,
                                                      child) {
                                                    return Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: buildDownloadBar(
                                                          context,
                                                          data,
                                                          provider),
                                                    );
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.tight,
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: StreamBuilder<int?>(
                                                stream: playingNow
                                                    .getCurrentIndexStream,
                                                builder:
                                                    (context, indexStream) {
                                                  return ListView.builder(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 0,
                                                    ),
                                                    itemCount:
                                                        data.state.length,
                                                    itemBuilder: (ctx, index) {
                                                      widget.playlist.bayans =
                                                          data.state;
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          InkWell(
                                                            onTap: () async {
                                                              var provider =
                                                                  Provider.of<
                                                                          PlayingNowProvider>(
                                                                      context,
                                                                      listen:
                                                                          false);
                                                              if (widget
                                                                      .playlist
                                                                      .bayans?[
                                                                          index]
                                                                      .id ==
                                                                  provider.id) {
                                                                provider
                                                                    .togglePlayback();
                                                                return;
                                                              }
                                                              String? pLId =
                                                                  provider
                                                                      .playlistId;
                                                              if (pLId ==
                                                                  widget
                                                                      .playlist
                                                                      .id) {
                                                                provider
                                                                    .playAtIndex(
                                                                        index);
                                                                return;
                                                              }
                                                              try {
                                                                await provider.playPlaylist(
                                                                    widget.playlist.bayans
                                                                            ?.map<AudioSource>((e) => (e.filePath?.isEmpty ?? true)
                                                                                    ? AudioSource.uri(
                                                                                        Uri.parse(e.link),
                                                                                        tag: MediaItem(
                                                                                          // Specify a unique ID for each media item:
                                                                                          id: e.id,
                                                                                          // Metadata to display in the notification:
                                                                                          album: widget.playlist.name ?? "Anonymous",
                                                                                          title: e.name ?? "Anonymous",
                                                                                          artUri: ((widget.playlist.image?.isEmpty ?? '') == '')
                                                                                              ? zPlaceHolderImage == null
                                                                                                  ? null
                                                                                                  : Uri.dataFromBytes(zPlaceHolderImage!.toList())
                                                                                              : Uri.parse(
                                                                                                  widget.playlist.image!,
                                                                                                ),
                                                                                          extras: {
                                                                                            "index": index,
                                                                                            "playlistId": widget.playlist.id,
                                                                                          },
                                                                                        ),
                                                                                      )
                                                                                    : AudioSource.uri(
                                                                                        Uri.parse(e.filePath!),
                                                                                        // tag:
                                                                                        // audio_player.Metas(
                                                                                        tag: MediaItem(
                                                                                          // Specify a unique ID for each media item:
                                                                                          id: e.id,
                                                                                          // Metadata to display in the notification:
                                                                                          album: widget.playlist.name ?? "Anonymous",
                                                                                          title: e.name ?? "Anonymous",
                                                                                          artUri: ((widget.playlist.image?.isEmpty ?? '') == '')
                                                                                              ? zPlaceHolderImage == null
                                                                                                  ? null
                                                                                                  : Uri.dataFromBytes(zPlaceHolderImage!.toList())
                                                                                              : Uri.parse(
                                                                                                  widget.playlist.image!,
                                                                                                ),
                                                                                          extras: {
                                                                                            "index": index,
                                                                                            "playlistId": widget.playlist.id,
                                                                                          },
                                                                                        ),
                                                                                      )
                                                                                // image: ((playlist.image?.isEmpty ?? '') == '')
                                                                                //     ? audio_player.MetasImage.asset('images/placeholder_playlist.jpg')
                                                                                //     : audio_player.MetasImage.network(playlist.image),
                                                                                // ),
                                                                                // ),
                                                                                )
                                                                            .toList() ??
                                                                        [],
                                                                    index);
                                                              } catch (ex) {
                                                                Utils
                                                                    .showInSnackbarError(
                                                                  _scaffoldKey,
                                                                  context,
                                                                  "Error while playing, check your network connection!", //TODO: Translation
                                                                );
                                                                print(ex);
                                                              }
                                                            },
                                                            child: Container(
                                                              height: 40,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Text(
                                                                        "${index + 1}",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: textTheme
                                                                            .subtitle1!
                                                                            .copyWith(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      )),
                                                                  Expanded(
                                                                    flex: 4,
                                                                    child: playingNow.id == widget.playlist.bayans?[index].id &&
                                                                            snapshot.data?.processingState !=
                                                                                null &&
                                                                            _isAudioLoaded(snapshot.data!.processingState)
                                                                        ? Marquee(
                                                                            text:
                                                                                data.state[index].name ?? "Anonymous",
                                                                            style:
                                                                                textTheme.subtitle1!.copyWith(
                                                                              color: Colors.black,
                                                                            ),
                                                                            blankSpace:
                                                                                200,
                                                                          )
                                                                        : Text(
                                                                            data.state[index].name ??
                                                                                "Anonymous",
                                                                            style:
                                                                                textTheme.subtitle1!.copyWith(
                                                                              color: Colors.black,
                                                                            ),
                                                                          ),
                                                                  ),
                                                                  if (playingNow
                                                                              .id ==
                                                                          widget
                                                                              .playlist
                                                                              .bayans?[
                                                                                  index]
                                                                              .id &&
                                                                      snapshot.data
                                                                              ?.processingState !=
                                                                          null &&
                                                                      _isAudioLoaded(snapshot
                                                                          .data!
                                                                          .processingState))
                                                                    Icon(Icons
                                                                        .volume_up),
                                                                  if (playingNow
                                                                          .id ==
                                                                      widget
                                                                          .playlist
                                                                          .bayans?[
                                                                              index]
                                                                          .id)
                                                                    SizedBox(
                                                                        width:
                                                                            10)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          if (index !=
                                                              data.state
                                                                      .length -
                                                                  1)
                                                            Divider(),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                }),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                        );
                      });
                },
              ),
            )),
      ),
    );
  }
}
