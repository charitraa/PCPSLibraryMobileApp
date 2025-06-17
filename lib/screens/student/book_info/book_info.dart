import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/constant/base_url.dart';
import 'package:library_management_sys/model/books_model.dart';
import 'package:library_management_sys/screens/student/book_info/book_preview.dart';
import 'package:library_management_sys/screens/student/book_info/comments.dart';
import 'package:library_management_sys/screens/student/book_info/reply_comments.dart';
import 'package:library_management_sys/screens/student/book_info/review.dart';
import 'package:library_management_sys/screens/student_nav.dart';
import 'package:library_management_sys/view_model/books/book_view_model.dart';
import 'package:library_management_sys/view_model/books/comment_view_model.dart';
import 'package:library_management_sys/widgets/book/book_info_column.dart';
import 'package:library_management_sys/widgets/book/book_info_row.dart';
import 'package:library_management_sys/widgets/book/review_card.dart';
import 'package:library_management_sys/widgets/book/review_skeleton.dart';
import 'package:provider/provider.dart';
import '../../../data/response/status.dart';
import '../../../resource/colors.dart';
import '../../../utils/parse_date.dart';
import '../../../widgets/form_widget/custom_comment.dart';
import '../../../widgets/form_widget/modern_btn_widget.dart';
import 'package:shimmer/shimmer.dart';

class BookInfo extends StatefulWidget {
  final double? score;
  final BooksModel books;
  final String uid, author, genre, isbn, image;
  const BookInfo({
    super.key,
    required this.author,
    required this.uid,
    this.score,
    required this.books,
    required this.genre,
    required this.isbn,
    required this.image,
  });

