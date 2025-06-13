import 'package:flutter/material.dart';
import 'package:library_management_sys/screens/student/my_books/my_book_widget.dart';
import 'package:library_management_sys/screens/student/my_wishlist/wishlist_skeleton.dart';
import 'package:library_management_sys/view_model/users/my_book_view_model.dart';
import 'package:provider/provider.dart';
import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../utils/parse_date.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({super.key});

  @override
  State<MyBooks> createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Provider.of<MyBooksViewModel>(context, listen: false)
        .fetchBooksList(context);
  }

  int index = 1;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "My Books",
          style: TextStyle(fontFamily: 'poppins-black', color: Colors.black),
        ),
        automaticallyImplyLeading: false,
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
            child: Container(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  Expanded(
                    child: Consumer<MyBooksViewModel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.isLoading) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              WishlistSkeleton(),
                            ],
                          );
                        } else if (viewModel.booksList.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.disabled_visible_rounded,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "No books found! Time to add some to your collection!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: viewModel.booksList.length,
                          itemBuilder: (context, index) {
                            final reservationData = viewModel.booksList[index];

                            return MyBookWidget(
                              onTap: () async {},
                              title:
                                  reservationData.book?.bookInfo?.title ?? '',
                              image: reservationData
                                          .book?.bookInfo?.title !=
                                      null
                                  ? "${BaseUrl.imageDisplay}/${reservationData.book?.bookInfo?.title.toString()}"
                                  : '',
                              checkIn: reservationData.checkInDate != null
                                  ? parseDate(
                                      reservationData.checkInDate.toString())
                                  : '',
                              due: reservationData.dueDate != null
                                  ? parseDate(
                                      reservationData.dueDate.toString())
                                  : '',
                              id: reservationData.issueId ?? '',
                              status: reservationData.book?.status ?? '',
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget buildFilterButton(String title, VoidCallback onTap, int Tabndex) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: index == Tabndex ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: index == Tabndex ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
