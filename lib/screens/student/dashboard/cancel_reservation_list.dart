import 'package:flutter/material.dart';
import 'package:library_management_sys/model/reservation_model.dart';
import 'package:library_management_sys/screens/student/my_wishlist/std_wishlist.dart';
import 'package:provider/provider.dart';

import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../utils/parse_date.dart';
import '../../../view_model/reservations/reservation_view_model.dart';
import '../my_wishlist/view_reservation.dart';
import '../my_wishlist/wishlist_skeleton.dart';
import '../my_wishlist/wishlist_widget.dart';

class CancelReservationList extends StatefulWidget {
  const CancelReservationList({super.key});

  @override
  State<CancelReservationList> createState() => _CancelReservationListState();
}

class _CancelReservationListState extends State<CancelReservationList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Column(
            children: [
              WishlistSkeleton(),
            ],
          );
        } else if (viewModel.cancelReservation.isEmpty) {
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
                  Text(
                    'Oops! Looks like you haven’t made a reservation!!',
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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.cancelReservation.length > 2
              ? 3
              : viewModel.cancelReservation.length,
          itemBuilder: (context, index) {
            final reservationData = viewModel.cancelReservation[index];
            String? filterImage;

            final List<BookImage> bookImages = reservationData.bookImages ?? [];

            final profileImage = bookImages.firstWhere(
                  (image) => image.isProfile == true,
              orElse: () => BookImage(imageUrl: ''), // Ensure fallback
            );

            if (profileImage.imageUrl!.isNotEmpty) {
              filterImage = profileImage.imageUrl;
            }
            return WishlistWidget(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ViewReservation(
                            uid: reservationData.bookInfoId ?? '',
                            reserveId: reservationData.reservationId ?? '',
                            bookName: reservationData.bookInfo?.title ?? '',
                            author: 'minal' ?? '',
                            edition: reservationData.bookInfo?.editionStatement ??
                                '',
                            year: reservationData.bookInfo?.publicationYear
                                .toString() ??
                                '',
                            pages: reservationData.bookInfo?.numberOfPages
                                .toString() ??
                                '',
                            bookNo: reservationData
                                .bookInfo?.bookNumber
                                .toString() ??
                                '',
                            classNo:
                            reservationData.bookInfo?.classNumber ?? '',
                            series:
                            reservationData.bookInfo?.seriesStatement ?? '',
                            image:
                            "${BaseUrl.imageDisplay}/$filterImage}" ??
                                '',
                            status: '',
                            subTitle: reservationData.bookInfo?.subTitle ?? ''),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              title: reservationData.bookInfo?.title ?? '',
              image: reservationData.bookInfo?.coverPhoto != null
                  ? "${BaseUrl.imageDisplay}/$filterImage"
                  : '',
              genre: reservationData.reservationDate != null
                  ? parseDate(reservationData.reservationDate.toString())
                  : '----',
              status: reservationData.status ?? '',
            );
          },
        );
      },
    );
  }
}
