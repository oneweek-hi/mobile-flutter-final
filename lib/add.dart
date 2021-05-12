import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class AddPage extends StatefulWidget {

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _productNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String downloadURL = "";
  String reference ="";

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File _image;
  final picker = ImagePicker();
  String timeNow = DateFormat('yy.MM.dd kk:mm:ss').format(DateTime.now());



  @override
  Widget build(BuildContext context) {

    Widget InfoSection = Container(
        padding: const EdgeInsets.fromLTRB(30, 10, 0, 20),
        child: Form(
            key: _formKey,
            child: Column(
              // TODO: Align labels to the bottom and center (103)
                crossAxisAlignment: CrossAxisAlignment.start,
                // TODO: Change innermost Column (103)
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0),
                    child:TextFormField(
                      controller: _productNameController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Product Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '111';
                        }
                        return null;
                      },

                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 5.0),
                    child:TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Price',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '2222';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 5.0),
                    child:TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '333';
                        }
                        return null;
                      },
                    ),
                  ),

                ]
            )
        )

    );



    Widget ImageSection = Container (
      child: Column(
        children: <Widget>[

          _image == null ? Image.network( "https://handong.edu/site/handong/res/img/logo.png",
            width: 600,
            height: 240,
          ) : Image.file(_image,
            fit: BoxFit.fitWidth,
            width: 600,
            height: 240,),

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
            child: TextButton(
            child: Text('Cancel'

            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          ),

          title: Text('Add'),

          actions: <Widget>[


            Padding(
              padding: EdgeInsets.all(1.0),
              child: TextButton(
                child: Text('Save'),
                onPressed: () {
                  if (_formKey.currentState.validate()){
                    uploadFile().then((value) => downloadURLExample().then((value) =>
                        FirebaseFirestore.instance.collection("products").add({
                      'productName':_productNameController.text,
                      'price':int.parse(_priceController.text),
                      'description':_descriptionController.text,
                      'userId': FirebaseAuth.instance.currentUser.uid,
                      'heartNum':0,
                      'CreatTime':FieldValue.serverTimestamp(),
                      'ModifiedTime':FieldValue.serverTimestamp(),
                      'productImage': downloadURL,
                      'heartUIDs': [],
                    })
                    ));
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            ImageSection,
            IconButton(
              alignment: Alignment(0.87, 0),
              icon: Icon(
                Icons.camera_alt,
                semanticLabel: 'add',
              ),
              onPressed: (){
                getImage();
              },
            ),
            InfoSection,
          ],
        ),
      ),
    );
  }

  Future<void> uploadFile() async {
    reference = "productImage/"+timeNow+".png";
    await firebase_storage.FirebaseStorage.instance
        .ref(reference)
        .putFile(_image);

  }

  Future<void> downloadURLExample() async {
     downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref(reference)
        .getDownloadURL();

    // Within your widgets:
    // Image.network(downloadURL);
  }


  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


}
