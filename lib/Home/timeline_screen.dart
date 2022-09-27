import 'package:another_flushbar/flushbar.dart';
import 'package:apikicker/Home/tweet_details.dart';
import 'package:apikicker/Home/tweet_form.dart';
import 'package:apikicker/Home/tweet_item.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:like_button/like_button.dart';
import 'dart:developer' as developer;

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {

  String debugTimelineData = "";
  List<dynamic> tweetContentslist = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _showTopFlushbar() {
      Flushbar(
        title : "ツイート投稿" ,
        message : "ツイートを投稿しました。" ,
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: Colors.blueAccent,
        margin: const EdgeInsets.all(8),
        borderRadius: BorderRadius.circular(8),
        duration:  const Duration(seconds: 3),
        isDismissible: true,
        icon: const Icon(
          Icons.info_outline,
          color: Colors.white,
        )
      ).show(context);
  }

  Future<void> _load() async{
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocTweetTestAllGet');
    final results = await callable();
    setState(() {
      debugTimelineData = results.data.toString();

      tweetContentslist = results.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: () async{
          await _load();
        },
        child : ListView.builder(
          itemCount: tweetContentslist.length,
          itemBuilder: ( BuildContext context , int index ){
            return Card(
              color: bgColor,
              child: TweetItem(
                tweetContentslist[index]['id'],
                "UserName",
                'images/mori.png',
                tweetContentslist[index]['contents']
              )
            );
          },
        ),
      ),
       // 投稿ボタン
      floatingActionButton : FloatingActionButton(
        child: Container(
          decoration: gradationBox,
          child: const Icon(Icons.edit),
          padding: const EdgeInsets.all(17.0),
        ),
        onPressed: () async {
          final results = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return TweetForm();
            }),
          );
          if (results != null) {
            _load();
            _showTopFlushbar();
          }
        },
      ),
    );
  }
}