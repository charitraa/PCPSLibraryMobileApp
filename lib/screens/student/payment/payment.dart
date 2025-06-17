import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../resource/colors.dart';
import '../../../view_model/users/my_pay_view_model.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late ScrollController _scrollController;
  bool isLoadMore = false;
  String message = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        message = "Reached the top";
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      isLoadMore = true;
    });
    try {
      await Provider.of<PaymentViewModel>(context, listen: false)
          .loadMorePayments(context);
    } catch (e) {
      if (kDebugMode) {
        print("Error loading more payments: $e");
      }
      setState(() {
        message = "Failed to load more payments";
      });
    } finally {
      setState(() {
        isLoadMore = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Receipts",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),leading: IconButton(
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
          SizedBox(width: 18),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Consumer<PaymentViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoading && viewModel.paymentList.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final payments = viewModel.paymentList;
                    if (payments.isEmpty) {
                      return _buildNoDataCard(size, 'No Payment History Available');
                    }
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      itemCount: payments.length + (isLoadMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == payments.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final payment = payments[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            width: size.width,
                            height: 100,
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
                                      Flexible(
                                        child: Text(
                                          payment.paymentType ?? 'Unknown',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    _formatDate(payment.createdAt),
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
              if (message.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataCard(Size size, String message) {
    return Container(
      width: size.width,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.disabled_visible_rounded,
            color: Colors.grey.shade600,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null) return 'N/A';
    try {
      final parsedDate = DateTime.parse(date);
      return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
    } catch (e) {
      return 'N/A';
    }
  }
}