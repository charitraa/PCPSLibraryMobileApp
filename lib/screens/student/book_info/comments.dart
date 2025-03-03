import 'package:flutter/material.dart';

import '../../../resource/colors.dart';
import '../../../widgets/book/review_card.dart';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reviews",
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
          SizedBox(
            width: 18,
          )
        ],
      ),
      body: SafeArea(child: Container(
        width: size.width,
        height: size.height,
        child: const SingleChildScrollView(
          child: Column(
            children: [
              ReviewCard(
                  image: '',
                  name: "Anusha Tamrakar",
                  text:
                  "The dress is great! Very classy and . It fit perfectly! "
              )
              ,
            ],
          ),
        ),
      )),
    );
  }
}
