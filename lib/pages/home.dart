// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:crypto_tracker/common/coin_card.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
                title:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Crypto', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      Text(
                      'Tracker',
                      style: TextStyle(
                        fontFamily: 'Lumano',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(58, 128, 233, 1),
                      ),
                    )
                    ],
                  ),
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                centerTitle: true,
                actions:[
                  PopupMenuButton(
                    itemBuilder: (context){
                      return [
                        PopupMenuItem(
                          value: 0,
                          child: Text('Action 1')
                        )
                      ];
                    })
                ],
              ),
      drawer: const Drawer(
        elevation: 20,
        child: Text('Drawer 1'),
        width: 250,
      ),
      body: const HomePage()
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

  bool check(){
    return true;
  }
}

class _HomePageState extends State<HomePage> {

  String _user ='';

  var _coinData = [];

  bool _isLoading = true;

  var _error;

  var x = HomePage().check();

  @override
  void initState() {
    super.initState();
    getcurrentUser();
    getCoinData();
  }

  void getcurrentUser() async{
    var prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('currentUser');
    setState(() {
      _user = user!;
    });
  }

  void getCoinData() async{
    
    try
    {
      final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en'));

      // print('response :- ${response.statusCode}');

      if(response.statusCode == 200){
        var data = response.body;
        if(mounted){
          setState(() {
            _coinData = jsonDecode(data);
            _isLoading = false;
          });
          // print('1st Coin --> ${_coinData[0]}');
        }
      }
    }
    catch(e){
      print('error --> $e');
      if(mounted){
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> hasbeenAdded(String id) async{

    var prefs = await SharedPreferences.getInstance();
    bool flag = false;
    if(prefs.getString(_user) != null){
      var watchlist = jsonDecode(prefs.getString(_user)!);
      if(watchlist.contains(id)){
        // print('watchlist $id is ${watchlist.contains(id)}');
        flag = true;
      }
    }
    return flag;
    
  }

  void addToWatchlist(String id) async{
    var watchlist;
    var prefs = await SharedPreferences.getInstance();
    if(prefs.getString(_user) != null){
      watchlist =jsonDecode(prefs.getString(_user)!);
      if(!watchlist.contains(id)){
        watchlist.add(id);
        prefs.setString(_user, jsonEncode(watchlist));
      }
    }
    else{
      watchlist = [id];
      prefs.setString(_user, jsonEncode(watchlist));
    }
  }

  void removeFromWatchlist(String id) async{
    var prefs = await SharedPreferences.getInstance();
    if(prefs.getString(_user) != null){
      var watchlist = jsonDecode(prefs.getString(_user)!);
      watchlist!.removeWhere((e) => e==id);
      prefs.setString(_user, jsonEncode(watchlist));
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(x);
    return 
      _isLoading ?
      const Center(
      child: CircularProgressIndicator() )
      : 
      ListView.builder(
        
        itemBuilder: (context, index) {
          return 
            CoinCard(
              addToWatchlist: addToWatchlist,
              removeFromWatchlist: removeFromWatchlist,
              coinData: _coinData,
              index: index,
              hasbeenAdded: hasbeenAdded,
            );
        },
        itemCount: _coinData.length,
      );
  }
}