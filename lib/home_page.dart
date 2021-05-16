import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/order_page.dart';
import './auth.dart';
import './root_page.dart';
import './bookmark_page.dart';
import './login_page.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;
  FirebaseAuth fauth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {

    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();


      } catch (e) {
        print(e);
      }

    }

    return new Scaffold(
        appBar: new AppBar(
          title: Text('Shopify Home'),
          actions: <Widget>[
            new FlatButton(
                onPressed: _signOut,
                child: new Text('Logout', style: new TextStyle(fontSize: 17.0, color: Colors.white))
            )
          ],
        ),
      body: Center(
        child: new Text(
          'List all products here',
          style: new TextStyle(fontSize: 22.0),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.home_rounded), onPressed: () {},),
            IconButton(icon: Icon(Icons.favorite_rounded), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BookmarkPage()),);},),
            IconButton(icon: Icon(Icons.shopping_cart_rounded), onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OrderPage()),);},),
          ],
        ),
      ),
    );
  }
}