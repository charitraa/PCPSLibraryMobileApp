import 'package:flutter/material.dart';
import 'package:library_management_sys/widgets/custom_search.dart';
import 'package:library_management_sys/widgets/dropdowns/drop_down.dart';

import '../../../resource/colors.dart';
import '../../../widgets/book/book_widget.dart';
import '../../../widgets/explore/explore_header.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Wishlist",
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.asset(
              'assets/images/pcpsLogo.png',
              width: 60,
              height: 28,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Center(
                child: Image.asset(
                  'assets/images/pcpsLogo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Filter By',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomGenre(
                label: 'Filter by Genre',
                wid: size.width,
                onChanged: (value) {
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.filter_alt_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              _buildBookCard(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, int filterIndex) {
    return InkWell(
      onTap: () {
        setState(() {
          index = filterIndex;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: index == filterIndex ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.primary, width: 1.0),
          boxShadow: index == filterIndex
              ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.4),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ]
              : [],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: index == filterIndex ? Colors.white : AppColors.primary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBookCard(Size size) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 2,
            spreadRadius: 0.5,
            offset: const Offset(1, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 0.5),
      ),
      width: size.width,
      height: 80,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              'assets/images/book.png',
              height: 80,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Book Title",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
