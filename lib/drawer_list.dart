import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:laboratorio_html/firebase_service.dart';
import 'package:laboratorio_html/api_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:laboratorio_html/home_page.dart';
import 'package:laboratorio_html/usuario.dart';
import 'package:laboratorio_html/utils/nav.dart';
import 'package:path_provider/path_provider.dart';

import 'utils/alert.dart';

class DrawerList extends StatelessWidget {
  static String path ="0";
  static String file;
  static var emailController = TextEditingController();
  static var htmlController = TextEditingController();
  UserAccountsDrawerHeader _header(FirebaseUser user) {
    return UserAccountsDrawerHeader(
      accountName: Text(user.displayName ?? ""),
      accountEmail: Text(user.email),
      currentAccountPicture: user.photoUrl != null
          ? CircleAvatar(
        backgroundImage: NetworkImage(user.photoUrl),
      )
          : FlutterLogo(),
    );
  }

  @override
  Widget build(BuildContext context){
  Future<FirebaseUser> future = FirebaseAuth.instance.currentUser();

    return SafeArea(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            FutureBuilder<FirebaseUser>(
              future: future,
              builder: (context, snapshot) {
                FirebaseUser user = snapshot.data;

                return user != null ? _header(user) : Container();
              },
            ),


            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                print("Item 1");
                Navigator.pop(context);
                _onClickLogout(context);
              },
            ),
            Container(
              height: 46,
              margin: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: GoogleSignInButton(
                onPressed: _onClickGoogle,

              ),


            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text("Enviar mensagem por E-mail"),
              trailing: Icon(Icons.email),
              onTap: () {
                Navigator.pop(context);
                _onClickSendEmail(context);
              },
            ),
          ],
        ),

      ),
    );
  }

  _onClickGoogle() async {
    print('teste');
    final service = FirebaseService();
    ApiResponse response = await service.loginGoogle();
    BuildContext context;
    if (response.ok) {
      //alert(context, response.msg);
    } else {
      alert(context, response.msg);
    }
  }

  _onClickLogout(BuildContext context) {
    Usuario.clear();
    FirebaseService().logout();
    //Navigator.pop(context);
    //HomePage hp;
   //push(context, hp);
  }
_onClickSendEmail(BuildContext context) async {
    path = await _localPath;
    //print('Aqui entrou');
    //file = '$path/index.html';
    await FlutterEmailSender.send(email);
  }

  final Email email = Email(
    body: htmlController.text,
    subject: 'Codigo HTML Gerado no aplicativo Laboratório HTML',
    recipients: [emailController.text],
    //attachmentPath: '/data/user/0/com.ppgia.laboratorio_html/cache/index.html',

    isHTML: false,
  );

  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();

    print('localpath');
    //final directory = await getApplicationDocumentsDirectory();
    print(directory.path);
    return directory.path;
  }

}
