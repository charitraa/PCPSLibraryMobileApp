import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:library_management_sys/widgets/form_widget/custom_button.dart';

import '../../../resource/colors.dart';

class AddReview extends StatefulWidget {
  const AddReview({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Review",
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
          SizedBox(width: 18)
        ],
      ),
      body: SafeArea(

        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal:24.0,vertical: 5),
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
                          minRating: 1,
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
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Write a Review',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _reviewController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Share your experience...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomButton(
                          onPressed: () async {
                            if (_rating == 0.0 ||
                                _reviewController.text.isEmpty) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(
                              //     content: Text('Please provide a rating and review.'),
                              //   ),
                              // );
                              Utils.flushBarSuccessMessage('check', context);
                              return;
                            }
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
      ),
    );
  }
}
