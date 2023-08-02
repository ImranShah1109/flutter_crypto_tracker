import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class Coin extends StatefulWidget {
  const Coin({ Key? key, required this.id }) : super(key: key);
  final id;

  @override
  _CoinState createState() => _CoinState();
}

class _CoinState extends State<Coin> {

  var coinInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getCoinInfo();
  }
  
  void getCoinInfo() async{

    var id = widget.id;

    try{
      final response = await http.get(Uri.parse('https://api.coingecko.com/api/v3/coins/${id}'));
      
      if(response.statusCode == 200){
        var data = response.body;
        // print('data $data');
        if(mounted){
          setState(() {
            coinInfo = jsonDecode(data);
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

  @override
  Widget build(BuildContext context) {
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
        child: CircularProgressIndicator()
      )
      :
      Stack(
        children: [
          Positioned(
            top: 15,
            left: 15,
            child: Container(
                  width: MediaQuery.of(context).size.width - 30,
                  padding: const EdgeInsets.only(left:10,top: 5,bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                        '${coinInfo['name']}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      )
                )
          ),
          Container(
              width: MediaQuery.of(context).size.width - 30,
              margin: const EdgeInsets.only(top: 60,left: 15),
              padding: const EdgeInsets.only(left: 10,top: 5,bottom: 5,right: 5),
              decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(coinInfo['description']['en']),
                  ],
                ),
              ),
          ),
        ],
      )
      
    );
  }
}
