import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/screens/student/book_info/reply_comments.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../view_model/books/comment_view_model.dart';
import '../../../widgets/book/review_card.dart';
import '../../../widgets/book/review_skeleton.dart';
import '../../../widgets/form_widget/custom_comment.dart';

class Comments extends StatefulWidget {
  final String uid;
  const Comments({super.key, required this.uid});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  int index = 0;
  String comment = "";
  bool isLoading = false;
  late ScrollController _scrollController;
  bool isLoad = false;
  String message = '';
  final TextEditingController _commentController =
      TextEditingController(); // Added

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        !isLoad) {
      loadMore();
    }
  }

  Future<void> loadMore() async {
    if (isLoad) return;
    setState(() => isLoad = true);
    try {
      await Provider.of<CommentViewModel>(context, listen: false)
          .loadMore(widget.uid, context);
    } catch (e) {
      if (kDebugMode) print("Error loading more books: $e");
    } finally {
      setState(() => isLoad = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reviews",
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Write Your Review',
                    style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              CustomCommentField(
                hintText: 'Write a comment...',
                outlinedColor: Colors.grey,
                focusedColor: AppColors.primary,
                width: size.width,
                maxLines: 5,
                textController: _commentController, // Controller added
                onChanged: (e) {
                  setState(() {
                    comment = e;
                  });
                },
                suffixicon: comment.isNotEmpty
                    ? InkWell(
                        child: Icon(Icons.clear, color: Colors.grey),
                        onTap: () {
                          setState(() {
                            comment = "";
                            _commentController.clear(); // Clears the input
                          });
                        },
                      )
                    : null,
                text: 'Write a comment',
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: buildFilterButton('Send', () async {
                  if (comment.trim().isEmpty) return;
                  setState(() => isLoading = true);
                  try {
                    final check = await Provider.of<CommentViewModel>(
                      context,
                      listen: false,
                    ).postComment(widget.uid, {'comment': comment}, context);

                    if (check) {
                      await Provider.of<CommentViewModel>(context,
                              listen: false)
                          .fetchComments(widget.uid, context);
                      setState(() {
                        comment = "";
                        _commentController.clear(); // Clear input after sending
                      });
                    }
                  } catch (e) {
                    if (kDebugMode) print("Error posting comment: $e");
                  } finally {
                    setState(() => isLoading = false);
                  }
                }, Colors.red, 13),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer<CommentViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoading) return const ReviewCardSkeleton();
                    if (viewModel.commentsList.isEmpty) {
                      return const Center(
                        child: Text(
                          'No reviews',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount:
                          viewModel.commentsList.length + (isLoad ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == viewModel.commentsList.length) {
                          return Center(
                            child: LoadingAnimationWidget.twistingDots(
                              leftDotColor: Colors.red,
                              rightDotColor: AppColors.primary,
                              size: 40,
                            ),
                          );
                        }

                        final commentData = viewModel.commentsList[index];
                        int length=commentData.replies!.length;
                        return Column(
                          children: [
                            ReviewCard(
                              image: commentData.user?.profilePicUrl != null
                                  ? "${BaseUrl.imageDisplay}/${commentData.user!.profilePicUrl}"
                                  : '',
                              rating:
                                  commentData.user?.ratings?.isNotEmpty == true
                                      ? (commentData.user!.ratings![0].rating
                                              as int)
                                          .toDouble()
                                      : 0,
                              onTap: () {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                        secondaryAnimation) =>
                                        ReplyComments(
                                          uid:widget.uid,
                                          commentId:commentData.commentId??'' ,
                                          name: commentData.user?.fullName ?? '',
                                          image: commentData
                                              .user?.profilePicUrl !=
                                              null
                                              ? "${BaseUrl.imageDisplay}/${commentData.user?.profilePicUrl.toString()}"
                                              : '',
                                          rating: commentData
                                              .user!.ratings!.isNotEmpty
                                              ? (commentData.user!.ratings![0]
                                              .rating as int)
                                              .toDouble()
                                              : 0,
                                          text: commentData.comment ?? '',
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
                              name: commentData.user?.fullName ?? '',
                              text: commentData.comment ?? '',
                              length: length,
                            ),
                            const SizedBox(height: 5),
                          ],
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
