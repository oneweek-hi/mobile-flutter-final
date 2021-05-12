import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class EditPage extends StatefulWidget {
  final String productid;
  const EditPage({Key key, this.productid}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState(productid);
}

class _EditPageState extends State<EditPage> {

  String productid;
  _EditPageState(this.productid);

  TextEditingController _productNameController;
  TextEditingController _priceController;
  TextEditingController _descriptionController;

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

    CollectionReference products = FirebaseFirestore.instance.collection('products');

    return StreamBuilder(
      stream: products.doc(productid).snapshots(),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        }
        _productNameController = TextEditingController(text:snapshot.data['productName'] );
        _priceController = TextEditingController(text: snapshot.data['price'].toString());
        _descriptionController = TextEditingController(text: snapshot.data['description']);

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

              title: Text('Edit'),

              actions: <Widget>[


                Padding(
                  padding: EdgeInsets.all(1.0),
                  child: TextButton(
                    child: Text('Save'),
                    onPressed: () {

                      if(snapshot.data['userId'] == FirebaseAuth.instance.currentUser.uid) {

                        if(_image == null){
                          print("here");
                          products.doc(productid).update({'productName':_productNameController.text,
                            'price':int.parse(_priceController.text),
                            'description':_descriptionController.text,
                            'ModifiedTime':timeNow,
                          }).then((value) => Navigator.pushNamed(context, '/home'));

                        }
                        else{
                          print("here222");
                          uploadFile().then((value) => downloadURLExample().then((value) =>
                              products.doc(productid).update({'productName':_productNameController.text,
                                'price':int.parse(_priceController.text),
                                'description':_descriptionController.text,
                                'productImage': downloadURL,
                                'ModifiedTime':timeNow,
                              })
                                  .then((value) => Navigator.pushNamed(context, '/home'))));
                        }


                      }

                    },
                  ),
                ),
              ],
            ),
            body: ListView(
              children: [
                Container (
                  child: Column(
                      children: <Widget>[

                        _image == null ? Image.network( snapshot.data['productImage'],
                          fit: BoxFit.fitWidth,
                          width: 600,
                          height: 240,
                        ) : Image.file(_image,
                          fit: BoxFit.fitWidth,
                          width: 600,
                          height: 240,),

                      ]
                  ),
                ),

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
                Container(
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
//                                    labelText: 'productName',
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
//                                    labelText: 'Price',
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

                ),
              ],
            ),
          ),
        );

      },
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
