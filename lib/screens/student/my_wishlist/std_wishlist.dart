import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_management_sys/screens/student/dashboard/cancel_reservation_list.dart';
import 'package:library_management_sys/screens/student/dashboard/confirm_reserved_list.dart';
import 'package:library_management_sys/screens/student/dashboard/reservation_list.dart';
import '../../../resource/colors.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false, // Set to true if more tabs are added
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey.shade600,
          labelStyle: const TextStyle(
            fontFamily: 'poppins-medium',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'poppins-regular',
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              color: AppColors.primary,
              width: 3,
            ),
          ),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
          onTap: (index) {
            HapticFeedback.lightImpact(); // Haptic feedback on tap
          },
          tabs: const [
            Tab(
              text: 'Pending',
            ),
            Tab(
              text: 'Confirmed',
            ),
            Tab(
              text: 'Cancelled',
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: Image(
              image: AssetImage('assets/images/pcpsLogo.png'),
              width: 56,
              height: 24,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            // Pending Tab
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ReservationList(),
            ),
            // Confirmed Tab
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ConfirmReservationList(),
            ),
            // Cancelled Tab
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CancelReservationList(),
            ),


          ],
        ),
      ),
    );
  }
}