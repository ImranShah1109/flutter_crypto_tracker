import 'package:shared_preferences/shared_preferences.dart';


Future<String?> getcurrentUser() async{
    var prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('currentUser');
    // print('getcurrentUser --> $user');
    return user;
}