import 'dart:convert';
import 'package:crypto_tracker/functions/getcurrent_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void removeFromWatchlist(String id) async{
  var prefs = await SharedPreferences.getInstance();
  var user = await getcurrentUser();
  if(prefs.getString(user!) != null){
    var watchlist = jsonDecode(prefs.getString(user)!);
    watchlist!.removeWhere((e) => e==id);
    prefs.setString(user, jsonEncode(watchlist));
  }
}