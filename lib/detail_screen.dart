import 'package:books_app/cart_provider.dart';
import 'package:books_app/cart_screen.dart';
import 'package:books_app/db.dart';
import 'package:books_app/listDataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
   bool? onClick;
  final Map<String, dynamic> map;
  final int? count;
   DetailScreen({Key? key, required this.map, this.count, this.onClick})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.red,
              size: height * 0.04,
            )),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined,
              color: Colors.red,
              size: height * 0.04,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CartScreen()));
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: height * 0.01),
                  height: height * 0.28,
                  width: width * 0.35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 0.02),
                      border: Border.all(color: Colors.black),
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.map["cover_image_url"],
                          ),
                          fit: BoxFit.fill)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.1, vertical: height * 0.02),
                child: Text(
                  widget.map['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: height * 0.03, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.map['categories'].toString() != 'null'
                        ? RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Categories :  ',
                                    style: TextStyle(
                                        fontSize: height * 0.025,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: widget.map['categories'].toString(),
                                  style: TextStyle(
                                      fontSize: height * 0.02,
                                      color: Colors.blueGrey),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Available Format :  ',
                              style: TextStyle(
                                  fontSize: height * 0.025,
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: widget.map['available_format'].toString(),
                            style: TextStyle(
                                fontSize: height * 0.02,
                                color: Colors.blueGrey),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Text(
                      "\$${widget.map['price_in_dollar']}",
                      style: TextStyle(
                          fontSize: height * 0.06, color: Colors.red[300]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: height * 0.08,
            width: width * 0.8,
            child: ElevatedButton(
              onPressed: widget.onClick==true?null:() {
                setState(() {
                  widget.onClick=true;
                });
                const message = SnackBar(
                  content: Text('Product added to the cart'),
                  duration: Duration(seconds: 1),
                );
                ScaffoldMessenger.of(context).showSnackBar(message);
                dbHelper!
                    .insert(DataModel(
                  title: widget.map['title'],
                  cover_image_url: widget.map['cover_image_url'],
                  price_in_dollar: widget.map['price_in_dollar'],
                  quantity: 1,
                  id: widget.count,
                  finalPrice: widget.map['price_in_dollar'],
                ))
                    .then((value) {
                  cart.addTotalPrice(widget.map['price_in_dollar']);
                  cart.addCounter();
                  print('product added successfully');
                }).onError((error, stackTrace) {
                  print(error.toString());
                });
              },
              style: ElevatedButton.styleFrom(primary: Colors.red[300]),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white),
                  children: [
                    TextSpan(
                        text: 'Add to Bag  ',
                        style: TextStyle(
                            fontSize: height * 0.04,
                            fontWeight: FontWeight.bold)),
                    WidgetSpan(
                        child: Icon(
                      Icons.shopping_bag_outlined,
                      size: height * 0.04,
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
