import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:loview/models/spot.dart';

import 'package:loview/providers/api_spots_model.dart';

import 'package:loview/ui/webview.dart';
import 'package:loview/ui/subtitle.dart';
import 'package:loview/ui/grid_spots.dart';

class LoviewDetail extends StatefulWidget {
  const LoviewDetail({
    this.spot,
  });

  final Spot spot;

  @override
  _LoviewDetailState createState() => _LoviewDetailState(spot: spot);
}

class _LoviewDetailState extends State<LoviewDetail> {
  _LoviewDetailState({
    this.spot,
  });

  final Spot spot;

  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = true;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(spot.video),
      flags: YoutubePlayerFlags(
        mute: true,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<ApiSpotsModel>(context);
    final spot = model.tappedSpot;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '추천여행코스',
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.258,
            fontFamily: "Roboto",
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        constraints: BoxConstraints.expand(height: size.height - 56 - 56 - 74),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: new BoxConstraints(),
            child: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text(
                                spot.title,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.154,
                                  fontFamily: "Roboto",
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8),
                              child: Text(
                                spot.addr,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  letterSpacing: 0.154,
                                  fontFamily: "Roboto",
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 12),
                          child: Opacity(
                            opacity: 0.8,
                            child: IconButton(
                              iconSize: 40,
                              icon: Icon(
                                model.checkFavorited(spot.id) ? Icons.favorite : Icons.favorite_border,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                if (model.checkFavorited(spot.id)) {
                                  model.removeSpotToFavorite(spot.id);
                                }
                                else {
                                  model.addSpotToFavorite(spot.id, spot);
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.blueAccent,
                      topActions: <Widget>[
                        SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            _controller.metadata.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                      bottomActions: [
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                        RemainingDuration(),
                      ],
                      onReady: () {
                        _isPlayerReady = true;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8, top: 8, bottom: 8),
                    child: Text(
                      spot.desc,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        letterSpacing: 0.154,
                        fontFamily: "Roboto",
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                      child: Row(
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              "BLOG",
                              style: TextStyle(
                                color: Color.fromARGB(255, 97, 0, 237),
                                fontSize: 14,
                                letterSpacing: 1.247,
                                fontFamily: "Roboto",
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () => _handleURLButtonPress(context, spot.blog),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              _muted ? Icons.volume_off : Icons.volume_up,
                              color: Color.fromARGB(255, 97, 0, 237),
                            ),
                            onPressed: _isPlayerReady
                                ? () {
                              _muted
                                  ? _controller.unMute()
                                  : _controller.mute();
                              setState(() {
                                _muted = !_muted;
                              });
                            }
                                : null,
                          ),
                          Spacer(),
                          FlatButton(
                            child: Text(
                              "YOUTUBE에서 보기",
                              style: TextStyle(
                                color: Color.fromARGB(255, 97, 0, 237),
                                fontSize: 14,
                                letterSpacing: 1.247,
                                fontFamily: "Roboto",
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              _launchURL(spot.video);
                            },
                          ),
                        ],
                      )
                  ),
                  SubTitle(title: "추천여행코스", more: false),
                  GridSpots(
                    spots: model.currentLoviewSpots,
                    represented: false,
                    onClickWidget: LoviewDetail(),
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 1,
                    cardScale: 1,
                    showAddr: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WebViewContainer(url)));
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
