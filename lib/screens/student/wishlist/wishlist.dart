import 'package:flutter/material.dart';
import 'package:library_management_sys/widgets/wishlist/wishlist_widget.dart';

import '../../../resource/colors.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> books = [
    {
      "title": "Don't Look Back",
      "author": "Isaac Nelson",
      "image": "assets/images/book.png",
      "rating": 5,
      "genre": "Drama",
      "available": true
    },
    {
      "title": "The Silent Patient and hello kiki world 123456",
      "author": "Alex Michaelides",
      "image": "assets/images/book.png",
      "rating": 4,
      "genre": "Thriller",
      "available": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(fontFamily: 'poppins-black', color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 18,
        ),
        actions: const [
          Image(
            image: AssetImage('assets/images/pcpsLogo.png'),
            width: 56,
            height: 24,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 18)
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              return WishlistWidget(
                title: book["title"],
                author: book["author"],
                image: book["image"],
                rating: book["rating"],
                genre: book["genre"],
                available: book["available"],
              );
            },
          ),
        ),
      ),
    );
  }
}
