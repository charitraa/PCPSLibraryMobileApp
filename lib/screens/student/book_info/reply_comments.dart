import 'package:flutter/material.dart';
import 'package:library_management_sys/model/comment_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../utils/parse_date.dart';
import '../../../view_model/books/comment_view_model.dart';
import '../../../widgets/book/replies_widget.dart';
import '../../../widgets/form_widget/custom_comment.dart';

class ReplyComments extends StatefulWidget {
  final String? name, image, text, uid, date, commentId;
  final List<Replies>? replies;
  final double? rating;
  final int? length;
  const ReplyComments({
    super.key,
    this.name,
    this.image,
    this.text,
    this.rating,
    this.length,
    this.uid,
    this.commentId,
    this.date,
    this.replies,
  });

  @override
  State<ReplyComments> createState() => _ReplyCommentsState();
}

class _ReplyCommentsState extends State<ReplyComments> {
  bool isLoading = false;
  final TextEditingController _commentController = TextEditingController();
  String comment = "";

  @override
  void initState() {
    super.initState();
    // Fetch comments after the frame is built to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchComments();
    });
  }

  // Helper method to fetch comments
  Future<void> _fetchComments() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      await Provider.of<CommentViewModel>(context, listen: false)
          .fetchComments(widget.uid ?? '', context);
    } catch (e) {
      debugPrint("Error fetching comments: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
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
      body: isLoading
          ? Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: Colors.red,
          rightDotColor: AppColors.primary,
          size: 40,
        ),
      )
          : Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.name ?? 'Unknown User',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (widget.rating == null ||
                                widget.rating == 0)
                              const Text(
                                "No rating available",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            else
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  ...List.generate(
                                    widget.rating!.toInt(),
                                        (index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.rating!.toString(),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.date ?? 'No date available',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.text ?? 'No comment text',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${widget.length ?? 0} replies",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomCommentField(
                          hintText: 'Drop your reply',
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
                            child: const Icon(Icons.clear,
                                color: Colors.grey),
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
                            buildFilterButton('Reply', () async {
                              if (comment.trim().isEmpty) return;
                              setState(() => isLoading = true);
                              try {
                                final check =
                                await Provider.of<CommentViewModel>(
                                    context,
                                    listen: false)
                                    .replyComment(
                                    widget.commentId ?? '',
                                    {'reply': comment},
                                    context);
                                if (check) {
                                  // Refresh comments after posting reply
                                  await _fetchComments();
                                  setState(() {
                                    comment = "";
                                    _commentController.clear();
                                  });
                                }
                              } catch (e) {
                                debugPrint("Error replying: $e");
                              } finally {
                                if (mounted) {
                                  setState(() => isLoading = false);
                                }
                              }
                            }, Colors.red, 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: -15,
                    left: -10,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey[300],
                      child: ClipOval(
                        child:widget.image!=''||widget.image !=''? Image.network(
                          widget.image ?? '',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, size: 24);
                          },
                        ):const Icon(Icons.error, color:Colors.red ,size: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<CommentViewModel>(
                builder: (context, viewModel, child) {
                  // Find the comment with the matching commentId
                  final comment = viewModel.commentsList.firstWhere(
                        (c) => c.commentId == widget.commentId,
                    orElse: () => CommentModel(replies: []),
                  );
                  final replies = comment.replies ?? [];

                  if (replies.isEmpty) {
                    return const Center(
                      child: Text(
                        'No replies yet',
                        style:
                        TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      final replyData = replies[index];
                      return RepliesWidget(
                        onEdit: () => _showEditCommentDialog(
                          context,
                          replyData.reply ?? '',
                          replyData.commentReplyId ?? '',
                          viewModel,
                        ),
                        onDelete: () async {
                          setState(() => isLoading = true);
                          try {
                            final check = await viewModel.deleteReply(
                                replyData.commentReplyId ?? '', context);
                            if (check) {
                              // Refresh comments after deleting reply
                              await _fetchComments();
                            }
                          } catch (e) {
                            debugPrint("Error deleting reply: $e");
                          } finally {
                            if (mounted) {
                              setState(() => isLoading = false);
                            }
                          }
                        },
                        uid: replyData.user?.userId ?? '',
                        date: replyData.updatedAt != null
                            ? parseDate(replyData.updatedAt.toString())
                            : "",
                        image: replyData.user?.profilePicUrl != null
                            ? "${BaseUrl.imageDisplay}/${replyData.user?.profilePicUrl}"
                            : '',
                        name: replyData.user?.fullName ?? '',
                        text: replyData.reply ?? '',
                      );
                    },
                  );
                },
              ),
            ),
          ],
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

  void _showEditCommentDialog(
      BuildContext context,
      String initialComment,
      String commentId,
      CommentViewModel viewModel,
      ) {
    final TextEditingController _commentController =
    TextEditingController(text: initialComment);
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
                      'Edit Reply',
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
                    hintText: 'Enter your reply',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                      const BorderSide(color: Colors.blue, width: 1.5),
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
                        setState(() => isLoading = true);
                        try {
                          final check = await viewModel.updateReply(
                            commentId,
                            {"reply": updatedComment},
                            context,
                          );
                          if (check) {
                            // Refresh comments after updating reply
                            await _fetchComments();
                            Navigator.of(context).pop();
                          }
                        } catch (e) {
                          debugPrint("Error updating reply: $e");
                        } finally {
                          if (mounted) {
                            setState(() => isLoading = false);
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
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
}