import 'package:Shrine/edit.dart';
import 'package:Shrine/model/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'app.dart';

class DetailPage extends StatefulWidget {
  final String productid;
  const DetailPage({Key key, this.productid}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState(productid);
}

class _DetailPageState extends State<DetailPage> {
  String productid;
  _DetailPageState(this.productid);
  CollectionReference products = FirebaseFirestore.instance.collection('products');
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<dynamic> asd;
  Future<void> deleteUser() {
    return products
        .doc(productid)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  void _showMessageSnackBar(String message){
    try {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(message),
            duration: Duration(seconds: 2, milliseconds: 500),
          )
      );
    } on Exception catch (e, s) {
      print(s);
    }
  }

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
        asd=snapshot.data['heartUIDs'];
        return MaterialApp(

          title: 'Flutter layout demo',
          home: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.grey,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              title: Text('Detail'),

              actions: <Widget>[

                IconButton(
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: () async {
                    if(snapshot.data['userId'] == FirebaseAuth.instance.currentUser.uid) {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditPage(productid: productid)));}
                  },
                ),

                IconButton(
                  icon: Icon(
                    Icons.delete,
                  ),
                  onPressed: ()  {
//                    products.doc(productid).delete().then((value) => Navigator.pushNamed(context, '/home'));
                    if(snapshot.data['userId'] == FirebaseAuth.instance.currentUser.uid) {
                      deleteUser().then((value) => Navigator.pushNamed(context, '/home'));}
                  },
                ),
              ],

            ),
            body: ListView(
              children: [
                Image.network(
                  snapshot.data['productImage'],
                  fit: BoxFit.fitWidth,
                  width: 600,
                  height: 240,
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(30, 30, 0, 20),
                    child: Column(
                      // TODO: Align labels to the bottom and center (103)
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // TODO: Change innermost Column (103)
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                            child: Text(
                              snapshot.data['productName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.black54
                              ),
                            ),
                          ),
                          Row(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(3, 5, 10.0, 0.0),
                              child: Container(
                                width: 260,
                                child: Text(
                                  "\$" + snapshot.data['price'].toString(),

                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontSize: 23),
                                ),
                              ),
                            ),
                            Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.thumb_up,
                                      color: Colors.red,
                                    ),
                                    onPressed: ()  {
                                      if(asd.contains(FirebaseAuth.instance.currentUser.uid)) {
                                        _showMessageSnackBar("You can only do it once!!");
                                      }else{
                                        asd.add(FirebaseAuth.instance.currentUser.uid);
                                        products.doc(productid).update({
                                          'heartNum': snapshot
                                              .data['heartNum'] + 1,
                                          "heartUIDs": FieldValue.arrayUnion(asd)
                                        }).then((value) =>
                                            _showMessageSnackBar("I LIKE IT!!XD"));
                                      }
                                    },

                                  ),
                                  Text(
                                    snapshot.data['heartNum'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.red
                                    ),
                                  ),


                                ]
                            ),

                          ]),


                        ]
                    )

                ),

                const Divider(
                  height: 1,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
                  child: Container(
                    width: 260,
                    child: Text(
                      snapshot.data['description'],
                      maxLines: 15,
                      style: TextStyle(
                          fontSize: 12),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 100, 30, 20),
                  child: Container(
                    width: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "creator: "+ snapshot.data['userId'],
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12),
                        ),
                        Text(
                          snapshot.data['CreatTime'].toDate().toString() + " Created",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12),
                        ),
                        Text(
                          snapshot.data['ModifiedTime'].toDate().toString() + " Modified",
                          style: TextStyle(
                            color: Colors.grey,
                              fontSize: 12),
                        ),
                      ],
                    )
                  ),
                ),
              ],
            ),
          ),
        );

        },
    );


  }
}


