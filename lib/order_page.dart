import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './auth.dart';
import './home_page.dart';
import './bookmark_page.dart';
import './login_page.dart';
import './root_page.dart';

class OrderPage extends StatelessWidget {
  OrderPage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  FirebaseAuth fauth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    void _signOut() async {
      try {

        await auth.signOut();
        onSignOut();
        runApp(
            new MaterialApp(
              home: new RootPage(),
            )

        );
        // onSig


            } catch (e) {
        print(e);
      }

    }

    return new Scaffold(
        appBar: new AppBar(
          title: Text('Shopify Orders'),
          actions: <Widget>[
            new FlatButton(
                onPressed: _signOut,
                child: new Text('Logout', style: new TextStyle(fontSize: 17.0, color: Colors.white))
            )
          ],
        ),
      body: Center(
        child: new Text(
          'List ordered products here',
          style: new TextStyle(fontSize: 22.0),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home_rounded), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()),);},),
            IconButton(icon: Icon(Icons.favorite_rounded), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BookmarkPage()),);},),
            IconButton(icon: Icon(Icons.shopping_cart_rounded), onPressed: () {},),
          ],
        ),
      ),
    );
  }
}