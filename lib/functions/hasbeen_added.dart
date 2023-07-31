import 'dart:convert';
import 'package:crypto_tracker/functions/getcurrent_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> hasbeenAdded(String id) async{

    var prefs = await SharedPreferences.getInstance();
    bool flag = false;
    var user = await getcurrentUser();
    if(prefs.getString(user!) != null){
      var watchlist = jsonDecode(prefs.getString(user)!);
      if(watchlist.contains(id)){
        // print('watchlist $id is ${watchlist.contains(id)}');
        flag = true;
      }
    }
    return flag;
    
}