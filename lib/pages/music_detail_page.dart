import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:spotify_clone/theme/colors.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:youtube_explode_dart/src/youtube_explode_base.dart';
import 'package:http/http.dart' as http;

class MusicDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final String img;
  final String songUrl;
  final String ChannelName;

  const MusicDetailPage(
      {Key key,
      this.title,
      this.description,
      this.color,
      this.img,
      this.songUrl,
      this.ChannelName})
      : super(key: key);
  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  double _currentSliderValue = 20;

  // audio player here
  final assetsAudioPlayer = AssetsAudioPlayer.withId("0");
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  AudioCache audioCache;
  bool isplay = true;
  bool playready = false;
  var realurl = "";
  var aftersongs;

  @override
  void initState() {
    print(widget.ChannelName);
    super.initState();
    getUrl();
    getAfterSongs();
  }

  void play_song() async {
    try {
      await assetsAudioPlayer.open(
        Audio.network(realurl),
        autoStart: true,
        showNotification: true,
        playInBackground: PlayInBackground.enabled,
      );

      assetsAudioPlayer.isPlaying.listen((event) {
        print("song playing state");
        print(event);
        if (event == true) {
          print("set to true");
          setState(() {
            isplay = true;
          });
        } else {
          setState(() {
            isplay = false;
          });
        }
      });

      assetsAudioPlayer.onReadyToPlay.listen((event) {
        print("event details for this song is");
        print(event.duration);
        setState(() {
          duration = event.duration;
        });
      });

      assetsAudioPlayer.currentPosition.listen((dd) {
        setState(() {
          position = dd;
          playready = true;
        });
      });
    } catch (t) {
      //mp3 unreachable
    }
  }

  Future<void> getUrl() async {
    var yt = YoutubeExplode();

    var manifest = await yt.videos.streamsClient.getManifest(widget.songUrl);

    setState(() {
      realurl = manifest.audioOnly.first.url.toString();
    });
    print(manifest.audioOnly.first.url);
    yt.close();
    play_song();
  }

  void getAfterSongs() async {
    var response = await http.get(Uri.https(
        'yt-music-sn.herokuapp.com', 'playlist/${widget.ChannelName}'));
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        aftersongs=items;
      });
      print(items);
    } else {
      print("Api not Called");
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: black,
      elevation: 0,
      actions: [],
    );
  }

  Widget getBody() {
    var title = widget.title;
    if (title.toString().length >= 36) {
      title = title.toString().substring(0, 35);
    }
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  width: size.width - 100,
                  height: size.width - 100,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: widget.color,
                        blurRadius: 150,
                        spreadRadius: 20,
                        offset: Offset(20, 20))
                  ], borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                child: Container(
                  width: size.width - 60,
                  height: size.width - 60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.img), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Container(
              width: size.width - 80,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18,
                              color: white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: 150,
                        child: Text(
                          "    ",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15, color: white.withOpacity(0.5)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Slider(
              activeColor: primary,
              min: 0.0,
              value: position.inSeconds.toDouble(),
              max: duration.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  assetsAudioPlayer.seek(new Duration(seconds: value.toInt()));
                });
              }),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(
                      Feather.shuffle,
                      color: white.withOpacity(0.8),
                      size: 25,
                    ),
                    onPressed: () {
                      showBottomBar();
                    }),
                IconButton(
                    icon: Icon(
                      Feather.skip_back,
                      color: white.withOpacity(0.8),
                      size: 25,
                    ),
                    onPressed: null),
                IconButton(
                    iconSize: 50,
                    icon: Container(
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: primary),
                      child: Center(
                        child: Icon(
                          isplay
                              ? Entypo.controller_stop
                              : Entypo.controller_play,
                          size: 28,
                          color: white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (isplay) {
                        assetsAudioPlayer.pause();
                        setState(() {
                          isplay = false;
                        });
                      } else {
                        assetsAudioPlayer.play();
                        setState(() {
                          isplay = true;
                        });
                      }
                    }),
                IconButton(
                    icon: Icon(
                      Feather.skip_forward,
                      color: white.withOpacity(0.8),
                      size: 25,
                    ),
                    onPressed: null),
                IconButton(
                    icon: Icon(
                      AntDesign.retweet,
                      color: white.withOpacity(0.8),
                      size: 25,
                    ),
                    onPressed: null)
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          playready
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Feather.tv,
                      color: primary,
                      size: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        "Playing",
                        style: TextStyle(color: primary),
                      ),
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.green)),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        "please wait",
                        style: TextStyle(color: primary),
                      ),
                    )
                  ],
                )
        ],
      ),
    );
  }

  //bottom sheet ..................................................
  void showBottomBar() async {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          child: Text(aftersongs.toString()),
        ),
      ),
    );
  }
}
