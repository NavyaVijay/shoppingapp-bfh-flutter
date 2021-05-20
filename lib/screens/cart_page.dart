import 'package:shoppingapp/screens/product_page.dart';
import 'package:shoppingapp/screens/order_page.dart';
import 'package:shoppingapp/services/firebase_services.dart';
import 'package:shoppingapp/widgets/custom_action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var _total=0;
  FirebaseServices _firebaseServices = FirebaseServices();

  Future _addToOrder() async {
    QuerySnapshot snapshot=await _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").getDocuments();

    for( var product in snapshot.documents){


      _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .collection("Orders").document(product.documentID).setData(product.data());

    }
    for( var product in snapshot.documents){
      _firebaseServices.usersRef
          .doc(_firebaseServices.getUserId())
          .collection("Cart").document(product.documentID).delete();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersRef.doc(_firebaseServices.getUserId())
                .collection("Cart").get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              // Collection Data ready to display
              if (snapshot.connectionState == ConnectionState.done) {
                // Display the data inside a list view
                return ListView(
                  padding: EdgeInsets.only(
                    top: 108.0,
                    bottom: 12.0,
                  ),
                  children: snapshot.data.docs.map((document) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ProductPage(productId: document.id,),
                        ));
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productsRef.doc(document.id).get(),
                        builder: (context, productSnap) {
                          if(productSnap.hasError) {
                            return Container(
                              child: Center(
                                child: Text("${productSnap.error}"),
                              ),
                            );
                          }

                          if(productSnap.connectionState == ConnectionState.done) {
                            Map _productMap = productSnap.data.data();

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 24.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      child: Image.network(
                                        "${_productMap['images'][0]}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: 16.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_productMap['name']}",
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets
                                              .symmetric(
                                            vertical: 4.0,
                                          ),
                                          child: Text(
                                            "₹${_productMap['price']}",
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context)
                                                    .accentColor,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                        ),
                                        Text(
                                          "Size - ${document.data()['size']}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );

                          }

                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),

                );

              }

              // Loading State
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },

          ),
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(left: 10,right:10,bottom:10),
            child: RaisedButton(
              padding: EdgeInsets.only(left: 50,right: 50,top:10,bottom: 10),
              onPressed: (){
            /*    _addToOrder();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => OrderPage(total:_total),
                ));*/
                //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Order Placed")));
              },
              child: const Text('Place Your Order',style: TextStyle(fontSize: 20)),
              color: Colors.black,textColor: Colors.white,
              elevation: 5,),
          ),

          CustomActionBar(
            hasBackArrrow: true,
            title: "Cart",
          )
        ],

      ),
    );
  }
}
