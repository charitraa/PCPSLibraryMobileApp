import 'package:flutter/material.dart';
import 'package:library_management_sys/widgets/custom_search.dart';
import 'package:library_management_sys/widgets/dropdowns/custom_genres.dart';

import '../../../resource/colors.dart';
import '../../../widgets/book/book_widget.dart';
import '../../../widgets/explore/explore_header.dart';

class AdminBrowseBooks extends StatefulWidget {
  const AdminBrowseBooks({super.key});

  @override
  State<AdminBrowseBooks> createState() => _BrowseBooksState();
}

class _BrowseBooksState extends State<AdminBrowseBooks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/pcpsLogo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Filter By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomGenres(
                label: 'Filter by Genre',
                wid: size.width,
                onChanged: (value) {
                  _scaffoldKey.currentState?.closeDrawer();
                  // Provider.of<UserListViewModel>(context, listen: false)
                  //     .setBloodGrp(value!, context);
                },
              ),
            ),

          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: size.width,
          child: Column(
            children: [
              const ExploreHeader(),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Browse books based on your interests',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                            color: index == 0 ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "All Books",
                            style: TextStyle(
                                color:
                                index == 0 ? Colors.white : AppColors.primary,
                                fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: index == 1 ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.0,
                            ),
                          ),
                          child: Text(
                            "Top Rated",
                            style: TextStyle(
                                color:
                                index == 1 ? Colors.white : AppColors.primary,
                                fontSize: 12),
                          ),
                        ),
                      )
                    ],
                  ),
                  InkWell(
                      onTap: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },

                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(Icons.filter_alt_rounded,size: 15,color: Colors.white,),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomSearch(
                  hintText: 'Search Books',
                  outlinedColor: Colors.grey,
                  focusedColor: AppColors.primary,
                  height: 50,
                  width: double.infinity,
                  onChanged: (e) {}),
              const SizedBox(
                height: 15,
              ),
              // const Expanded(
              //   child: SingleChildScrollView(
              //     padding: EdgeInsets.only(bottom: 18),
              //     child: Wrap(
              //       spacing: 15,
              //       runSpacing: 15,
              //       children: [
              //         BookWidget(
              //             bookImage: 'assets/images/book.png',
              //             title: "My Type of book and well done",
              //             author: "Author kenzie Mcnary"),
              //         BookWidget(
              //             bookImage: 'assets/images/two.webp',
              //             title: "A Million To One",
              //             author: "Tony Fagoli"),
              //         BookWidget(
              //             bookImage: 'assets/images/hide.webp',
              //             title: "Hide and Seek",
              //             author: "Olivia Wilson"),
              //         BookWidget(
              //             bookImage: 'assets/images/one.webp',
              //             title: "Walk Into The shadow",
              //             author: "Author kenzie Mcnary"),
              //         BookWidget(
              //             bookImage: 'assets/images/book.png',
              //             title: "My Type of book and well done",
              //             author: "Author kenzie Mcnary"),
              //         BookWidget(
              //             bookImage: 'assets/images/two.webp',
              //             title: "A Million To One",
              //             author: "Tony Fagoli"),
              //         BookWidget(
              //             bookImage: 'assets/images/hide.webp',
              //             title: "Hide and Seek",
              //             author: "Olivia Wilson"),
              //         BookWidget(
              //             bookImage: 'assets/images/one.webp',
              //             title: "Walk Into The shadow",
              //             author: "Author kenzie Mcnary"),
              //       ],
              //     ),
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
