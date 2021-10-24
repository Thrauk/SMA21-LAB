import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:laborator_sma/lib/src/view_image.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppPage(),
    );
  }
}

class AppPage extends StatefulWidget {
  const AppPage({Key? key}) : super(key: key);

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();



  Future<String?> getClipBoardData() async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    return data!.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter app'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 7,
            child: WebView(
              initialUrl: 'https://www.google.ro/imghp?',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        String? url = await getClipBoardData();

                        if(url == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No url selected!')));
                        }
                        else {
                          var urlReq = Uri.parse(url);
                          var request = http.Request('GET',urlReq)..followRedirects = false;
                          var response = await http.Client().send(request);
                          String? nextUrl = response.headers['location'];
                          String? imageUrl;
                          if(nextUrl != null) {
                            int startIndex = nextUrl.indexOf('imgurl=');
                            int startSkip = 7;
                            int endIndex = nextUrl.indexOf('&imgrefurl');
                            imageUrl = nextUrl.substring(startIndex + startSkip, endIndex);
                            final ByteData imageData = await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
                            final Uint8List bytes = imageData.buffer.asUint8List();
                            //Image image = Image.network(url);
                            Image image = Image.memory(bytes);
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewImage(image: image)));
                          }


                        }
                      },
                      child: const Text('Load image with\nbackground service'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, double.infinity),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Downloading image')));
                        String? url = await getClipBoardData();

                        if(url == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No url selected!')));
                        }
                        else {
                          var urlReq = Uri.parse(url);
                          var request = http.Request('GET',urlReq)..followRedirects = false;
                          var response = await http.Client().send(request);
                          String? nextUrl = response.headers['location'];
                          String? imageUrl;
                          if(nextUrl != null) {
                            int startIndex = nextUrl.indexOf('imgurl=');
                            int startSkip = 7;
                            int endIndex = nextUrl.indexOf('&imgrefurl');
                            imageUrl = nextUrl.substring(startIndex + startSkip, endIndex);
                            final ByteData imageData = await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
                            final Uint8List bytes = imageData.buffer.asUint8List();
                            Image image = Image.memory(bytes);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewImage(image: image)));
                          }


                        }

                      },
                      child: const Text('Load image with\nforeground service'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, double.infinity),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
