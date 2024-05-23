import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:video_conference_with_web_rtc/utils/pref_keys.dart';

var uuid = Uuid();

Future<String> loadUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  var userId;
  if (preferences.containsKey(PrefKeys.userId)) {
    userId = await preferences.getString(PrefKeys.userId);
  } else {
    userId = uuid.v4();
    await preferences.setString(PrefKeys.userId, userId);
  }
  return userId;
}
