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

            final List<BookImages> bookImages =
                reservationData.bookInfo?.bookImages ?? [];

            final profileImage = bookImages.firstWhere(
              (image) => image.isProfile == true,
              orElse: () => BookImages(imageUrl: ''), // Ensure fallback
            );

            if (profileImage.imageUrl!.isNotEmpty) {
              filterImage = profileImage.imageUrl;
            }
            return WishlistWidget(
              onTap: () {

              },
              title: reservationData.bookInfo?.title ?? '',
              image: filterImage != null
                  ? "${BaseUrl.imageDisplay}/$filterImage"
                  : '',
              genre: reservationData.reservationDate != null
                  ? parseDate(reservationData.reservationDate.toString())
                  : '----',
              status: reservationData.status ?? '',
              publicationYear:
                  reservationData.bookInfo?.publicationYear.toString() ?? "",
            );
          },
        );
      },
    );
  }
}
