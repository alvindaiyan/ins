import 'package:flutter/material.dart';
// import 'package:english_words/english_words.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

void main() => runApp(MyApp());

Future<YesOrNoGet> fetchGet() async {
    final _url = "https://yesno.wtf/api";
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return YesOrNoGet.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智障小助手',
      home: Scaffold(
        body: Center(
          child: YesNoGifs(),
        )
      ),
    );
  }
}

class YesNoGifsState extends State<YesNoGifs> {

  var data;
  // var post ;
  @override
  void initState() {
    fetchGet().then((d) {
      // data = d;
      setState(() {
        data = d;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return data == null ? new CircularProgressIndicator() : SmartRefresher(
      enablePullDown: true,
      // enablePullUp: true,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      header: WaterDropHeader(),
      child: Stack(
              children: <Widget>[
                  Image.network(
                    data.url + '?raw=true',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                  ),
                  Center(child: Text(
                    data.answer,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 100
                    ),
                  )),
              ]
            )
    );
  }
  // Future<Null> _refresh() {

  // }

  RefreshController _refreshController = RefreshController(initialRefresh: true);
  void _onRefresh() async{
      // setState(() => post = fetchGet());
      setState(() {
        fetchGet().then((d) => data = d);
      });
      // // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }

  void _onLoading() async{
      // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // items.add((items.length+1).toString());
    if(mounted)
      // setState(() => post = fetchGet());

    _refreshController.loadComplete();
  }

   // don't forget to dispose refreshController
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

class YesNoGifs extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    print('hello widget');
    return new YesNoGifsState();
  }
}

class YesOrNoGet {
  final String answer;
  final bool forced;
  final String url;

  YesOrNoGet({this.answer, this.forced, this.url});

  factory YesOrNoGet.fromJson(Map<String, dynamic> json) {
    return YesOrNoGet(
      answer: json['answer'],
      forced: json['forced'],
      url: json['image'],
    );
  }
}
