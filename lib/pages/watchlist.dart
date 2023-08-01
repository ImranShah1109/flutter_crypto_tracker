import 'dart:convert';
import 'package:crypto_tracker/common/coin_card.dart';
import 'package:crypto_tracker/functions/get_watchlist.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Watchlist extends StatefulWidget {
  const Watchlist({ Key? key }) : super(key: key);

  @override
  _WatchlistState createState() => _WatchlistState();

  // for get data from child
  static _WatchlistState? of(BuildContext context) =>
    context.findAncestorStateOfType<_WatchlistState>();
}

class _WatchlistState extends State<Watchlist> {

  bool _isLoading = true;
  var _watchlistCoins = [];
  var _watchlist = [];

  // setter for watchlist which will get from child
  set watchlist(value) {
    setState(() {
      _watchlist = value;
    });
    getData();
  }

  Future getCoinData() async{
    
    try
    {
      final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en'));

      // print('response :- ${response.statusCode}');

      if(response.statusCode == 200){
        var data = response.body;
        return jsonDecode(data);
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


  void getData()async{
    var coins = await getCoinData();
    // var watchlist =await getWatchlist();
    // print(_watchlist.runtimeType);
    if(coins.runtimeType != Null){
      if(coins?.isNotEmpty){
        setState(() {
          _watchlistCoins = coins.where((coin) =>  _watchlist.contains(coin['id'])).toList();
          _isLoading = false;
        });
      }
    }
  }


  @override
  void initState() {
    super.initState();
    getWatchlist().then((value) {
      setState(() {
        _watchlist = value;
      });
    },);
    getData();
  }


  @override
  Widget build(BuildContext context) {
    // print('watchlist render');
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
        ),
      body:
        _isLoading ?
        const Center(
        child: CircularProgressIndicator() )
        : 
        _watchlist.isEmpty ? 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const Text('No Items in watchlist',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600),),
                  ElevatedButton(onPressed: (() {
                    Navigator.pop(context);
                  }), child: const Text('Go Back'))
                ],
            ),
          ],
        )
        :
        ListView.builder(
          itemBuilder: (BuildContext context, int index) { 
            return CoinCard(coinData: _watchlistCoins,index: index);
          },
          itemCount: _watchlistCoins.length,
        )
    );
  }
}