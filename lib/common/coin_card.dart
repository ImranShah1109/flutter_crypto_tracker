// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:crypto_tracker/common/toast.dart';
import 'package:crypto_tracker/functions/get_watchlist.dart';
import 'package:crypto_tracker/pages/coin.dart';
import 'package:crypto_tracker/pages/watchlist.dart';
import 'package:crypto_tracker/themes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../functions/hasbeen_added.dart';
import '../functions/add_to_watchlist.dart';
import '../functions/remove_from_watchlist.dart';

class CoinCard extends StatefulWidget {
  const CoinCard({ Key? key, this.coinData, this.index,}) : super(key: key);
  final coinData;
  final index;

  @override
  _CoinCardState createState() => _CoinCardState();
  
}

class _CoinCardState extends State<CoinCard> {
  bool isAdded = false;
  var formatter = NumberFormat('#,###,000');

  @override
  Widget build(BuildContext context) {
    hasbeenAdded(widget.coinData[widget.index]['id']).then((value){
      // print(widget.coinData[widget.index]['id'] + ' ' +value);
      if(mounted){
        setState(() {
          isAdded = value;
        });
      }
    });
    
    // print(isAdded);

    return 
    InkWell
    (
      key: UniqueKey(),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Coin(id: widget.coinData[widget.index]['id']),));
      },
      child: UnconstrainedBox(
        child: Container(
          height: 300,
          width: 300,
          margin: const EdgeInsets.only(top:10,left: 20,right: 20),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(10),
            boxShadow:  [
              BoxShadow
              (
                color: ThemeClass.darkgrey,
                blurRadius: 15,
                blurStyle: BlurStyle.outer,
                offset: const Offset(
                  10, 10)
              ),
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.network(widget.coinData[widget.index]['image'],width: 50,height: 50,),
                      Container(
                        margin: const EdgeInsets.only(left: 20,top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.coinData[widget.index]['symbol']
                                  .toString()
                                  .toUpperCase(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                            ),
                            Text(widget.coinData[widget.index]['name'],style: TextStyle(color: ThemeClass.grey),),
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                              InkWell(
                                onTap: () async{
                                  final toast;
                                  if(isAdded){
                                    removeFromWatchlist(widget.coinData[widget.index]['id']);
                                    toast = Toast(
                                              message:'${widget.coinData[widget.index]['name']} is remove from watchlist',
                                              duration: 3,
                                            ).ToastBar();
                                  }
                                  else{
                                    addToWatchlist(widget.coinData[widget.index]['id']);
                                    toast = Toast(
                                              message:'${widget.coinData[widget.index]['name']} is added in watchlist',
                                              duration: 3,
                                            ).ToastBar();
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(toast);
                                  Watchlist.of(context)?.watchlist = await getWatchlist();
                                },
                                child:isAdded ? 
                                  Icon(
                                    Icons.star_rate_rounded,
                                    size: 40,
                                    color: widget.coinData[widget.index]['price_change_percentage_24h'] < 0 ? ThemeClass.red : ThemeClass.green,
                                  )
                                  : 
                                  Icon(
                                    Icons.star_border_rounded,
                                    size: 40,
                                    color: widget.coinData[widget.index]['price_change_percentage_24h'] < 0 ? ThemeClass.red : ThemeClass.green,
                                  ),
                              )
                            ],
                  ),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(top: 5,left: 30),
                    width: 125,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:widget.coinData[widget.index]['price_change_percentage_24h'] < 0 ? ThemeClass.red : ThemeClass.green,
                        width: 2,
                        style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(
                            '${double.parse(widget.coinData[widget.index]
                                        ['price_change_percentage_24h']
                                    .toString())
                                .toStringAsFixed(2)}%',
                            style: TextStyle(
                                  fontSize: 18,
                                  color: widget.coinData[widget.index]
                                              ['price_change_percentage_24h'] <
                                          0
                                      ? ThemeClass.red
                                      : ThemeClass.green,
                                ),
                          )
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:widget.coinData[widget.index]['price_change_percentage_24h'] < 0 ? ThemeClass.red : ThemeClass.green,
                        width: 2,
                        style: BorderStyle.solid
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: 
                      widget.coinData[widget.index]['price_change_percentage_24h'] < 0 ?
                      Icon(
                        Icons.trending_down_rounded,
                        color: ThemeClass.red,
                      )
                      :
                      Icon(
                        Icons.trending_up_rounded,
                        color: ThemeClass.green,
                      )
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                child: Text(
                  '\$${formatter.format(widget.coinData[widget.index]['current_price'])}',
                  style: TextStyle(
                    color: widget.coinData[widget.index]['price_change_percentage_24h'] < 0 ? ThemeClass.red : ThemeClass.green,
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  'Total Volume ${formatter.format(widget.coinData[widget.index]['total_volume'])}',
                  style: TextStyle(
                    color: ThemeClass.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                )
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  'Market Cap \$${formatter.format(widget.coinData[widget.index]['market_cap'])}',
                  style: TextStyle(
                    color: ThemeClass.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}