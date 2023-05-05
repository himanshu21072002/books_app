// ignore_for_file: non_constant_identifier_names, library_prefixes

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
  List filteredItems = [];

  void runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = _items;
    } else {
      results = _items
          .where((element) => element["title"]
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredItems = results;
    });
  }

  Future<void> ReadJsonData() async {
    final jsonData =
        await rootBundle.rootBundle.loadString('jsonData/all_books.json');
    final list = json.decode(jsonData) as List<dynamic>;
    print(list);
    setState(() {
      _items = list;
      filteredItems = _items;
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
                  Container(
                      height: height * 0.06,
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: width * 0.1),
                        child: TextField(
                          onChanged: (value) {
                            runFilter(value);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Search',
                              suffixIcon: const Icon(Icons.search),
                              labelStyle: TextStyle(fontSize: height * 0.02)),
                        ),
                      )),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CartScreen()));
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
              height: height * 0.02,
            ),
            Expanded(
              child: filteredItems.isNotEmpty
                  ? GridView.builder(
                      itemCount: filteredItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, count) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.015),
                          child: Material(
                            elevation: 5,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailScreen(
                                              map: filteredItems[count],
                                              count: count,
                                              onClick: false,
                                            )));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: height * 0.01),
                                      height: height * 0.12,
                                      width: width * 0.35,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                filteredItems[count]
                                                    ["cover_image_url"],
                                              ),
                                              fit: BoxFit.fill)),
                                    ),
                                    SizedBox(
                                      height: height * 0.01,
                                    ),
                                    Text(
                                      filteredItems[count]["title"],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "\$ ${filteredItems[count]["price_in_dollar"]}",
                                      style: TextStyle(
                                          fontSize: height * 0.02,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : Center(child:  Text("No Match Found",style: TextStyle(fontSize: height*0.04),)),
            ),
          ],
        ),
      ),
    );
  }
}
