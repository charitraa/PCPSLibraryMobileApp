import 'package:flutter/material.dart';
import 'package:library_management_sys/screens/student/my_wishlist/wishlist_widget.dart';
import 'package:library_management_sys/view_model/books/book_view_model.dart';
import 'package:library_management_sys/view_model/reservations/reservation_view_model.dart';
import 'package:provider/provider.dart';

import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../utils/format_date.dart';
import '../../../widgets/book/review_skeleton.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Reservations",
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
            child: Container(
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        buildFilterButton(
                            'Pending', () {}, AppColors.primary, 12),
                        buildFilterButton(
                            'Cancelled', () {}, AppColors.primary, 12),
                        buildFilterButton(
                            'Confirmed', () {}, AppColors.primary, 12),
                        buildFilterButton(
                            'Resolved', () {}, AppColors.primary, 12),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer<ReservationViewModel>(
                      builder: (context, viewModel, child) {
                        if (viewModel.isLoading) {
                          return const ReviewCardSkeleton();
                        } else if (viewModel.reservationList.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'Oops! Looks like you haven’t made a reservation!!',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
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
                            print(reservationData.reservationDate);
                            return WishlistWidget(
                              title: reservationData.bookInfo?.title ?? '',
                              author: reservationData.bookInfo?.title ?? '',
                              image: reservationData.bookInfo?.coverPhoto !=
                                      null
                                  ? "${BaseUrl.imageDisplay}/${reservationData.bookInfo?.coverPhoto.toString()}"
                                  : '',
                              rating: 2,
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

  Widget buildFilterButton(
      String title, VoidCallback onTap, Color color, double size) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: size),
        ),
      ),
    );
  }
}
