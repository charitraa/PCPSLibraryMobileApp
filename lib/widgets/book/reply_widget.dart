import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';

class ReplyWidget extends StatefulWidget {
  final String? image, name, text,date;
  final double? rating;
  final VoidCallback? onTap;
  final int? length;
  const ReplyWidget({super.key, required this.image, required this.name, required this.text, this.rating, this.length,  this.onTap, this.date});

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {

  @override
  Widget build(BuildContext context) {
    return   Padding(
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
                        widget.name??'',
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
                                  (index) =>
                              const Icon(Icons.star, color: Colors.amber,size: 14,),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              widget.rating!.toString(),
                              style: const TextStyle(fontSize: 11,fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                   Text(
                    widget.date??'',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.text??'',
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("${widget.length.toString()} replies", style: const TextStyle(
                          fontSize: 12, color: Colors.grey)),
                      const SizedBox(width: 8,),
                      const Icon(Icons.chat,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 5),
                      const Text(
                        "Reply",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey),
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
                  child: CachedNetworkImage(
                    imageUrl: widget.image??'',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error, size: 24),
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
