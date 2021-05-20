import 'package:shoppingapp/constants.dart';
import 'package:shoppingapp/services/firebase_services.dart';
import 'package:shoppingapp/widgets/custom_action_bar.dart';
import 'package:shoppingapp/widgets/image_swipe.dart';
import 'package:shoppingapp/widgets/product_size.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();
  String _selectedProductSize = "0";
  bool _saved=false;
  bool _incart=false;
  int i=0;
  int j=0;
  void _checkCart(){
    if(j==0){
      _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").doc(widget.productId).get().then((doc){
        if(doc.exists){
          setState(() {
            _incart=true;
          });

        }
        else{
          setState(() {
            _incart=false;
          });

        }
      });
      j=1;
    }
  }
  void _checkSaved()  {

    if(i==0){
      _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Saved").doc(widget.productId).get().then((doc){
        if(doc.exists){
          setState(() {
            _saved=true;
          });

        }
        else{
          setState(() {
            _saved=false;
          });

        }
      });
      i=1;
    }}


  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }

  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .set({"size": _selectedProductSize});
  }
  Future _deleteFromSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.productId)
        .delete();
  }
  Future _deleteFromCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.productId)
        .delete();
  }

  final SnackBar _snackBar = SnackBar(content: Text("Product added to the cart"),);
  final SnackBar _snackBar1 = SnackBar(content: Text("Product added to the saved"),);
  final SnackBar _snackBar2 = SnackBar(content: Text("Product removed from the saved"),);
  final SnackBar _snackBar3 = SnackBar(content: Text("Product removed from the cart"),);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(widget.productId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }
              _checkSaved();
              _checkCart();
              if (snapshot.connectionState == ConnectionState.done) {
                // Firebase Document Data Map
                Map<String, dynamic> documentData = snapshot.data.data();

                // List of images
                List imageList = documentData['images'];
                List productSizes = documentData['size'];

                // Set an initial size
                _selectedProductSize = productSizes[0];

                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: imageList,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 24.0,
                        left: 24.0,
                        right: 24.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        "${documentData['name']}",
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "₹${documentData['price']}",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "${documentData['desc']}",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 24.0,
                        horizontal: 24.0,
                      ),
                      child: Text(
                        "Select Size",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: productSizes,
                      onSelected: (size) {
                        _selectedProductSize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if(!_saved){
                                await _addToSaved();
                                Scaffold.of(context).showSnackBar(_snackBar1);
                                setState(() {
                                  _saved=true;
                                });
                              }
                              else{
                                await _deleteFromSaved();
                                Scaffold.of(context).showSnackBar(_snackBar2);
                                setState(() {
                                  _saved=false;
                                });
                              }
                            },
                            child: Container(
                              width: 55.0,
                              height: 55.0,
                              decoration: BoxDecoration(
                                  color: Color(0xFFDCDCDC),
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(color:Colors.black,width:1)
                              ),
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage(
                                  _saved?"assets/images/bookmark.png":"assets/images/tab_saved.png",
                                ),
                            // color:  _saved? Theme.of(context).accentColor:Theme.of(context).accentColor ,
                                height: 22.0,

                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {

                                if(!_incart){
                                  await _addToCart();
                                  Scaffold.of(context).showSnackBar(_snackBar);
                                  setState(() {
                                    _incart=true;
                                  });
                                }
                                else{
                                  await _deleteFromCart();
                                  Scaffold.of(context).showSnackBar(_snackBar3);
                                  setState(() {
                                    _incart=false;
                                  });
                                }
                              },
                              child: Container(
                                height: 55.0,
                                margin: EdgeInsets.only(
                                  left: 16.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _incart?"Remove From Cart":"Add To Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
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
          CustomActionBar(
            hasBackArrrow: true,
            hasTitle: false,
            hasBackground: false,
          )
        ],
      ),
    );
  }
}
