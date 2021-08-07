import 'package:flutter/material.dart';
import 'package:spotify_clone/ad_helper.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';


class SettingsPage extends StatefulWidget {
  

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AdmobHelper admobHelper = new AdmobHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("          Made with ❤️ by Shibam \n If you want to appreciate my work",style: TextStyle(color: Colors.white),),
          SizedBox(height: 20,),
          
        ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("watch a add"),
                onPressed:()async{
                  await admobHelper.createRewardad();
                })
            ],
          ),
          SizedBox(height: 50,),
          Center(child: Text("If app is not performing well here clear app catche",style: TextStyle(color: Colors.white))),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Clear Catche"),
                onPressed:()async{
                  await DefaultCacheManager().emptyCache();
                })
            ],
          ),
        ],
      )
    );
  }
}