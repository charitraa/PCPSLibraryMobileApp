import 'package:flutter/material.dart';
import 'package:library_management_sys/widgets/book/book_widget.dart';
import 'package:library_management_sys/widgets/text.dart';

class CustomWidgetTest extends StatefulWidget {
  const CustomWidgetTest({super.key});

  @override
  State<CustomWidgetTest> createState() => _CustomWidgetTestState();
}

class _CustomWidgetTestState extends State<CustomWidgetTest> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(28.0),
          child: Column(
            children: [
              BookWidget(bookImage: 'assets/images/book.png', title: 'tets', author: 'asa'),
              BookWidget(bookImage: 'assets/images/book.png', title: 'tets', author: 'asa'),
              SearchBar()

            ],
          )
        ),
      ),
    );
  }
}
