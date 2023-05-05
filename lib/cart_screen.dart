import 'package:books_app/cart_provider.dart';
import 'package:books_app/db.dart';
import 'package:books_app/listDataModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  int totalItem = 0;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
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
        backgroundColor: Colors.grey[100],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.03),
            child: Row(
              children: [
                Text(
                  "Bag",
                  style: TextStyle(
                    fontSize: height * 0.05,
                  ),
                ),
                Text(" (${cart.getCounter()})"),
              ],
            ),
          ),
          FutureBuilder(
              future: cart.getData(),
              builder: (context, AsyncSnapshot<List<DataModel>> snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  totalItem = snapshot.data!.length;
                  print(
                      "${snapshot.data![0].title}\n Length is: ${snapshot.data!.length}");
                  return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, count) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.015),
                              child: Material(
                                elevation: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: height * 0.01,
                                            left: width * 0.04,
                                            bottom: height * 0.01),
                                        height: height * 0.12,
                                        width: width * 0.25,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                height * 0.02),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  snapshot.data![count]
                                                      .cover_image_url
                                                      .toString(),
                                                ),
                                                fit: BoxFit.fill)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(width * 0.03),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: width * 0.6,
                                              child: Text(
                                                snapshot.data![count].title
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.blueGrey,
                                                  fontSize: height * 0.02,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Text(
                                              "\$ ${snapshot.data![count].finalPrice!.toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  fontSize: height * 0.03,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red[200]),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Qty: ${snapshot.data![count].quantity}",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: height * 0.02),
                                                ),
                                                SizedBox(
                                                  width: width * 0.1,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      int quantity = snapshot
                                                          .data![count]
                                                          .quantity!;
                                                      double price = snapshot
                                                          .data![count]
                                                          .price_in_dollar!;
                                                      quantity++;
                                                      double? newPrice =
                                                          price * quantity;
                                                      dbHelper!
                                                          .updateQuantity(
                                                              DataModel(
                                                        id: snapshot
                                                            .data![count].id!,
                                                        title: snapshot
                                                            .data![count].title!
                                                            .toString(),
                                                        price_in_dollar: snapshot
                                                            .data![count]
                                                            .price_in_dollar,
                                                        cover_image_url:
                                                            snapshot
                                                                .data![count]
                                                                .cover_image_url
                                                                .toString(),
                                                        finalPrice: newPrice,
                                                        quantity: quantity,
                                                      ))
                                                          .then((value) {
                                                        newPrice = 0;
                                                        quantity = 0;
                                                        cart.addTotalPrice(
                                                            double.parse(snapshot
                                                                .data![count]
                                                                .price_in_dollar
                                                                .toString()));
                                                      }).onError((error,
                                                              stackTrace) {
                                                        print(error.toString());
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.add_circle_outline,
                                                      size: height * 0.04,
                                                      color: Colors.orange,
                                                    )),
                                                SizedBox(
                                                  width: width * 0.02,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      int quantity = snapshot
                                                          .data![count]
                                                          .quantity!;
                                                      double price = snapshot
                                                          .data![count]
                                                          .price_in_dollar!;
                                                      quantity--;
                                                      double? newPrice =
                                                          price * quantity;
                                                      if (quantity > 0) {
                                                        dbHelper!
                                                            .updateQuantity(
                                                                DataModel(
                                                          id: snapshot
                                                              .data![count].id!,
                                                          title: snapshot
                                                              .data![count]
                                                              .title!
                                                              .toString(),
                                                          price_in_dollar: snapshot
                                                              .data![count]
                                                              .price_in_dollar,
                                                          cover_image_url:
                                                              snapshot
                                                                  .data![count]
                                                                  .cover_image_url
                                                                  .toString(),
                                                          finalPrice: newPrice,
                                                          quantity: quantity,
                                                        ))
                                                            .then((value) {
                                                          newPrice = 0;
                                                          quantity = 0;
                                                          cart.removeTotalPrice(
                                                              double.parse(snapshot
                                                                  .data![count]
                                                                  .price_in_dollar
                                                                  .toString()));
                                                        }).onError((error,
                                                                stackTrace) {
                                                          print(
                                                              error.toString());
                                                        });
                                                      }
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .remove_circle_outline_rounded,
                                                      size: height * 0.04,
                                                      color: Colors.orange,
                                                    )),
                                                SizedBox(
                                                  width: width * 0.06,
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      dbHelper!.delete(snapshot
                                                          .data![count].id);
                                                      cart.removerCounter();
                                                      cart.removeTotalPrice(
                                                          double.parse(snapshot
                                                              .data![count]
                                                              .finalPrice
                                                              .toString()));
                                                    },
                                                    icon: Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.purple[200],
                                                      size: height * 0.04,
                                                    ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }));
                } else {
                  return Column(
                    children: [
                      SizedBox(
                        height: height * 0.3,
                      ),
                      Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: height * 0.05,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.add_shopping_cart,
                        size: height * 0.08,
                        color: Colors.red,
                      )
                    ],
                  );
                }
              }),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"|| value.getTotalPrice().toStringAsFixed(2) =="-0.00"
                  ? false
                  : true,
              child: Column(
                children: [
                  ReusableWidget(
                    title: 'Subtotal: ',
                    value: r'$' + value.getTotalPrice().toStringAsFixed(2),
                    height: height,
                    width: width,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: value.getCounter()>5
                          ? null
                          : () {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          text: 'Do you want to checkout?',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                          onConfirmBtnTap: (){
                            print("moving to next screen");
                          }
                        );
                      },
                      child: Container(
                        width: width * 0.8,
                        height: height * 0.082,
                        decoration: BoxDecoration(
                            color: value.getCounter()>5
                                ? Colors.grey
                                : Colors.red[300],
                            borderRadius: BorderRadius.circular(height * 0.05)),
                        child: Center(
                          child: Text(
                            'Proceed to Checkout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.03,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  final double height, width;
  const ReusableWidget(
      {super.key, required this.title,
      required this.value,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title,
              style:
                  TextStyle(fontSize: height * 0.03, color: Colors.grey[600])),
          Text(
            value.toString(),
            style: TextStyle(fontSize: height * 0.04, color: Colors.red[300]),
          ),
        ],
      ),
    );
  }
}
