import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:library_management_sys/widgets/form_widget/custom_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../../resource/colors.dart';
import '../../../view_model/books/book_view_model.dart';

class AddReview extends StatefulWidget {
  final String uid, name;
  const AddReview({super.key, required this.uid, required this.name});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: Colors.red,
          rightDotColor: AppColors.primary,
          size: 40,
        ),
      )
          : Container(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Rate the Book',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'poppins',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: RatingBar.builder(
                        initialRating: _rating,
                        minRating: 0, // ✅ Allow half-star properly
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding:
                        const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                          print("Selected rating: $_rating"); // ✅ Debug log
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'You rated: $_rating',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: CustomButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          if (_rating == 0.0) {
                            Utils.flushBarErrorMessage(
                                'Please provide a rating.', context);
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          final ratingValue =
                          _rating.toStringAsFixed(1); // ✅ e.g. "4.5"
                          print('Submitting rating: $ratingValue'); // ✅ Debug

                          final check = await Provider.of<BooksViewModel>(
                              context,
                              listen: false)
                              .rateBook(widget.uid, ratingValue, context);

                          if (check) {
                            await Provider.of<BooksViewModel>(context,
                                listen: false)
                                .getIndividualBooks(
                                widget.uid, context);

                            await Provider.of<BooksViewModel>(context,
                                listen: false)
                                .fetchBooksList(context);
                          }

                          setState(() {
                            isLoading = false;
                          });
                        },
                        text: 'Submit Review',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
