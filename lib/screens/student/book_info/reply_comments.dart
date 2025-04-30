import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/model/book_info_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../constant/base_url.dart';
import '../../../resource/colors.dart';
import '../../../utils/parse_date.dart';
import '../../../view_model/books/comment_view_model.dart';
import '../../../widgets/book/replies_widget.dart';
import '../../../widgets/form_widget/custom_comment.dart';

class ReplyComments extends StatefulWidget {
  final String? name, image, text, uid,date, commentId;
  final List<dynamic>? replies;
  final double? rating;
  final int? length;
  const ReplyComments(
      {super.key,
      this.name,
      this.image,
      this.text,
      this.rating,
      this.length,
      this.uid,
      this.commentId, this.date, this.replies});

  @override
  State<ReplyComments> createState() => _ReplyCommentsState();
}

class _ReplyCommentsState extends State<ReplyComments> {
  bool isLoading = false;
  final TextEditingController _commentController = TextEditingController();
  String comment = "";
 
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.name ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (widget.rating == null || widget.rating == 0)
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ...List.generate(
                                      widget.rating!.toInt(),
                                      (index) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      widget.rating!.toString(),
                                      style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 5),
                           Text(
                            widget.date??'',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.text ?? '',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("${widget.length.toString()} replies",
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                              const SizedBox(
                                width: 8,
                              ),

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
                                setState(() {
                                  isLoading = true;
                                });
                                try {

                                  final check =
                                      await Provider.of<CommentViewModel>(
                                              context,
                                              listen: false)
                                          .replyComment(widget.commentId??'',
                                              {'reply': comment}, context);
                                  print(check);
                                  if (check) {
                                    await Provider.of<CommentViewModel>(context,
                                            listen: false)
                                        .fetchComments(
                                            widget.uid ?? '', context);

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
                          child: CachedNetworkImage(
                            imageUrl: widget.image ?? '',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error, size: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if(widget.replies!=null||widget.replies!=[])...[
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.replies!.length,
                    itemBuilder: (context, index) {
                      final replyData = widget.replies![index];

                      return RepliesWidget(
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
                  ),
                ),
              ]
            ],
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
