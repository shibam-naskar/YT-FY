import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:spotify_clone/theme/colors.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:youtube_explode_dart/src/youtube_explode_base.dart';

class MusicDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final String img;
  final String songUrl;

  const MusicDetailPage(
      {Key key,
      this.title,
      this.description,
      this.color,
      this.img,
      this.songUrl})
      : super(key: key);
  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  double _currentSliderValue = 20;

  // audio player here
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration position = new Duration();
  AudioCache audioCache;
  bool isPlaying = true;
  bool playready = false;
  var realurl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUrl();
  }

  Future<void> getUrl() async {
    var yt = YoutubeExplode();

    var manifest = await yt.videos.streamsClient.getManifest(widget.songUrl);

    setState(() {
      realurl = manifest.audioOnly.first.url.toString();
    });
    print(manifest.audioOnly.first.url);
    yt.close();
    initPlayer();
  }

  initPlayer() async {
    await audioPlayer.play(realurl, isLocal: false);
    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(() {
        duration = dd;
        playready = true;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      setState(() {
        position = dd;
        playready = true;
      });
    });
  }

  playSound(localPath) async {
    await audioPlayer.play(realurl, isLocal: false);
    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(() {
        duration = dd;
        playready = true;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      setState(() {
        position = dd;
        playready = true;
      });
    });
  }

  stopSound(localPath) async {
    await audioPlayer.pause();
  }

  seekSound() async {
    var url = realurl;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    stopSound(realurl);
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
      actions: [
        
      ],
    );
  }

  Widget getBody() {
    var title = widget.title;
    if (title.toString().length>=36) {
      title = title.toString().substring(0,35);
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
                  audioPlayer.seek(new Duration(seconds: value.toInt()));
                });
                seekSound();
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
                    onPressed: null),
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
                          isPlaying
                              ? Entypo.controller_stop
                              : Entypo.controller_play,
                          size: 28,
                          color: white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        stopSound(realurl);
                        setState(() {
                          isPlaying = false;
                        });
                      } else {
                        playSound(realurl);
                        setState(() {
                          isPlaying = true;
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
}
