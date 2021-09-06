import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotify_clone/json/songs_json.dart';

class HiveMethods {
  String hive_box = "Favourites";

  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  @override
  addSong(var song) async {
    var box = await Hive.openBox(hive_box);

    var logMap = song.toMap(song);

    // box.put("custom_key", logMap);
    int idOfInput = await box.add(logMap);

    close();

    return idOfInput;
  }

  updateLogs(int i, newLog) async {
    var box = await Hive.openBox(hive_box);

    var newLogMap = newLog.toMap(newLog);

    box.putAt(i, newLogMap);

    close();
  }

  @override
  Future<List> getSongs() async {
    var box = await Hive.openBox(hive_box);

    List songsList = [];

    for (int i = 0; i < box.length; i++) {
      var songMap = box.getAt(i);

      songsList.add(songMap);
    }
    return songsList;
  }

  @override
  deleteLogs(int logId) async {
    var box = await Hive.openBox(hive_box);

    await box.deleteAt(logId);
    // await box.delete(logId);
  }

  @override
  close() => Hive.close();
}