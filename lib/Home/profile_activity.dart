import 'package:apikicker/main.dart';
import 'package:flutter/material.dart';
import 'package:apikicker/Common/color_settings.dart';
import 'package:apikicker/Common/flushbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apikicker/Home/tweet_item.dart';

class ProfileActivity extends ConsumerStatefulWidget {
  ProfileActivity(this.tweetContentslist, {Key? key}) : super(key: key);

  List<dynamic> tweetContentslist = [];

  @override
  _ProfileActivity createState() => _ProfileActivity();
}

class _ProfileActivity extends ConsumerState<ProfileActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: () async {},
        child: ListView.builder(
          itemCount: widget.tweetContentslist.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
                color: bgColor,
                child: TweetItem(
                  widget.tweetContentslist[index]['id'],
                  widget.tweetContentslist[index]['personId'],
                  'images/kkrn_icon_user_1.png',
                  widget.tweetContentslist[index]['contents'],
                  widget.tweetContentslist[index]['createdAt'],
                  widget.tweetContentslist[index]['username'],
                  widget.tweetContentslist[index]['photoUri'],
                ));
          },
        ),
      ),
    );
  }
}
