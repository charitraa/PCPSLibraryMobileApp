import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookPreview extends StatelessWidget {
  final String imageUrl;
  const BookPreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8), // Dark background for pop-up effect
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Hero(
                tag: imageUrl, // Match the tag from the clicked image
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
