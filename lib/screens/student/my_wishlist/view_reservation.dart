import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/constant/base_url.dart';
import 'package:library_management_sys/screens/student/book_info/comments.dart';
import 'package:library_management_sys/screens/student/book_info/reply_comments.dart';
import 'package:library_management_sys/screens/student/book_info/review.dart';
import 'package:library_management_sys/view_model/books/book_view_model.dart';
import 'package:library_management_sys/view_model/books/comment_view_model.dart';
import 'package:library_management_sys/view_model/reservations/reservation_view_model.dart';
import 'package:library_management_sys/widgets/book/book_info_column.dart';
import 'package:library_management_sys/widgets/book/book_info_row.dart';
import 'package:library_management_sys/widgets/book/review_card.dart';
import 'package:library_management_sys/widgets/book/review_skeleton.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../data/response/status.dart';
import '../../../resource/colors.dart';
import '../../../utils/parse_date.dart';
import '../../../widgets/form_widget/custom_comment.dart';
import '../../../widgets/form_widget/modern_btn_widget.dart';
import '../../student_nav.dart';

class ViewReservation extends StatefulWidget {
  final double? score;
  final String? author,genre,isbn,publisher,year;
  final String uid,
      bookName,
      subTitle,
      edition,
      pages,
      bookNo,
      classNo,
      series,
      image,reserveId,
      status;
  const ViewReservation(
      {super.key,
        required this.bookName,
         this.author,
        required this.edition,
         this.year,
         this.publisher,
        required this.pages,
        required this.bookNo,
        required this.classNo,
        required this.series,
         this.genre,
         this.isbn,
        required this.image,
        required this.status,
        required this.subTitle,
        required this.uid,
        this.score, required this.reserveId});

  @override
  State<ViewReservation> createState() => _ViewReservationState();
}

