import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spotify_clone/ad_helper.dart';
import 'package:spotify_clone/json/songs_json.dart';
import 'package:spotify_clone/pages/music_detail_page.dart';
import 'package:spotify_clone/theme/colors.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  AdmobHelper admobHelper = new AdmobHelper();





  int activeMenu1 = 0;
  int activeMenu2 = 2;
  List songs = [];
  List songs2 = [];
  List colors = [Colors.red,Colors.blue,Colors.white,Colors.orange,Colors.green,Colors.purple,Colors.grey,Colors.pink];
  bool isloading = false;
  bool issearching = false;
  bool isok = false;
  bool isok2 = false;
  String searchq = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  @override
  void initState() { 
    super.initState();
    
    addsi();

    fetchSongs();
    fetchsong2();
    
  }
  void addsi() async{
    await admobHelper.createRewardad();
    
  }

  

  

  fetchSongs() async {
    // var REQURL = "https://youtube-music-shibam.herokuapp.com/youtube-data/songs";
    var response = await http.get(
        Uri.https('yt-music-sn.herokuapp.com', 'youtube-data/new t serize song'));
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

  fetchsong2() async {
    // var REQURL = "https://youtube-music-shibam.herokuapp.com/youtube-data/songs";
    var response = await http.get(
        Uri.https('yt-music-sn.herokuapp.com', 'youtube-data/Zee music songs'));
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      setState(() {
        songs2 = items;
        isok = true;
      });
    } else {
      setState(() {
        songs2 = [];
        isok = false;
      });
    }
  }

  Widget getAppBar() {
    return AppBar(
      backgroundColor: black,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "YTFY",
              style: TextStyle(
                  fontSize: 20, color: white, fontWeight: FontWeight.bold),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
                          onTap: () async{
                          
                            // setState(() {
                            //   isok = false;
                            // });
                            // var urlmp = "";
                            // var response = await http.get(
                            //     Uri.https('ytmusic-uf.herokuapp.com', 'mp3/$vid'));
                                
                            // if (response.statusCode == 200) {
                            //   var items = json.decode(response.body);
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
                                title.toString(),
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
                                  "",
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
          ),
          SizedBox(
            height: 10,
          ),
          isok?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30, top: 20),
                  child: Row(
                      children: List.generate(song_type_2.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 25),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            activeMenu2 = index;
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              song_type_2[index],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: activeMenu2 == index ? primary : grey,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            activeMenu2 == index
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
                    children: List.generate(songs2.length, (index) {
                      var vid = songs2[index]['id'];
                      var title = songs2[index]['title'];
                      if(title.toString().length >= 31){
                        title = title.toString().substring(0,30);
                      }
                      return Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: GestureDetector(
                          onTap: () async{
                            // setState(() {
                            //   isok = false;
                            // });
                            // var urlmp = "";
                            // var response = await http.get(
                            //     Uri.https('ytmusic-uf.herokuapp.com', 'mp3/$vid'));
                                
                            // if (response.statusCode == 200) {
                            //   var items = json.decode(response.body);
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
                                      title: songs2[index]['title'],
                                      color: randomItem,
                                      description: "Description",
                                      img: songs2[index]['thumbnails'][0]['url'],
                                      songUrl: vid,
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
                                        image:
                                            NetworkImage(songs2[index]['thumbnails'][0]['url']),
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
                              // s
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
        ],
      ),
    );
  }
}