  @override
  State<BookInfo> createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  bool _isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  String comment = "";
  final CarouselSliderController carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      await Future.wait([
        Provider.of<BooksViewModel>(context, listen: false)
            .getIndividualBooks(widget.uid, context),
        Provider.of<CommentViewModel>(context, listen: false)
            .fetchComments(widget.uid, context),
      ]);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Book Info",
          style: TextStyle(fontFamily: 'poppins-black', color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 40,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    width: 40,
                    height: 80,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => _buildImageSkeleton(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ModernButton(
                  text: "Rate Now",
                  color: Colors.green,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      backgroundColor: Colors.white,
                      builder: (context) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: FractionallySizedBox(
                          heightFactor: 0.5,
                          child: AddReview(
                            uid: widget.uid,
                            name: widget.books.title ?? '',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ModernButton(
                  text: "Reserve Book",
                  color: AppColors.primary,
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    try {
                      final check = await Provider.of<BooksViewModel>(context,
                              listen: false)
                          .reserve(widget.books.bookInfoId ?? '', context);
                      if (check) {
                        await Future.wait([
                          Provider.of<BooksViewModel>(context, listen: false)
                              .getIndividualBooks(widget.uid, context),
                          Provider.of<BooksViewModel>(context, listen: false)
                              .fetchBooksList(context),
                        ]);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StudentNavBar(index: 0),
                          ),
                        );
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    } finally {
                      setState(() => _isLoading = false);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? _buildSkeletonLoader(size)
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(20),
                width: size.width,
                height: size.height,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 290,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: widget.image,
                                width: 200,
                                height: 290,
                                fit: BoxFit.contain,
                                placeholder: (context, url) =>
                                    _buildImageSkeleton(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        widget.books.title ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Consumer<BooksViewModel>(
                        builder: (context, viewModel, child) {
                          final user = viewModel.currentUser;
                          if (user == null) {
                            return const Center(
                                child: Text("No rating available"));
                          }

                          return Column(
                            children: [
                              if (user.score?.score == null ||
                                  user.score?.score == 0)
                                const Row(
                                  children: [
                                    Text(
                                      "No rating available",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.arrow_forward_ios_sharp,
                                        size: 13),
                                  ],
                                )
                              else
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ...List.generate(
                                      user.score?.score ?? user.score!.score!,
                                      (index) => const Icon(Icons.star,
                                          color: Colors.amber, size: 16),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      user.score!.score.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.author,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildFilterButton('Rate Now', () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              backgroundColor: Colors.white,
                              builder: (context) => GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => FocusScope.of(context).unfocus(),
                                child: FractionallySizedBox(
                                  heightFactor: 0.5,
                                  child: AddReview(
                                    uid: widget.uid,
                                    name: widget.books.title ?? '',
                                  ),
                                ),
                              ),
                            );
                          }, Colors.green, 15),
                          const SizedBox(width: 5),
                          buildFilterButton('Reserve', () async {
                            setState(() => _isLoading = true);
                            try {
                              final check = await Provider.of<BooksViewModel>(
                                      context,
                                      listen: false)
                                  .reserve(widget.uid, context);
                              if (check) {
                                await Future.wait([
                                  Provider.of<BooksViewModel>(context,
                                          listen: false)
                                      .getIndividualBooks(widget.uid, context),
                                  Provider.of<BooksViewModel>(context,
                                          listen: false)
                                      .fetchBooksList(context),
                                ]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentNavBar(index: 0),
                                  ),
                                );
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }, AppColors.primary, 15),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: size.width,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BookInfoColumn(
                                title: 'Edition',
                                value: widget.books.editionStatement ?? '',
                              ),
                              BookInfoColumn(
                                title: 'Publication Year',
                                value:
                                    widget.books.publicationYear.toString() ??
                                        '',
                              ),
                              BookInfoColumn(
                                title: 'Pages',
                                value:
                                    widget.books.numberOfPages.toString() ?? '',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Details',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: size.width,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'Title',
                                      value: widget.books.title ?? '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'Sub Title',
                                      value: widget.books.subTitle ?? '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'Book Number',
                                      value: widget.books.classNumber ?? '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'Class Number',
                                      value: widget.books.classNumber ?? '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'Series',
                                      value: widget.books.seriesStatement ?? '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'Publication',
                                      value: widget
                                              .books.publisher?.publisherName ??
                                          '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'Publication Date',
                                      value: widget.books.publicationYear
                                              .toString() ??
                                          '',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'Genre',
                                      value: widget.genre,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Flexible(
                                    child: BookInfoRow(
                                      title: 'ISBN',
                                      value: widget.isbn,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Consumer<BooksViewModel>(
                                builder: (context, viewModel, child) {
                                  final user = viewModel.currentUser;
                                  if (user == null) {
                                    return const SizedBox();
                                  }

                                  String totalBooks =
                                      user.total.toString() ?? 'N/A';
                                  String available = (user.available != null &&
                                          user.available != 0)
                                      ? "${user.available} available"
                                      : "All Reserved";

                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: BookInfoRow(
                                              title: 'Total Copies',
                                              value: totalBooks,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: const Text(
                                              "Availability",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                          buildFilterButton(available, () {},
                                              Colors.green, 12),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: const Text(
                                              "Referenced Book",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              softWrap: true,
                                            ),
                                          ),
                                          buildFilterButton(
                                            user.reference.toString() ?? '',
                                            () {},
                                            Colors.green,
                                            12,
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      Consumer<BooksViewModel>(
                        builder: (context, viewModel, child) {
                          final user = viewModel.currentUser;
                          if (user == null ||
                              user.bookImages == null ||
                              user.bookImages!.isEmpty) {
                            return const SizedBox(
                              height: 100,
                              child: Center(
                                child: Text(
                                  'No images available',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ),
                            );
                          }

                          return Container(
                            height: 100,
                            width: size.width,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CarouselSlider.builder(
                                  carouselController: carouselController,
                                  itemCount: user.bookImages!.length,
                                  itemBuilder: (context, index, realIndex) {
                                    final bookImage = user.bookImages![index];
                                    final imageUrl =
                                        "${BaseUrl.imageDisplay}/${bookImage.imageUrl}";
                                    final heroTag =
                                        'book_image_${bookImage.bookImageId}_$index';
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                  secondaryAnimation) =>
                                                  BookPreview(
                                                      imageUrl: imageUrl,
                                                    ),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: heroTag,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey.shade300,
                                                  width: 1),
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                width: 70,
                                                height: 90,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    _buildImageSkeleton(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                const Icon(
                                                    Icons.broken_image,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  options: CarouselOptions(
                                    height: 90,
                                    autoPlay: user.bookImages!.length > 1,
                                    autoPlayInterval:
                                    const Duration(seconds: 1),
                                    autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                    viewportFraction: 0.22,
                                    enableInfiniteScroll:
                                    user.bookImages!.length > 1,
                                    pauseAutoPlayOnTouch: true,
                                    enlargeCenterPage: true,
                                    enlargeFactor: 0.2,
                                  ),
                                ),
                                if (user.bookImages!.length > 1)
                                  Positioned(
                                    left: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_left,
                                          color: Colors.grey.shade600,
                                          size: 30),
                                      onPressed: () {
                                        carouselController.previousPage(
                                          duration:
                                          const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                                if (user.bookImages!.length > 1)
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_right,
                                          color: Colors.grey.shade600,
                                          size: 30),
                                      onPressed: () {
                                        carouselController.nextPage(
                                          duration:
                                          const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Ratings & Reviews",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Consumer<BooksViewModel>(
                            builder: (context, viewModel, child) {
                              final user = viewModel.currentUser;
                              if (user == null) {
                                return const Center(
                                    child: Text("No rating available"));
                              }

                              return Column(
                                children: [
                                  if (user.score?.score == null ||
                                      user.score?.score == 0)
                                    const Row(
                                      children: [
                                        Text(
                                          "No rating available",
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(Icons.arrow_forward_ios_sharp,
                                            size: 13),
                                      ],
                                    )
                                  else
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ...List.generate(
                                          user.score?.score ??
                                              user.score!.score!,
                                          (index) => const Icon(Icons.star,
                                              color: Colors.amber, size: 16),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          user.score!.score.toString(),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 13),
                                      ],
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomCommentField(
                        hintText: 'Write a comment...',
                        outlinedColor: Colors.grey,
                        focusedColor: AppColors.primary,
                        width: size.width,
                        maxLines: 5,
                        textController: _commentController,
                        onChanged: (e) {
                          setState(() {
                            comment = e;
                          });
                        },
                        suffixicon: comment.isNotEmpty
                            ? InkWell(
                                child:
                                    const Icon(Icons.clear, color: Colors.grey),
                                onTap: () {
                                  setState(() {
                                    comment = "";
                                    _commentController.clear();
                                  });
                                },
                              )
                            : null,
                        text: 'Write a comment',
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buildFilterButton('Send', () async {
                            setState(() => _isLoading = true);
                            try {
                              final check = await Provider.of<CommentViewModel>(
                                      context,
                                      listen: false)
                                  .postComment(widget.uid, {'comment': comment},
                                      context);
                              if (check) {
                                await Provider.of<CommentViewModel>(context,
                                        listen: false)
                                    .fetchComments(widget.uid, context);
                              }
                            } catch (e) {
                              debugPrint(e.toString());
                            } finally {
                              setState(() => _isLoading = false);
                            }
                          }, Colors.red, 16),
                        ],
                      ),
                      Consumer<CommentViewModel>(
                        builder: (context, viewModel, child) {
                          int itemCount = viewModel.commentsList.length >= 2
                              ? 2
                              : viewModel.commentsList.length;

                          if (viewModel.isLoading) {
                            return const ReviewCardSkeleton();
                          } else if (viewModel.commentsList.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'No reviews',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              final completionData =
                                  viewModel.commentsList[index];
                              final commentData = viewModel.commentsList[index];
                              int length = commentData.replies!.length;
                              return ReviewCard(
                                onEdit: () {
                                  _showEditCommentDialog(
                                    context,
                                    commentData.comment ?? '',
                                    commentData.commentId ?? '',
                                    viewModel,
                                  );
                                },
                                onDelete: () async {
                                  final check = await viewModel.deleteComment(
                                    commentData.commentId ?? '',
                                    context,
                                  );
                                  if (check) {
                                    await viewModel.fetchComments(
                                        widget.uid ?? '', context);
                                  }
                                },
                                uid: commentData.userId,
                                date: commentData.updatedAt != null
                                    ? parseDate(
                                        commentData.updatedAt.toString())
                                    : "",
                                image: completionData.user?.profilePicUrl !=
                                        null
                                    ? "${BaseUrl.imageDisplay}/${completionData.user?.profilePicUrl.toString()}"
                                    : '',
                                rating: completionData.user!.ratings!.isNotEmpty
                                    ? (completionData.user!.ratings![0].rating
                                            as int)
                                        .toDouble()
                                    : 0,
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          ReplyComments(
                                        uid: widget.uid,
                                        replies: completionData.replies,
                                        date: completionData.createdAt != null
                                            ? parseDate(completionData.createdAt
                                                .toString())
                                            : '',
                                        commentId:
                                            completionData.commentId ?? '',
                                        name:
                                            completionData.user?.fullName ?? '',
                                        image: completionData
                                                    .user?.profilePicUrl !=
                                                null
                                            ? "${BaseUrl.imageDisplay}/${completionData.user?.profilePicUrl.toString()}"
                                            : '',
                                        rating: completionData
                                                .user!.ratings!.isNotEmpty
                                            ? (completionData.user!.ratings![0]
                                                    .rating as int)
                                                .toDouble()
                                            : 0,
                                        text: completionData.comment ?? '',
                                        length: length,
                                      ),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        const begin = Offset(1.0, 0.0);
                                        const end = Offset.zero;
                                        const curve = Curves.easeInOut;
                                        var tween = Tween(
                                                begin: begin, end: end)
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
                                name: completionData.user?.fullName ?? '',
                                text: completionData.comment ?? '',
                                length: length,
                              );
                            },
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildFilterButton('View all Comments', () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        Comments(
                                  uid: widget.uid,
                                ),
                                transitionsBuilder:
                                    (context, animation, secondary, child) {
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
                        ],
                      ),
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
        child: Column(
          children: [
            Container(
              width: 200,
              height: 290,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            Container(
              width: size.width * 0.6,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: Colors.white,
            ),
            Container(
              width: size.width * 0.4,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: Colors.white,
            ),
            Container(
              width: size.width * 0.3,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 40,
                  margin: const EdgeInsets.all(8),
                  color: Colors.white,
                ),
                Container(
                  width: 100,
                  height: 40,
                  margin: const EdgeInsets.all(8),
                  color: Colors.white,
                ),
              ],
            ),
            Container(
              width: size.width * 0.9,
              height: 60,
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              width: size.width * 0.2,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              color: Colors.white,
            ),
            Container(
              width: size.width * 0.9,
              height: 200,
              margin: const EdgeInsets.all(8),
              color: Colors.white,
            ),
            const ReviewCardSkeleton(),
          ],
        ),
      ),
    );
  }
  void _showEditCommentDialog(
      BuildContext context,
      String initialComment,
      String commentId,
      CommentViewModel viewModel,

      ) {
    final TextEditingController _commentController = TextEditingController(text: initialComment);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Edit Comment',
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
                const SizedBox(height: 16),
                TextField(
                  controller: _commentController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter your comment',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedComment = _commentController.text.trim();
                      if (updatedComment.isNotEmpty) {
                        final check = await viewModel.updateComment(
                          commentId,
                          {"comment":updatedComment},
                          context,
                        );
                        if (check) {
                          await viewModel.fetchComments(widget.uid ?? '', context);
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildImageSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        color: Colors.white,
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
