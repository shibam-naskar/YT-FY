import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spotify_clone/json/songs_json.dart';
import 'package:spotify_clone/pages/music_detail_page.dart';
import 'package:spotify_clone/theme/colors.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'package:youtube_explode_dart/src/youtube_explode_base.dart';



class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  int activeMenu1 = 0;
  int activeMenu2 = 2;
  List songs = [];
  List songs2 = [];
  List colors = [Colors.red,Colors.blue,Colors.white,Colors.orange,Colors.green,Colors.purple,Colors.grey,Colors.pink];
  bool isloading = false;
  bool issearching = false;
  bool isok = false;
  String searchq = "";
  String playurl = "";
  bool isok2 = false;

  

  @override
  void initState() { 
    super.initState();
    fetchSongs();
  }

  fetchSongs() async {
    // var REQURL = "https://youtube-music-shibam.herokuapp.com/youtube-data/songs";
    var response = await http.get(
        Uri.https('yt-music-sn.herokuapp.com', 'youtube-data/aaj jane ki zid na karo'));
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        songs = items;
        isok = true;
      });
    } else {
      setState(() {
        songs = [];
        isok = false;
      });
    }
  }
  getSearchSongs()async{
    var response = await http.get(
        Uri.https('yt-music-sn.herokuapp.com', 'youtube-data/$searchq'));
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        songs = items;
        isok = true;
      });
    } else {
      setState(() {
        songs = [];
        isok = false;
      });
    }
  }
 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        
        title: !issearching
            ? Text("YTFY")
            : TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.grey,
                  focusColor: Colors.grey,
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: "search songs",
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (text) {
                  setState(() {
                    searchq = text;
                  });
                },
                
              ),
        actions: <Widget>[
          issearching
              ? IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    getSearchSongs();
                    setState(() {
                      this.issearching = !this.issearching;
                      isok = false;
                    });
                  })
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this.issearching = !this.issearching;
                    });
                  })
        ],
        backgroundColor: Colors.black,
      ),
      body: Container(
        
      child: isok?Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 20),
                  child: Row(
                      children: List.generate(song_type_1.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            activeMenu1 = index;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song_type_1[index],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: activeMenu1 == index ? primary : grey,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            activeMenu1 == index
                                ? Container(
                                    width: 10,
                                    height: 3,
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.circular(5)),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    );
                  })),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Row(
                    children: List.generate(songs.length, (index) {
                      var vid = songs[index]['id'];
                      var title = songs[index]['title'];
                      if(title.toString().length >= 31){
                        title = title.toString().substring(0,30);
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: GestureDetector(
                          onTap: ()async {

                            
                            // setState(() {
                            //   isok = false;
                            // });
                            // var urlmp = "";

                            // var yt = YoutubeExplode();
                            
                            // var manifest = await yt.videos.streamsClient.getManifest(vid);
                              

                            // print(manifest.audioOnly.first.url);
                            // yt.close();
                          
                                
                            // if (manifest != 0) {
                            //   var items = manifest.audioOnly.first.url.toString();
                            //   setState(() {
                            //     urlmp = items;
                            //     isok2 = true;
                            //     isok = true;
                            //   });
                            // } else {
                            //   setState(() {
                            //     urlmp = "";
                            //     isok2 = false;
                            //     isok = true;
                            //   });
                            // }

                            var randomItem = (colors..shuffle()).first;

                            if (isok2==false) {
                              Navigator.push(
                                context,
                                PageTransition(
                                    alignment: Alignment.bottomCenter,
                                    child: MusicDetailPage(
                                      title: songs[index]['title'],
                                      color: randomItem,
                                      description: "Description",
                                      img: songs[index]['thumbnails'][0]['url'],
                                      songUrl: vid,
                                      ChannelName: songs[index]['channel']['name'],
                                    ),
                                    type: PageTransitionType.scale));
                            } else {
                            }
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(songs[index]['thumbnails'][0]['url']),
                                        fit: BoxFit.cover),
                                    color: primary,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                title,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: white,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: 180,
                                child: Text(
                                  " ",
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: grey,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ):Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
              valueColor:AlwaysStoppedAnimation<Color>(Colors.green
            )),
            ],
          )
    ),
    );
    
  }
}