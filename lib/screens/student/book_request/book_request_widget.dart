import 'package:flutter/material.dart';
import '../../../utils/parse_date.dart';

class BookRequestWidget extends StatelessWidget {
  final dynamic reservationData;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const BookRequestWidget({
    super.key,
    required this.reservationData,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isPending =
        (reservationData.status?.toLowerCase() ?? '') == 'pending';
    final title = reservationData.title ?? 'Unknown Title';
    final truncatedTitle = title.split(' ').length > 5
        ? "${title.split(' ').take(5).join(' ')}..."
        : title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 170,
                              child: Text(
                                truncatedTitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(reservationData.status),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                reservationData.status ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Author(s): ${reservationData.authors ?? 'Unknown'}',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Publisher: ${reservationData.publisher ?? 'Unknown'}',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Requested: ${parseDate(reservationData.createdAt) ?? 'N/A'}',
                          style: const TextStyle(
                              fontSize: 11, color: Colors.black87),
                        ),
                        if (isPending) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: onEdit,
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
                                onTap: () {
                                  onDelete();
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
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'accepted':
        return Colors.green.shade400;
      case 'pending':
        return Colors.orange.shade400;
      case 'resolved':
        return Colors.blue.shade400;
      case 'rejected':
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }
}
