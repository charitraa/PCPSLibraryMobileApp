import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/widgets/Dialog/alert.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../custom_shimmer_effect.dart';

class RepliesWidget extends StatelessWidget {
  final String image;
  final String name;
  final String text;
  final String date;
  final String uid;
  final double? rating;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final int? length;

  const RepliesWidget({
    super.key,
    required this.image,
    required this.name,
    required this.text,
    required this.date,
    required this.uid,
    this.rating,
    this.length,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
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
                        name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (rating != null && rating! > 0)
                        Row(
                          children: [
                            ...List.generate(
                              rating!.toInt(),
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              rating!.toString(),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          "No rating available",
                          style: TextStyle(
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    text,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Consumer<AuthViewModel>(
                    builder: (context, viewModel, child) {
                      final user = viewModel.currentUser;
                      final logger = Logger();
                      logger.d(
                          "Comparing UIDs: widget.uid=$uid, userId=${user?.data?.userId}");
                      if (user?.data?.userId == uid) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: onEdit,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(8),
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
                                final bool? confirm = await showDialog<bool>(
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
                                onDelete?.call();
                                // Navigator.of(context).pop();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(8),
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
                      }
                      return const SizedBox();
                    },
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
                    image,
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
