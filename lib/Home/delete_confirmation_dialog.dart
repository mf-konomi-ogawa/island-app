import 'package:apikicker/Common/color_settings.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DeleteConfirmDialog extends StatelessWidget {
  DeleteConfirmDialog(documentId, {Key? key}) : super(key: key);

  String documentId = "";
  
  @override
  Widget build(BuildContext context) {
    BuildContext innerContext;
    innerContext = context;
    return AlertDialog(
      backgroundColor: bgColor,
      title: const Text('ツイートを削除しますか？'),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),
      titlePadding: const EdgeInsets.all(10),
      actions: [
        Center(
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                ),
                child: const Text('OK'),
                onPressed: () {
                  _deletePersonalActivity(documentId);
                  Navigator.pop(innerContext);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor2,
                ),
                child: const Text('キャンセル'),
                onPressed: () {
                  Navigator.pop(innerContext);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _deletePersonalActivity(personalActivityId) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocDeletePersonalActivity');
    final results = await callable(personalActivityId);
  }
}