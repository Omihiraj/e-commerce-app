import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categoryProducts = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(240, 255, 255, 255),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "E-APP",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.person,
                  size: 24,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<List>(
              future: getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text("");
                } else {
                  return SizedBox(
                    height: 50,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: InkWell(
                              onTap: () {
                                getProductsByCategory(
                                        category: snapshot.data![index])
                                    .then(
                                  (value) {
                                    setState(() {
                                      categoryProducts = value;
                                    });
                                  },
                                );
                              },
                              child: Text(snapshot.data![index]
                                  .toString()
                                  .toUpperCase()),
                            ),
                          );
                        }),
                  );
                }
              },
            ),
          ),

          SizedBox(
            height: 270,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryProducts.length,
                itemBuilder: (context, index) {
                  Product product = Product.fromJson(categoryProducts[index]);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 270,
                      width: 150,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(36, 158, 158, 158),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              //snapshot.data![index]["image"],
                              product.image!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              // snapshot.data![index]["title"],
                              product.title!,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
          // SizedBox(
          //   width: 300,
          //   height: 500,
          //   child: FutureBuilder<List>(
          //     future: getData(),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(
          //           child: CircularProgressIndicator(),
          //         );
          //       } else {
          //         return ListView.builder(
          //           itemCount: snapshot.data!.length,
          //           itemBuilder: (context, index) {
          //             Product product = Product.fromJson(snapshot.data![index]);
          //             return Column(
          //               children: [
          //                 Image.network(
          //                   //snapshot.data![index]["image"],
          //                   product.image!,
          //                   width: 150,
          //                 ),
          //                 Text(
          //                   // snapshot.data![index]["title"],
          //                   product.title!,
          //                 )
          //               ],
          //             );
          //           },
          //         );
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<List> getData() async {
    var url = Uri.https('fakestoreapi.com', 'products');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future<List> getCategories() async {
    var url = Uri.https('fakestoreapi.com', 'products/categories');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future<List> getProductsByCategory({required String category}) async {
    var url = Uri.https('fakestoreapi.com', 'products/category/$category');
    var response = await http.get(url);
    return jsonDecode(response.body);
  }
}
