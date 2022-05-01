import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
// import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  var url = Uri.parse(
      'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=deff6786ae444e6385e58729784e6897');
  // ignore: non_constant_identifier_names
  List PostData = [];

  @override
  // ignore: must_call_super
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('News App'),
        ),
        body: RefreshIndicator(
          child: ListView.builder(
            // ignore: unnecessary_null_comparison
              itemCount: PostData == null ? 0 : PostData.length,
              itemBuilder: (BuildContext context, i) {
                return Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Card(
                      elevation: 7.0,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      PostData[i]["title"],
                                      style: const TextStyle(fontSize: 17.0),
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(PostData[i]["description"]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ImageNetwork(
                              image: PostData[i]["urlToImage"],
                              // imageCache: CachedNetworkImageProvider(
                              //     PostData[i]["urlToImage"]),
                              height: 350,
                              width: 450,
                              duration: 1500,
                              curve: Curves.easeIn,
                              onPointer: true,
                              fitAndroidIos: BoxFit.cover,
                              fitWeb: BoxFitWeb.cover,
                              borderRadius: BorderRadius.circular(30),
                              onLoading: const CircularProgressIndicator(
                                color: Colors.indigoAccent,
                              ),
                              onError: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                child: TextButton(
                                    child: const Text('Read More'),
                                    onPressed: () {
                                      showData(PostData[i]);
                                    }),
                                padding: const EdgeInsets.only(
                                    right: 25.0, bottom: 15.0),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ]);
              }),
          onRefresh: getData,
        ));
  }

  Future getData() async {
    var resp = await http.get(url, headers: {'Accept': 'application/json'});
    var extracteddata = json.decode(resp.body);
    setState(() {
      PostData = extracteddata["articles"];
      //print('Refresh Complete');
    });
    return null;
  }

  Future showData(singlePost) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(
            singlePost["title"],
            style: const TextStyle(fontSize: 17.0),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(singlePost["description"]),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('Source:  ' + singlePost["author"]),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('Date Posted:  ' + singlePost["publishedAt"]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SimpleDialogOption(
                  child: const Text(
                    'Go back',
                    style: TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
