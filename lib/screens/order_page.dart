import 'package:google_fonts/google_fonts.dart';
import 'package:shoppingapp/screens/home_page.dart';
import 'package:shoppingapp/screens/product_page.dart';
import 'package:shoppingapp/services/firebase_services.dart';
import 'package:shoppingapp/tabs/home_tab.dart';
import 'package:shoppingapp/widgets/custom_action_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/screens/landing_page.dart';

class OrderPage extends StatefulWidget {

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersRef.doc(_firebaseServices.getUserId())
                .collection("Orders").get(),
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
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(25)),
              onPressed: (){

                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => HomePage(),
                ));
                //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Order Placed")));
               /* MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      textTheme: GoogleFonts.poppinsTextTheme(
                        Theme.of(context).textTheme,
                      ),
                      accentColor: Color(0xFFE11584)
                  ),
                  home: LandingPage(),
                );*/
              },

              child: const Text('Continue Shopping',style: TextStyle(fontSize: 20)),
              color: Colors.black,textColor: Colors.white,
              elevation: 5,),
          ),

          CustomActionBar(
            hasBackArrrow: true,
            title: "Orders",
          )
        ],

      ),
    );
  }
}
