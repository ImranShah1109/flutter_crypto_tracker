import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'getcurrent_user.dart';



Future<List> getWatchlist()async{
  var prefs = await SharedPreferences.getInstance();
  var user = await getcurrentUser();
  var watchlist = [];
  if(prefs.getString(user!) != null){
    watchlist = jsonDecode(prefs.getString(user)!);
  }

  return watchlist;
}