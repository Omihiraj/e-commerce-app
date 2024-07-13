import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> products = [];

  callApi() async {
    var url = Uri.https('fakestoreapi.com', 'products');
    var response = await http.get(url);
    List<Widget> allData = [];
    setState(() {
      List data = jsonDecode(response.body);

      for (var product in data) {
        allData.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            product["image"],
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ));
      }
    });
    setState(() {
      products = allData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: TextButton(
              onPressed: () {
                callApi();
              },
              child: const Text("Call Api"),
            ),
          ),
          SizedBox(
            width: 100,
            height: 500,
            child: ListView(children: products),
          ),
        ],
      ),
    );
  }
}


//synchronous
//Asynchronous
