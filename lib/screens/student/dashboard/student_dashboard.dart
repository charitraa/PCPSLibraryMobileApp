import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/screens/student/dashboard/category_shimmer_eff.dart';
import 'package:library_management_sys/screens/student/dashboard/profile_skeleton.dart';
import 'package:library_management_sys/screens/student/dashboard/reservation_list.dart';
import 'package:library_management_sys/screens/student/dashboard/user_stats.dart';
import 'package:library_management_sys/screens/student/in_app_notification/in_app_notification.dart';
import 'package:library_management_sys/screens/student/my_books/my_books.dart';
import 'package:library_management_sys/screens/student_nav.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/view_model/notifications/notification_view_model.dart';
import 'package:library_management_sys/view_model/users/my_book_view_model.dart';
import 'package:library_management_sys/view_model/users/my_due_view_model.dart';
import 'package:library_management_sys/view_model/users/my_pay_view_model.dart';
import 'package:library_management_sys/widgets/book/book_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constant/base_url.dart';
import '../../../data/response/status.dart';
import '../../../utils/parse_date.dart';
import '../../../view_model/books/book_view_model.dart';
import '../../../view_model/reservations/reservation_view_model.dart';
import '../../../widgets/book/book_skeleton.dart';
import '../book_info/book_info.dart';
import '../my_wishlist/std_wishlist.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    fetch();
    super.initState();

  }

  fetch() async {
    await Provider.of<PaymentViewModel>(context, listen: false)
        .fetchReservation(context);
    await Provider.of<MyDueViewModel>(context, listen: false)
        .fetchBooksList(context);
    await Provider.of<MyBooksViewModel>(context, listen: false)
        .fetchBooksList(context);
    await Provider.of<ReservationViewModel>(context, listen: false)
        .fetchReservation(context);

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Consumer<AuthViewModel>(
                builder: (context, userDataViewModel, child) {
                  final user = userDataViewModel.currentUser;
                  if (userDataViewModel.isLoading) {
                    return const ProfileSkeleton();
                  } else if (user != null) {
                    String getFirstWord(String input) {
                      List<String> words = input.trim().split(' ');
                      return words.isNotEmpty ? words[0] : input;
                    }
                    String name = getFirstWord(user.data!.fullName??'');
                    String image = user.data?.profilePicUrl != null
                        ? "${BaseUrl.imageDisplay}/${user.data?.profilePicUrl}"
                        : '';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey[300],
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: image,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error, size: 24),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "WELCOME",
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      letterSpacing: 1.2),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                      color: AppColors.secondary,
                                      fontSize: 12,
                                      fontFamily: 'poppins'),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        NotificationPage(),
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
                              child: Consumer<NotificationViewModel>(
                                builder:
                                    (context, notificationViewModel, child) {
                                  int unreadCount = notificationViewModel
                                      .notificationList
                                      .where((notification) =>
                                          !(notification.read ?? false))
                                      .length;
                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      const Icon(Icons.notifications, size: 28),
                                      if (unreadCount > 0)
                                        Positioned(
                                          right: 0,
                                          top: -5,
                                          child: Container(
                                            padding: const EdgeInsets.all(
                                                4), // Adjust padding for better spacing
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 18,
                                              minHeight: 18,
                                            ),
                                            child: Center(
                                              child: Text(
                                                unreadCount.toString(),
                                                style: const TextStyle(
                                                  color: Colors
                                                      .white, // White text color
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            const Image(
                              image: AssetImage('assets/images/pcpsLogo.png'),
                              width: 60,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ],
                        )
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey[300],
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: '',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error, size: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "WELCOME",
                                    style: TextStyle(
                                        color: AppColors.secondary,
                                        letterSpacing: 1.2),
                                  ),
                                  Text(
                                    'Unknown',
                                    style: TextStyle(
                                        color: AppColors.secondary,
                                        fontSize: 12,
                                        fontFamily: 'poppins'),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              Icon(Icons.notifications),
                              SizedBox(
                                width: 4,
                              ),
                              Image(
                                image: AssetImage('assets/images/pcpsLogo.png'),
                                width: 60,
                                height: 20,
                                fit: BoxFit.cover,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Your Dues',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'poppins',
                        color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 125,
                child: Consumer<MyDueViewModel>(
                  builder: (context, value, child) {
                    final books = value.booksList;
                    if (value.isLoading) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xff868484),
                                      width: 0.4,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.category, // Placeholder icon
                                      color: Colors.black,
                                      size: 33,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const SizedBox(
                                  width: 70,
                                  child: Text(
                                    "Loading...", // Placeholder text
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xff868484),
                                      width: 0.4,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.category, // Placeholder icon
                                      color: Colors.black,
                                      size: 33,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const SizedBox(
                                  width: 70,
                                  child: Text(
                                    "Loading...", // Placeholder text
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )
                          ,
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xff868484),
                                      width: 0.4,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.category, // Placeholder icon
                                      color: Colors.black,
                                      size: 33,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const SizedBox(
                                  width: 70,
                                  child: Text(
                                    "Loading...", // Placeholder text
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }
                    if(books!=null){
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(bottom: 18),
                        itemCount: books.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return Column(
                            children: [
                              Container(
                                height: 70,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,

                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xff868484),
                                    width: 0.4,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    const Text('Rs.',style: TextStyle(color: Colors.white)),
                                    Text(book.amount.toString(),style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                              SizedBox(
                                width:80,
                                child: Text(
                                  book.penaltyType??'',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,

                                  style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                    }
                    else {
                      return Column(
                        children: [
                          Container(
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary,

                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xff868484),
                                width: 0.4,
                              ),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text('Rs.',style: TextStyle(color: Colors.white)),
                                Text('N/A',style: TextStyle(color: Colors.white),)
                              ],
                            ),
                          ),

                        ],
                      );
                    }
                  },
                ),
              ),

              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  "My Books",
                  style: TextStyle(
                      fontSize: 30,
                      color: AppColors.primary,
                      fontFamily: 'poppins'),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Currently Readings',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'poppins',
                        color: AppColors.primary),
                  ),
                  buildFilterButton('View', () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const StudentNavBar(
                          index: 3,
                          reqIndex: 0,
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
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }, AppColors.primary, 12)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 200,
                child: Consumer<MyBooksViewModel>(
                  builder: (context, value, child) {
                    final books = value.booksList;

                    if (value.isLoading) {
                      return const BookSkeletonGrid();
                    }
                    if (books.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Books available.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 18),
                      itemCount: books.length > 1 ? books.length.clamp(1, 4) : books.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final book = books[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: BookWidget(
                              bookImage:
                                  "${BaseUrl.imageDisplay}/${book.book?.bookInfo?.coverPhoto ?? ''}",
                              title: book.book?.bookInfo?.title ?? '',
                              author:
                              book.dueDate != null
                                  ? parseDate(
                                  book.dueDate.toString())
                                  : '' ??
                                      '',
                              onTap: () {
                                // Navigator.of(context).push(
                                //   PageRouteBuilder(
                                //     pageBuilder: (context, animation,
                                //             secondaryAnimation) =>
                                //         BookInfo(
                                //             uid: book.bookInfoId ?? '',
                                //             bookName: book.title ?? '',
                                //             author: authors ?? '',
                                //             edition: book.editionStatement ??
                                //                 '',
                                //             year: book.publicationYear.toString() ??
                                //                 '',
                                //             publisher:
                                //                 book.publisher!.publisherName ??
                                //                     '',
                                //             pages:
                                //                 book.numberOfPages.toString() ??
                                //                     '',
                                //             score: book.score != null
                                //                 ? (book.score?.score as int)
                                //                     .toDouble()
                                //                 : 0,
                                //             bookNo: book.bookNumber.toString() ??
                                //                 '',
                                //             classNo:
                                //                 book.classNumber.toString() ??
                                //                     '',
                                //             series:
                                //                 book.seriesStatement.toString() ??
                                //                     '',
                                //             genre: genres ?? '',
                                //             isbn: isbn ?? '',
                                //             image:
                                //                 "${BaseUrl.imageDisplay}/${book.coverPhoto}" ?? '',
                                //             status: '',
                                //             subTitle: book.subTitle ?? ''),
                                //     transitionsBuilder: (context, animation,
                                //         secondaryAnimation, child) {
                                //       const begin = Offset(1.0, 0.0);
                                //       const end = Offset.zero;
                                //       const curve = Curves.easeInOut;
                                //       var tween = Tween(begin: begin, end: end)
                                //           .chain(CurveTween(curve: curve));
                                //       var offsetAnimation =
                                //           animation.drive(tween);
                                //       return SlideTransition(
                                //         position: offsetAnimation,
                                //         child: child,
                                //       );
                                //     },
                                //   ),
                                // );
                              }),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 11,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Reservation's",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'poppins',
                        color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: ReservationList(),
              ),
              buildFilterButton('View all Reservations', () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const Wishlist(),
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
              }, AppColors.primary, 12),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Payment History',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'poppins',
                        color: AppColors.primary),
                  ),
                  buildFilterButton('View', () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                        const StudentNavBar(
                          index: 2,
                          reqIndex: 0,
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
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }, AppColors.primary, 12)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 100,
                child: Consumer<PaymentViewModel>(
                  builder: (context, value, child) {
                    final books = value.reservationList;
                    if (value.isLoading) {
                      return const BookSkeletonGrid();
                    }
                    if (books.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: size.width * 0.3,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Dues',
                                style:
                                TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '---',
                                style:
                                TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(bottom: 18),
                      itemCount: books.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final book = books[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width * 0.35,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  book.paymentType ?? '',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Rs. ${book.amountPaid.toString()}" ?? '',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    ));
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

  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
