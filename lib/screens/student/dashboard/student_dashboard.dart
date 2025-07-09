import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/model/my_books_model.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/screens/student/book_request/book_request_screen.dart';
import 'package:library_management_sys/screens/student/book_request/request_book.dart';
import 'package:library_management_sys/screens/student/dashboard/confirm_reserved_list.dart';
import 'package:library_management_sys/screens/student/in_app_notification/in_app_notification.dart';
import 'package:library_management_sys/screens/student/my_books/my_book_widget.dart';
import 'package:library_management_sys/screens/student/payment/payment.dart';
import 'package:library_management_sys/screens/student_nav.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/view_model/notifications/notification_view_model.dart';
import 'package:library_management_sys/view_model/users/my_book_view_model.dart';
import 'package:library_management_sys/view_model/users/my_due_view_model.dart';
import 'package:library_management_sys/view_model/users/my_pay_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constant/base_url.dart';
import '../../../utils/parse_date.dart';
import '../../../view_model/reservations/reservation_view_model.dart';
import '../my_wishlist/std_wishlist.dart';
import 'reservation_list.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final paymentViewModel =
    Provider.of<PaymentViewModel>(context, listen: false);
    final dueViewModel = Provider.of<MyDueViewModel>(context, listen: false);
    final booksViewModel =
    Provider.of<MyBooksViewModel>(context, listen: false);
    final reservationViewModel =
    Provider.of<ReservationViewModel>(context, listen: false);
    final notificationViewModel =
    Provider.of<NotificationViewModel>(context, listen: false);
    setState(() => _isLoading = true);
    try {
      if (paymentViewModel.paymentList.isEmpty) {
        await paymentViewModel.fetchPayment(context);
      }
      if (dueViewModel.duesList.isEmpty) {
        await dueViewModel.fetchDues(context);
      }
      if (booksViewModel.booksList.isEmpty) {
        await booksViewModel.fetchBooksList(context);
      }
      if (reservationViewModel.reservationList.isEmpty) {
        await reservationViewModel.fetchReservation(context);
      }
      if (reservationViewModel.confirmReservation.isEmpty) {
        await reservationViewModel.fetchConfirmReservation(context);
      }
      if (reservationViewModel.cancelReservation.isEmpty) {
        await reservationViewModel.fetchCancelReservation(context);
      }
      if (notificationViewModel.notificationList.isEmpty) {
        await notificationViewModel.fetchNotifications(context);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: _isLoading
          ? _buildSkeletonLoader(size)
          : SafeArea(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: size.width,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildProfileSection(),
                      const SizedBox(height: 15),
                      _buildSectionHeader('Your Dues'),
                      const SizedBox(height: 10),
                      _buildDuesSection(size),
                      const SizedBox(height: 20),
                      _buildSectionHeader('My Books'),
                      _buildBooksSection(size),
                      const SizedBox(height: 20),
                      _buildRequestBookSection(size),
                      const SizedBox(height: 20),
                      _buildSectionHeader('Your Reservations'),
                      const SizedBox(height: 8),
                      _buildReservationsSection(size),
                      const SizedBox(height: 20),
                      _buildPaymentSection(size),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSkeletonLoader(Size size) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Profile Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 100, height: 14, color: Colors.white),
                          const SizedBox(height: 6),
                          Container(width: 60, height: 12, color: Colors.white),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(width: 28, height: 28, color: Colors.white),
                      const SizedBox(width: 12),
                      Container(width: 80, height: 24, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Dues Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 120, height: 18, color: Colors.white),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          width: size.width * 0.35,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[400]!, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Books Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 150, height: 28, color: Colors.white),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 120, height: 16, color: Colors.white),
                      Container(width: 60, height: 24, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: size.width - 30,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!, width: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Request Book Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 150, height: 18, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(
                    width: size.width - 30,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!, width: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Reservations Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 150, height: 18, color: Colors.white),
                  const SizedBox(height: 12),
                  Container(
                    width: size.width - 30,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[400]!, width: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Payment Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 150, height: 18, color: Colors.white),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(width: 120, height: 16, color: Colors.white),
                      Container(width: 60, height: 24, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2,
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          width: size.width * 0.42,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[400]!, width: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Consumer<AuthViewModel>(
      builder: (context, userDataViewModel, child) {
        final user = userDataViewModel.currentUser;
        if (user == null) {
          return _buildDefaultProfile();
        }
        String getFirstWord(String input) {
          List<String> words = input.trim().split(' ');
          return words.isNotEmpty ? words[0] : input;
        }

        String name = getFirstWord(user.data!.fullName ?? '');

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const StudentNavBar(index:4),
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
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: Image.network(
                        user.data?.profilePicUrl??'',
                        width: 36,
                        height: 36,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _buildImageSkeleton();
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, size: 24);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WELCOME",
                      style: TextStyle(
                        color: AppColors.secondary,
                        letterSpacing: 1.2,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 14,
                        fontFamily: 'poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            NotificationPage(),
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
                  child: Consumer<NotificationViewModel>(
                    builder: (context, notificationViewModel, child) {
                      int unreadCount = notificationViewModel.notificationList
                          .where(
                              (notification) => !(notification.read ?? false))
                          .length;
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(Icons.notifications,
                              size: 24, color: AppColors.primary),
                          if (unreadCount > 0)
                            Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                    minWidth: 16, minHeight: 16),
                                child: Center(
                                  child: Text(
                                    unreadCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
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
                const SizedBox(width: 8),
                const Image(
                  image: AssetImage('assets/images/pcpsLogo.png'),
                  width: 80,
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildDefaultProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                  child: Image.network(
                    '',
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return _buildImageSkeleton();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 24);
                    },
                  ),
                )
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "WELCOME",
                    style: TextStyle(
                      color: AppColors.secondary,
                      letterSpacing: 1.2,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Unknown',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontSize: 14,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.notifications, size: 24, color: AppColors.primary),
              const SizedBox(width: 8),
              const Image(
                image: AssetImage('assets/images/pcpsLogo.png'),
                width: 60,
                height: 20,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: title == 'My Books' ? 28 : 16,
        fontFamily: 'poppins',
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDuesSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 105,
          child: Consumer<MyDueViewModel>(
            builder: (context, value, child) {
              final dues = value.duesList;
              if (dues.isEmpty) {
                return _buildNoDataCard(size, 'No Pending Dues');
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 8, right: 8),
                itemCount: dues.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final due = dues[index];
                  return GestureDetector(
                    onTap: () => _showDueDetailsDialog(context, due),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        children: [
                          Container(
                            width: size.width * 0.35,
                            height: 95,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red.shade600, Colors.red.shade400],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          due.penaltyType == 'PropertyDamage'
                                              ? 'Property Damage'
                                              : due.penaltyType ?? 'Unknown',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(
                                        Icons.warning_rounded,
                                        color: Colors.white.withOpacity(0.8),
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Rs. ${due.amount}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    due.createdAt != null
                                        ? parseDate(due.createdAt.toString())
                                        : 'N/A',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      ],
    );
  }

  void _showDueDetailsDialog(BuildContext context, dynamic due) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Due Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(),
                _buildDetailRow('Type', due.penaltyType == 'PropertyDamage' ? 'Property Damage' : due.penaltyType ?? 'Unknown'),
                _buildDetailRow('Amount', 'Rs. ${due.amount}'),
                _buildDetailRow('Status', due.status ?? 'N/A'),
                _buildDetailRow('Description', due.description ?? 'No description'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Currently Reading',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'poppins',
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildFilterButton(
              'View',
              () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const StudentNavBar(index: 3, reqIndex: 0),
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
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Consumer<MyBooksViewModel>(
          builder: (context, value, child) {
            final books = value.booksList.toSet().toList(); // Remove duplicates
            if (books.isEmpty) {
              return SizedBox(
                height: 60,
                child: _buildNoDataCard(size, 'No Books Currently Reading'),
              );
            }
            return CarouselSlider.builder(
              itemCount: books.length,
              itemBuilder: (context, index, realIndex) {
                final book = books[index];
                String? filterImage;

                final List<BookImages> bookImages =
                    book.book?.bookInfo?.bookImages ?? [];

                final profileImage = bookImages.firstWhere(
                  (image) => image.isProfile == true,
                  orElse: () => BookImages(imageUrl: ''), // Ensure fallback
                );

                if (profileImage.imageUrl!.isNotEmpty) {
                  filterImage = profileImage.imageUrl;
                }
                return Container(
                  width: size.width,
                  child: MyBookWidget(
                    title: book.book?.bookInfo?.title ?? '',
                    image: filterImage != null
                        ? "${BaseUrl.imageDisplay}/$filterImage"
                        : '',
                    checkIn: book.checkInDate != null
                        ? parseDate(book.checkInDate.toString())
                        : '',
                    due: book.dueDate != null
                        ? parseDate(book.dueDate.toString())
                        : '',
                    id: book.issueId ?? '',
                    status: book.book?.status ?? '',
                    onTap: () async {},
                  ),
                );
              },
              options: CarouselOptions(
                height: 115,
                autoPlay: books.length > 1,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 1.0, // Full width for each slide
                enableInfiniteScroll: books.length > 1,
                pauseAutoPlayOnTouch: true,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRequestBookSection(Size size) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Request Book',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'poppins',
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            _buildFilterButton(
              'View',
              () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const BookRequestScreen(),
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
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const BookRequestBottomSheet(),
          ),
          child: Container(
            width: size.width * 0.9,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary,
                width: 1.5,
                style: BorderStyle.solid,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.book, color: AppColors.primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Request a Book',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'poppins',
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Request any book of your choice!',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'poppins',
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReservationsSection(Size size) {
    return Consumer<ReservationViewModel>(
      builder: (context, value, child) {
        final reservations = value.reservationList;
        final confirmReservation = value.confirmReservation;
        if (reservations.isEmpty && confirmReservation.isEmpty) {
          return SizedBox(
            height: 60,
            child: _buildNoDataCard(size, 'No Books Currently Reading'),
          );
        }
        if (reservations.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              if (confirmReservation.isNotEmpty)
                const Column(
                  children: [
                    ConfirmReservationList(),
                  ],
                ),
              Align(
                alignment: Alignment.center,
                child: _buildFilterButton(
                  'View all Reservations',
                  () => Navigator.of(context).push(
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
                  ),
                ),
              ),
            ],
          );
        }

        // If there are pending reservations
        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8),
              child: ReservationList(), // Assumes default shows pending
            ),
            Align(
              alignment: Alignment.center,
              child: _buildFilterButton(
                'View all Reservations',
                () => Navigator.of(context).push(
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
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPaymentSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Payment History',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            _buildFilterButton(
              'View All',
                  () => Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                  const Payment(),
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
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: Consumer<PaymentViewModel>(
            builder: (context, value, child) {
              final payments = value.paymentList.take(2).toList(); // Limit to 2 items
              if (payments.isEmpty) {
                return _buildNoDataCard(size, 'No Payment History');
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 8, right: 8),
                itemCount: payments.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Container(
                      width: size.width * 0.42,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade600, Colors.blue.shade400],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  payment.paymentType ?? 'Unknown',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Icon(
                                  Icons.receipt_long,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 20,
                                ),
                              ],
                            ),
                            Text(
                              "Rs. ${payment.amountPaid}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              parseDate(payment.createdAt.toString()),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNoDataCard(Size size, String message) {
    return Container(
      width: size.width * 0.9,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey[400]!, width: 0.5),
      ),
      alignment: Alignment.center,
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildImageSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }

  Widget _buildFilterButton(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
