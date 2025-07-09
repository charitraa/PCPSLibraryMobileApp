import 'package:flutter/material.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/widgets/Dialog/alert.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../resource/colors.dart';
import '../custom_shimmer_effect.dart';

class ReviewCard extends StatefulWidget {
  final String? image, name, text, date, uid;
  final double? rating;
  final VoidCallback? onTap, onEdit, onDelete;
  final int? length;
  const ReviewCard({
    super.key,
    required this.image,
    required this.name,
    required this.text,
    this.rating,
    this.length,
    this.onTap,
    this.date,
    this.onDelete,
    this.uid,
    this.onEdit,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: widget.onTap,
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
                            const SizedBox(width: 5),
                            Text(
                              widget.rating!.toString(),
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.date ?? "",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                      Text(
                        "${widget.length.toString()} replies",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: widget.onTap,
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              const Text('Reply'),
                              const SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.mark_unread_chat_alt_sharp,
                                color: AppColors.primary,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Consumer<AuthViewModel>(
                        builder: (context, viewModel, child) {
                          final user = viewModel.currentUser;
                          var logger = Logger();
                          logger.d("${widget.uid} :${user?.data?.userId}");
                          if (user?.data?.userId == widget.uid) {
                            return Row(
                              children: [
                                InkWell(
                                  onTap: widget.onEdit,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                InkWell(
                                  onTap: () async {
                                    final bool? confirm =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (context) => Alert(
                                        icon: Icons.reviews,
                                        iconColor: AppColors.primary,
                                        title: 'Remove Review',
                                        content:
                                            'Do you want to delete this review?',
                                        buttonText: 'Yes, Delete',
                                      ),
                                    );
                                    if (confirm != true) return;
                                    widget.onDelete?.call();
                                    // Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
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
                  child: Image.network(
                    widget.image ?? '',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return CustomShimmerLoading(
                        radius: 18,
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                      );
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
