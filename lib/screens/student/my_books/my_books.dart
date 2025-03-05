import 'package:flutter/material.dart';
import 'package:library_management_sys/screens/student/my_wishlist/view_reservation.dart';
import 'package:library_management_sys/screens/student/my_wishlist/wishlist_skeleton.dart';
import 'package:library_management_sys/screens/student/my_wishlist/wishlist_widget.dart';
import 'package:library_management_sys/view_model/reservations/reservation_view_model.dart';
import 'package:provider/provider.dart';

import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../utils/format_date.dart';
import '../../../widgets/book/review_skeleton.dart';

class MyBooks extends StatefulWidget {
  const MyBooks({super.key});

  @override
  State<MyBooks> createState() => _MyBooksState();
}

class _MyBooksState extends State<MyBooks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Provider.of<ReservationViewModel>(context, listen: false)
        .fetchReservation(context);
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
                    child: Consumer<ReservationViewModel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.isLoading) {
                          return const WishlistSkeleton();
                        } else if (viewModel.reservationList.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.disabled_visible_rounded,color: Colors.grey,),
                                  SizedBox(height: 10,),
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
                          itemCount: viewModel.reservationList.length,
                          itemBuilder: (context, index) {
                            final reservationData =
                            viewModel.reservationList[index];

                            String authors = "";
                            List<String> authorNames = reservationData
                                .bookInfo!.bookAuthors!
                                .map((bookAuthor) {
                              return bookAuthor.author?.fullName ?? '';
                            }).toList();
                            authors += authorNames.join(", ");
                            return WishlistWidget(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => ViewReservation(
                                        uid: reservationData.bookInfoId ?? '',
                                        reserveId: reservationData.reservationId ?? '',
                                        bookName: reservationData.bookInfo?.title ??
                                            '',
                                        author: authors ?? '',
                                        edition: reservationData
                                            .bookInfo?.editionStatement ??
                                            '',
                                        year: reservationData
                                            .bookInfo?.publicationYear
                                            .toString() ??
                                            '',
                                        pages: reservationData
                                            .bookInfo?.numberOfPages
                                            .toString() ??
                                            '',
                                        bookNo: reservationData
                                            .bookInfo?.bookNumber
                                            .toString() ??
                                            '',
                                        classNo: reservationData
                                            .bookInfo?.classNumber ??
                                            '',
                                        series: reservationData
                                            .bookInfo?.seriesStatement ??
                                            '',
                                        image: "${BaseUrl.imageDisplay}/${reservationData.bookInfo?.coverPhoto}" ?? '',
                                        status: '',
                                        subTitle: reservationData.bookInfo?.subTitle ?? ''),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve));
                                      var offsetAnimation =
                                      animation.drive(tween);
                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              title: reservationData.bookInfo?.title ?? '',
                              author: authors ?? '',
                              image: reservationData.bookInfo?.coverPhoto !=
                                  null
                                  ? "${BaseUrl.imageDisplay}/${reservationData.bookInfo?.coverPhoto.toString()}"
                                  : '',
                              genre: reservationData.reservationDate != null
                                  ? formatDate(reservationData.reservationDate
                                  .toString())
                                  : '',
                              available: reservationData.book?.status ?? '',
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
