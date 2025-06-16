import 'package:flutter/material.dart';
import 'package:library_management_sys/model/reservation_model.dart';
import 'package:provider/provider.dart';
import '../../../constant/base_url.dart';
import '../../../utils/parse_date.dart';
import '../../../view_model/reservations/reservation_view_model.dart';
import '../my_wishlist/view_reservation.dart';
import '../my_wishlist/wishlist_skeleton.dart';
import '../my_wishlist/wishlist_widget.dart';

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Consumer<ReservationViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Column(
            children: [
              WishlistSkeleton(),
            ],
          );
        } else if (viewModel.reservationList.isEmpty) {
          return Column(
            children: [
              _buildNoDataCard(
                  size, 'Oops! Looks like you haven’t made a reservation!!')
            ],
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.reservationList.length > 2
              ? 3
              : viewModel.reservationList.length,
          itemBuilder: (context, index) {
            final reservationData = viewModel.reservationList[index];

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
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ViewReservation(
                      uid: reservationData.bookInfoId ?? '',
                      books: reservationData,
                      image: filterImage ?? '',
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      var offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                          position: offsetAnimation, child: child);
                    },
                  ),
                );
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
                  reservationData.bookInfo!.publicationYear.toString(),
            );
          },
        );
      },
    );
  }

  Widget _buildNoDataCard(Size size, String message) {
    return Container(
      width: size.width * 0.9,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey[400]!, width: 0.5),
      ),
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.disabled_visible_rounded,
          ),
          SizedBox(
            height: 5,
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
    );
  }
}
