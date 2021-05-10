// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/products_repository.dart';
import 'model/product.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget{
  HomePageSate createState()=> HomePageSate();
}



class HomePageSate extends State<HomePage>{
  // TODO: Add a variable for Category (104)

  List<Card> _buildGridCards(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (products == null || products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return snapshot.data.docs.map((DocumentSnapshot document){
      return Card(
        clipBehavior: Clip.antiAlias,
        // TODO: Adjust card heights (103)
        child: Column(
          // TODO: Center items on the card (103)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.network(
                document.data()['productImage'],
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  // TODO: Align labels to the bottom and center (103)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // TODO: Change innermost Column (103)
                  children: <Widget>[
                    // TODO: Handle overflowing labels (103)
                    Text(
                      document.data()['productName'],
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      document.data()['price'],
                      style: theme.textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 8),
              child: InkWell(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'more',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                onTap: (){

                },
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Return an AsymmetricView (104)
    // TODO: Pass Category variable to AsymmetricView (104)
//    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference products = FirebaseFirestore.instance.collection('products');

    return StreamBuilder<QuerySnapshot>(
      stream: products.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
            leading: IconButton(

              icon: Icon(
                Icons.person ,
                semanticLabel: 'profile',
              ),
              onPressed: () {
                print('Menu button');
              },
            ),
            title: Text('Main'),
            actions: <Widget>[

              IconButton(
                icon: Icon(
                  Icons.add,
                  semanticLabel: 'add',
                ),
                onPressed: () async {
//              await FirebaseAuth.instance.signOut().then((value) => Navigator.pushNamed(context, '/login'));
                  Navigator.pushNamed(context, '/add');
                },
              ),
            ],
          ),
          body: Center(
            child: GridView.count(
              crossAxisCount: 2,
              padding: EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              children: _buildGridCards(context,snapshot),
            ),
          ),
          resizeToAvoidBottomInset: false,
        );
      },
    );

//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.grey,
//        leading: IconButton(
//
//          icon: Icon(
//            Icons.person ,
//            semanticLabel: 'profile',
//          ),
//          onPressed: () {
//            print('Menu button');
//          },
//        ),
//        title: Text('Main'),
//        actions: <Widget>[
//
//          IconButton(
//            icon: Icon(
//              Icons.add,
//              semanticLabel: 'add',
//            ),
//            onPressed: () async {
////              await FirebaseAuth.instance.signOut().then((value) => Navigator.pushNamed(context, '/login'));
//              Navigator.pushNamed(context, '/add');
//            },
//          ),
//        ],
//      ),
//      body: Center(
//        child: GridView.count(
//          crossAxisCount: 2,
//          padding: EdgeInsets.all(16.0),
//          childAspectRatio: 8.0 / 9.0,
//          children: _buildGridCards(context),
//        ),
//      ),
//      resizeToAvoidBottomInset: false,
//    );
  }
}
