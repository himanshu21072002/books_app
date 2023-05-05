// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:books_app/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

import 'cart_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    ReadJsonData();
    super.initState();
  }

  List _items = [];

  Future<void> ReadJsonData() async {
    final jsonData =
        await rootBundle.rootBundle.loadString('jsonData/all_books.json');
    final list = json.decode(jsonData) as List<dynamic>;
    print(list);
    setState(() {
      _items = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print("Button Pressed");
                    },
                    child: Container(
                      height: height * 0.06,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          'Search',
                          style: TextStyle(
                              color: Colors.grey, fontSize: height * 0.03),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));
                      },
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.red,
                        size: height * 0.04,
                      )),
                ],
              ),
            ),
            SizedBox(
              height: height*0.02,
            ),
            Expanded(
              child: _items.isNotEmpty
                  ? GridView.builder(
                      itemCount: _items.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, count) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width*0.04, vertical: height*0.015),
                          child: Material(
                            elevation: 5,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(map: _items[count],count: count,onClick: false,)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: height*0.01),
                                      height: height*0.12,
                                      width: width*0.35,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: NetworkImage( _items[count]["cover_image_url"],),
                                              fit: BoxFit.fill)
                                      ),),
                                    SizedBox(height: height*0.01,),
                                    Text(_items[count]["title"],textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                    overflow:TextOverflow.ellipsis,
                                    maxLines: 2,),
                                    Spacer(),
                                    Text("\$ ${_items[count]["price_in_dollar"]}",
                                    style: TextStyle(
                                      fontSize: height*0.02,
                                      fontWeight: FontWeight.bold
                                    ),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
