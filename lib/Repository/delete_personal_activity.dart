import 'package:cloud_functions/cloud_functions.dart';

void deletePersonalActivity(personalActivityId) async {
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('pocDeletePersonalActivity');
  final results = await callable(personalActivityId);
}