class _ViewReservationState extends State<ViewReservation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIndividualData();
  }

  bool isLoading = false;
  String comment = "";
  void getIndividualData() async {
    await Provider.of<BooksViewModel>(context, listen: false)
        .getIndividualBooks(widget.uid, context);
    await Provider.of<CommentViewModel>(context, listen: false)
        .fetchComments(widget.uid, context);
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
          SizedBox(
            width: 18,
          )
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
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
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
                        onTap: () => FocusScope.of(context)
                            .unfocus(), // Hides keyboard when tapping outside input fields
                        child: FractionallySizedBox(
                          heightFactor: 0.5, // Covers half the screen
                          child: AddReview(uid: widget.uid, name: widget.bookName,),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ModernButton(
                  text: "Cancel",
                  color: Colors.red,
                  onPressed: () async {
                    setState(() => isLoading = true);
                    try {
                      final check = await Provider.of<ReservationViewModel>(context,
                          listen: false)
                          .cancel(widget.reserveId, context);
                      if (check) {

                        await Provider.of<ReservationViewModel>(context,
                            listen: false)
                            .fetchReservation(context);
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    } finally {
                      setState(() => isLoading = false);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: Colors.red,
          rightDotColor: AppColors.primary,
          size: 40,
        ),
      )
          : SafeArea(
          child: Container(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
              child:
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: AppColors.primary,
                    width: size.width,
                    child: const Text('This book is reserved under your name!',textAlign: TextAlign.center,style: TextStyle(color: Colors.white,fontSize: 12),),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(20),
                    
                    child: Column(
                      children: [
                        Consumer<BooksViewModel>(
                          builder: (context, viewModel, child) {
                            if (viewModel.booksData.status ==
                                Status.LOADING) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            final user = viewModel.currentUser;
                            if (user == null) {
                              return const Center(
                                  child: Text("User data not available"));
                            }String authors = "By ";
                            List<String> authorNames =
                            user.bookAuthors!.map((bookAuthor) {
                              return bookAuthor.author!.fullName ?? '';
                            }).toList();
                            authors += authorNames.join(", ");
                    
                            String genres = "";
                            List<String> genresMap =
                            user.bookGenres!.map((bookGenres) {
                              return bookGenres.genre!.genre ?? '';
                            }).toList();
                            genres += genresMap.join(", ");
                    
                            String isbn = "";
                            List<String> isbnMap = user.isbns!.map((isbn) {
                              return isbn.isbn ?? '';
                            }).toList();
                            isbn += isbnMap.join(", ");
                            String totalBooks =
                                user.total.toString() ?? 'N/A';
                            String available = (user.available != null &&
                                user.available != 0)
                                ? "${user.available} available"
                                : "All Reserved";
                          double  score=   user.score != null? (user.score?.score as int).toDouble():0;
                            return   Column(
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
                                        borderRadius: BorderRadius.circular(
                                            8), // Apply border radius here
                                        child: CachedNetworkImage(
                                          imageUrl: widget.image,
                                          width: 200,
                                          height: 290,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Text(
                                  widget.bookName,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                if (score == null || score == 0)
                                  const Text(
                                    "No rating available",
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                else
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ...List.generate(
                                        score.toInt(),
                                            (index) =>
                                        const Icon(Icons.star, color: Colors.amber),
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text(
                                        score.toString(),
                                        style: const TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                 authors,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildFilterButton('Rate Now', ()async{
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
                                          onTap: () => FocusScope.of(context)
                                              .unfocus(), // Hides keyboard when tapping outside input fields
                                          child: FractionallySizedBox(
                                            heightFactor: 0.5, // Covers half the screen
                                            child: AddReview(uid: widget.uid, name: widget.bookName,),
                                          ),
                                        ),
                                      );
                                    }, Colors.green, 12),
                                    SizedBox(width: 5,),
                                    buildFilterButton('Cancel',  () async {
                                      setState(() => isLoading = true);
                                      try {
                                        final check = await Provider.of<ReservationViewModel>(context,
                                            listen: false)
                                            .cancel(widget.reserveId, context);
                                        if (check) {

                                          await Provider.of<ReservationViewModel>(context,
                                              listen: false)
                                              .fetchReservation(context);
                                        }
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      } finally {
                                        setState(() => isLoading = false);
                                      }
                                    },Colors.red, 12)
                    
                                  ],),
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
                                            value: widget.edition,
                                          ),
                                          BookInfoColumn(
                                            title: 'Publication Year',
                                            value: widget.year??'',
                                          ),
                                          BookInfoColumn(
                                            title: 'Pages',
                                            value: widget.pages,
                                          )
                                        ],
                                      )),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
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
                                            fontSize: 16),
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
                                                value: widget.bookName,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: BookInfoRow(
                                                  title: 'Sub Title',
                                                  value: widget.subTitle),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: BookInfoRow(
                                                title: 'Book Number',
                                                value: widget.bookNo,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: BookInfoRow(
                                                title: 'Class Number',
                                                value: widget.classNo,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: BookInfoRow(
                                                title: 'Series',
                                                value: widget.series,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: BookInfoRow(
                                                title: 'Publication',
                                                value:  user.publisher!.publisherName ??
                                                    '',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: BookInfoRow(
                                                title: 'Publication Date',
                                                value:user.publicationYear.toString() ??
                                                    '',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: BookInfoRow(
                                                title: 'Genre',
                                                value: genres,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: BookInfoRow(
                                                title: 'ISBN',
                                                value: isbn,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                    
                                        Column(
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
                                                buildFilterButton(
                                                    available, () {}, Colors.green, 12)
                                              ],
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(),
                                const SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ratings & Reviews",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (   score == null ||    score== 0)
                                      const Row(
                                        children: [
                                          Text(
                                            "No rating available",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 13,
                                          )
                                        ],
                                      )
                                    else
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          ...List.generate(
                                           score.toInt(),
                                                (index) => const Icon(Icons.star,
                                                color: Colors.amber, size: 16),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                           score.toString(),
                                            style: const TextStyle(
                                                fontSize: 12, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios_sharp,
                                            size: 13,
                                          )
                                        ],
                                      ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                    
                    
                              ],
                            );
                          },
                        ),
                        CustomCommentField(
                            hintText: 'Write a comment...',
                            outlinedColor: Colors.grey,
                            focusedColor: AppColors.primary,
                            width: size.width,
                            maxLines: 5,
                            onChanged: (e) {
                              setState(() {
                                comment = e;
                              });
                            },
                            text: 'Write a comment'),
                        const SizedBox(
                          height: 5,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            buildFilterButton('Send', () async {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                final check = await Provider.of<CommentViewModel>(
                                    context,
                                    listen: false)
                                    .postComment(
                                    widget.uid, {'comment': comment}, context);
                                if (check) {
                                  await Provider.of<CommentViewModel>(context,
                                      listen: false)
                                      .fetchComments(widget.uid, context);
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }, Colors.red, 12)
                          ],
                        ),
                        Consumer<CommentViewModel>(
                          builder: (context, viewModel, child) {
                            int itemCount = viewModel.commentsList.length >= 2 ? 2 : viewModel.commentsList.length;
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
                                  date: commentData.updatedAt!=null ?parseDate(commentData.updatedAt.toString()): "",
                                  image: completionData.user?.profilePicUrl != null
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
                                              commentId: completionData.commentId ?? '',
                                              name: completionData.user?.fullName ?? '',
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
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
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
