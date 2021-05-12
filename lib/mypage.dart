import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class MypPage extends StatefulWidget {

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MypPage> {

  File _image;
  final picker = ImagePicker();
  String timeNow = DateFormat('yy.MM.dd kk:mm:ss').format(DateTime.now());



  @override
  Widget build(BuildContext context) {

    Widget InfoSection = Container(
      child: Padding(
        padding:EdgeInsets.fromLTRB(40, 10, 40, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:EdgeInsets.fromLTRB(3, 5, 10.0, 10),
                child: Text(
                  FirebaseAuth.instance.currentUser.uid,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

              ),
              const Divider(
                  height: 10,
                  color: Colors.black
              ),
              Padding(
                padding:EdgeInsets.fromLTRB(3, 10, 10.0, 0.0),
                child: FirebaseAuth.instance.currentUser.isAnonymous == true ?
                Text(
                  'Anonymous',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
//                fontSize: 12,
                  ),
                ): Text(
                  FirebaseAuth.instance.currentUser.email,
                  style: TextStyle(
//                color: Colors.blue,
                    fontWeight: FontWeight.bold,
//                fontSize: 12,
                  ),
                ),
              )

            ]
        ),
      )


    );



    Widget ImageSection = Container (
      child: Column(
          children: <Widget>[
            FirebaseAuth.instance.currentUser.isAnonymous == true ?
            Image.network( "https://handong.edu/site/handong/res/img/logo.png",
              width: 600,
              height: 240,
            ) : Image.network(
              FirebaseAuth.instance.currentUser.photoURL,
              width: 600,
              height: 240,
            )
          ]
      ),
    );


    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: Padding(
            padding: EdgeInsets.all(1.0),
            child:IconButton(
              icon: Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          title: Text('Profile'),

          actions: <Widget>[

            Padding(
              padding: EdgeInsets.all(1.0),
              child: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) => Navigator.pushNamed(context, '/login'));
                },
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            ImageSection,
            InfoSection,
          ],
        ),
      ),
    );
  }

}