import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/screens/librerian/history/history.dart';
import 'package:library_management_sys/widgets/book/book_widget.dart';
import 'package:library_management_sys/widgets/dashboard_card/dashboard_card.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

        body: SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: size.width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      foregroundImage: AssetImage('assets/images/one.webp'),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "WELCOME",
                          style: TextStyle(
                              color: AppColors.secondary, letterSpacing: 1.2),
                        ),
                        Text(
                          "Minal Pariyar",
                          style: TextStyle(
                              color: AppColors.secondary,
                              fontFamily: 'poppins-black'),
                        )
                      ],
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(
                      width: 4,
                    ),
                    Image(
                      image: AssetImage('assets/images/pcpsLogo.png'),
                      width: 60,
                      height: 20,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text(
                "Explore",
                style: TextStyle(
                    fontSize: 43,
                    color: AppColors.primary,
                    fontFamily: 'poppins-black'),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Most Popular',
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'poppins-black',
                      color: AppColors.primary),
                ),
                InkWell(
                  onTap: () {},
                  child: Icon(Icons.arrow_forward_ios_sharp,
                      size: 18, color: AppColors.primary),
                )
              ],
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  BookWidget(
                      bookImage: 'assets/images/book.png',
                      title: "My Type of book and well done",
                      author: "Author kenzie Mcnary"),
                  SizedBox(
                    width: 8,
                  ),
                  BookWidget(
                      bookImage: 'assets/images/two.webp',
                      title: "A Million To One",
                      author: "Tony Fagoli"),
                  SizedBox(
                    width: 8,
                  ),
                  BookWidget(
                      bookImage: 'assets/images/hide.webp',
                      title: "Hide and Seek",
                      author: "Olivia Wilson"),
                  SizedBox(
                    width: 8,
                  ),
                  BookWidget(
                      bookImage: 'assets/images/one.webp',
                      title: "Walk Into The shadow",
                      author: "Author kenzie Mcnary"),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'E-library',
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'poppins-black',
                      color: AppColors.primary),
                ),
                InkWell(
                  onTap: () {},
                  child: Icon(Icons.arrow_forward_ios_sharp,
                      size: 18, color: AppColors.primary),
                )
              ],
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  BookWidget(
                      bookImage: 'assets/images/book.png',
                      title: "My Type of book and well done",
                      author: "Author kenzie Mcnary"),
                  SizedBox(
                    width: 8,
                  ),
                  BookWidget(
                      bookImage: 'assets/images/two.webp',
                      title: "A Million To One",
                      author: "Tony Fagoli"),
                  SizedBox(
                    width: 8,
                  ),
                  BookWidget(
                      bookImage: 'assets/images/hide.webp',
                      title: "Hide and Seek",
                      author: "Olivia Wilson"),
                  SizedBox(
                    width: 8,
                  ),
                  BookWidget(
                      bookImage: 'assets/images/one.webp',
                      title: "Walk Into The shadow",
                      author: "Author kenzie Mcnary"),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
