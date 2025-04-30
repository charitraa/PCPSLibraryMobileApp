import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/utils/utils.dart';
import 'package:library_management_sys/view_model/users/my_book_view_model.dart';
import 'package:provider/provider.dart';

class MyBookWidget extends StatelessWidget {
  final String title,id;
  final String? checkIn, due, status;
  final String image;
  final VoidCallback? onTap;

  const MyBookWidget({
    required this.title,
    required this.image,
    super.key,
    this.onTap,
    this.checkIn,
    this.due,
    this.status, required this.id,
  });

  @override
  Widget build(BuildContext context) {
    List<String> titleWords = title.split(" ");
    String truncatedTitle =
        titleWords.length > 4 ? "${titleWords.take(5).join(" ")}..." : title;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: image,
                          width: 70,
                          height: 90,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )),
                  ),
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
                              Text(
                                truncatedTitle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  status ?? '',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                'Reserved on : ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                checkIn ?? '',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Text(
                                'Due Date : ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                              Text(
                                due ?? '',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          if (status != "Reserved") ...[
                            InkWell(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    bool isProcessing = false; // Track renewal status

                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          title: const Text("Renew Book", textAlign: TextAlign.center),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Image.asset('assets/images/logo_library.png', height: 100),
                                              const SizedBox(height: 15),
                                              if (isProcessing)
                                                const CircularProgressIndicator()
                                              else
                                                const Text(
                                                  "Do you want to renew this book?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() => isProcessing = false); // Reset if needed
                                              },
                                              child: const Text("No", style: TextStyle(color: Colors.red)),
                                            ),
                                            TextButton(
                                              onPressed: isProcessing
                                                  ? null
                                                  : () async {
                                                setState(() => isProcessing = true);

                                                final check = await Provider.of<MyBooksViewModel>(context, listen: false)
                                                    .renew(id, context);

                                                if (check) {
                                                  await Provider.of<MyBooksViewModel>(context, listen: false)
                                                      .fetchBooksList(context);

                                                  Utils.flushBarSuccessMessage('Book renewed successfully!', context);
                                                }

                                                setState(() => isProcessing = false);
                                              },
                                              child: Text("Yes", style: TextStyle(color: Colors.green)),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );

                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Text(
                                  'Renew now',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ),
                          ] else ...[
                            const Text('Book cannot be renewed',style: TextStyle(
                              fontSize:10,
                              fontStyle: FontStyle.italic
                            ),)
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
