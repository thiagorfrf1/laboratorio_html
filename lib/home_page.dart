import 'dart:convert';
import 'dart:io';

import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:laboratorio_html/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:laboratorio_html/abrir.dart';
import 'package:laboratorio_html/drawer_list.dart';
import 'package:laboratorio_html/utils/nav.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class HomePage extends StatelessWidget {
  // Índice do indicator
  var _currentIndex = 0;
  final htmlController = TextEditingController();
  AssetBundle assetBundle;
  int cont = 0;
  LoadHTMLFileToWEbView loadHTMLFileToWEbView = new LoadHTMLFileToWEbView();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Laboratorio HTML"),
          bottom: TabBar(tabs: [
            Tab(
              text: "HTML e CSS",

            ),
            Tab(
              text: "SITE",

            ),
          ]),
        ),
        body: TabBarView(
            children: [
          _bodyHTML(context),
          Container(

           child: webView(context),

          )
        ]),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.file_upload),
          onPressed: () {
            cont++;
            print(htmlController.text+ " HTML");
            print('Leitura do View');
            writeCounter(htmlController.text);
          },
        ),
        drawer: DrawerList(),
      ),
    );
  }


  _body(context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _text(),
        ],
      ),
    );
  }
  _bodyHTML(context) {
    return Container(
      padding: EdgeInsets.only(top: 16, left: 16, right: 0 ),
      height: 300,
      color: Colors.white,
      child: _textFieldHTML(),
    );
  }

  void _onClickNavigator(BuildContext context, Widget page) async {
    String s = await push(context, page);

    print(">> $s");
  }

  _onClickSnack(context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Olá Flutter"),
        action: SnackBarAction(
          textColor: Colors.yellow,
          label: "OK",
          onPressed: () {
            print("OK!");
          },
        ),
      ),
    );
  }

  _onClickDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text("Flutter é muito legal"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                  print("OK !!!");
                },
              )
            ],
          ),
        );
      },
    );
  }

  _img(String img) {
    return Image.asset(
      img,
      fit: BoxFit.cover,
    );
  }

  _text() {
    return Text(
      "Hello World",
      style: TextStyle(
          color: Colors.blue,
          fontSize: 30,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
          decorationColor: Colors.red,
          decorationStyle: TextDecorationStyle.wavy),
    );
  }


  _textFieldHTML() {
    return TextField(
      controller: htmlController,
      style: _estilo(),
      showCursor: true,
      maxLengthEnforced: true,
      minLines: 300,
      maxLines: 501,
    );
  }

  webView(context) {
    WebViewController _controller;
    return WebView(
      initialUrl: '',
      onWebViewCreated: (WebViewController webViewController) async {
        _controller = webViewController;
        //_controller.clearCache();
        final path = await _localPath;
        final file = File('$path/index.html');
        print(file.path);
        String fileText ;
        _controller.loadUrl('file:///'+file.path);
      },
    );
  }


   writeCounter(String string) async {
     print('writeCounter 222');
     //read and write
     var bytes = await rootBundle.load("assets/index.html");
     String dir = (await getApplicationDocumentsDirectory()).path;
     _write(string);
    //write to app path

  }


  _write(String text) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = await _localPath;
    final file = File('$path/index.html');
    await file.writeAsString(text);
    print('Salvou HTML');
  }




  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

_estilo() {
  return TextStyle(
      color: Colors.black,
      fontSize: 18,
      //fontWeight: FontWeight.bold,
      //fontStyle: FontStyle.italic,
      //decoration: TextDecoration.underline,
      decorationColor: Colors.red,
      decorationStyle: TextDecorationStyle.wavy)
  ;
}


}
