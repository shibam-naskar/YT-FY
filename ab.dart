import 'package:youtube_explode_dart/youtube_explode_dart.dart';

var yt = YoutubeExplode();

void main()async{
 var playlist = await yt.search.getVideos("jeno kichu mone korona");
 for(int i=0;i<playlist.length;i++){
   print({
     "img":playlist[i].thumbnails.mediumResUrl,
     "url":playlist[i].url,
     "id":playlist[i].id,
     "title":playlist[i].title,
     "channel":playlist[i].author
   });
 }
}