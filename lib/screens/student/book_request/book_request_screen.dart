import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/screens/student/book_request/book_request_widget.dart';
import 'package:library_management_sys/screens/student/book_request/edit_blood_request.dart';
import 'package:library_management_sys/screens/student/book_request/request_book.dart';
import 'package:library_management_sys/screens/student/my_wishlist/wishlist_skeleton.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:library_management_sys/view_model/book_requests/request_view_model.dart';
import 'package:provider/provider.dart';
import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';

class BookRequestScreen extends StatefulWidget {
  const BookRequestScreen({super.key});

  @override
  State<BookRequestScreen> createState() => _BookRequestScreenState();
}

class _BookRequestScreenState extends State<BookRequestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;
  late ScrollController _scrollController;
  bool isLoadMore = false;
  bool _canLoadMore = true;
  DateTime? _lastLoadTime;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    fetchData();
  }

  void fetchData() async {
    await Provider.of<BookRequestViewModel>(context, listen: false).fetchRequests(context);
    setState(() {
      _canLoadMore = true;
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 50 &&
        !_scrollController.position.outOfRange) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (isLoadMore ||
        !_canLoadMore ||
        _lastLoadTime != null &&
            DateTime.now().difference(_lastLoadTime!).inMilliseconds < 500) {
      return;
    }

    setState(() {
      isLoadMore = true;
      _lastLoadTime = DateTime.now();
    });

    try {
      final viewModel = Provider.of<BookRequestViewModel>(context, listen: false);
      final previousLength = viewModel.requestsList.length;
      await viewModel.loadMore(context);
      if (!mounted) return;

      if (viewModel.requestsList.length == previousLength) {
        setState(() {
          _canLoadMore = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading more books: $e");
      }
      if (mounted) {
        Utils.flushBarErrorMessage("Failed to load more requests", context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoadMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
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
          "Book Requests",
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
          SizedBox(width: 18),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primary,
                      width: 1.5,
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
                              fontSize: 14,
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
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildFilterButton("All", () => setState(() => _selectedTabIndex = 0), 0),
                    const SizedBox(width: 8),
                    buildFilterButton("Accepted", () => setState(() => _selectedTabIndex = 1), 1),
                    const SizedBox(width: 8),
                    buildFilterButton("Pending", () => setState(() => _selectedTabIndex = 2), 2),
                    const SizedBox(width: 8),
                    buildFilterButton("Resolved", () => setState(() => _selectedTabIndex = 3), 3),
                    const SizedBox(width: 8),
                    buildFilterButton("Rejected", () => setState(() => _selectedTabIndex = 4), 4),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Consumer<BookRequestViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoading && viewModel.requestsList.isEmpty) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [WishlistSkeleton()],
                      );
                    } else if (viewModel.requestsList.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.disabled_visible_rounded,
                                color: Colors.grey,
                                size: 48,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "No books found! Time to add some to your collection!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final filteredRequests = viewModel.requestsList.where((request) {
                      switch (_selectedTabIndex) {
                        case 1:
                          return request.status == "Accepted";
                        case 2:
                          return request.status == "Pending";
                        case 3:
                          return request.status == "Resolved";
                        case 4:
                          return request.status == "Rejected";
                        default:
                          return true;
                      }
                    }).toList();

                    if (filteredRequests.isEmpty) {
                      return const Center(
                        child: Text(
                          "No requests match the selected filter.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: filteredRequests.length + (isLoadMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredRequests.length && isLoadMore) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final reservationData = filteredRequests[index];
                        return BookRequestWidget(
                          reservationData: reservationData,
                          onDelete: () =>
                              _handleDelete(context, viewModel, reservationData.bookRequestId ?? ''),
                          onEdit: () => _handleEdit(context, viewModel, reservationData),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDelete(BuildContext context, BookRequestViewModel viewModel, String bookRequestId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this book request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      final check = await viewModel.delete(bookRequestId, context);
      if (!context.mounted) return;
      if (check) {
        Utils.flushBarSuccessMessage('Book Request Deleted Successfully!', context);
      }
    }
  }

  void _handleEdit(BuildContext context, BookRequestViewModel viewModel, dynamic reservationData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => EditBookRequestBottomSheet(
        reservationData: reservationData,
        onSuccess: () async{
          if (context.mounted) {
            Utils.flushBarSuccessMessage('Book Request Updated Successfully!', context);
            await Provider.of<BookRequestViewModel>(context, listen: false).fetchRequests(context);

          }
        },
      ),
    );
  }

  Widget buildFilterButton(String title, VoidCallback onTap, int tabIndex) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _selectedTabIndex == tabIndex ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: _selectedTabIndex == tabIndex ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}