import 'dart:convert';
import 'package:crypto_tracker/functions/getcurrent_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void addToWatchlist(String id) async{
  var watchlist;
  var prefs = await SharedPreferences.getInstance();
  var user = await getcurrentUser();
  if(prefs.getString(user!) != null){
    watchlist =jsonDecode(prefs.getString(user)!);
    if(!watchlist.contains(id)){
      watchlist.add(id);
      prefs.setString(user, jsonEncode(watchlist));
    }
  }
  else{
    watchlist = [id];
    prefs.setString(user, jsonEncode(watchlist));
  }
}