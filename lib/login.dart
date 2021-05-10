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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _initialized = false;
  bool _error = false;
//
//  // Define an async function to initialize FlutterFire
//  void initializeFlutterFire() async {
//    try {
//      // Wait for Firebase to initialize and set `_initialized` state to true
//      await Firebase.initializeApp();
//      setState(() {
//        _initialized = true;
//      });
//    } catch(e) {
//      // Set `_error` state to true if Firebase initialization fails
//      setState(() {
//        _error = true;
//      });
//    }
//  }
//
//  @override
//  void initState() {
//    initializeFlutterFire();
//    super.initState();
//  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithAnonymous() async {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                SizedBox(height: 16.0),
                Text('Final-mobileApp'),
              ],
            ),
            SizedBox(height: 120.0),

            SizedBox(height: 12.0),
            // TODO: Wrap Password with AccentColorOverride (103)


            ElevatedButton(
              child: Text('Google'),
              onPressed: () {
                signInWithGoogle().then((value) => Navigator.pop(context));
              },
            ),

            ElevatedButton(
              child: Text('Guest'),
              onPressed: () async {
                signInWithAnonymous().then((value) => Navigator.pop(context));
              },
            ),

          ],
        ),
      ),
    );
  }
}



// TODO: Add AccentColorOverride (103)
