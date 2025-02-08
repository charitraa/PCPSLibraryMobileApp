import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/colors.dart';
import 'package:library_management_sys/screens/librerian/history/history.dart';
import 'package:library_management_sys/widgets/book/book_widget.dart';
import 'package:library_management_sys/widgets/dashboard_card/dashboard_card.dart';

class LibrerianDashboard extends StatefulWidget {
  const LibrerianDashboard({super.key});

  @override
  State<LibrerianDashboard> createState() => _LibrerianDashboardState();
}

class _LibrerianDashboardState extends State<LibrerianDashboard> {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WELCOME",
                      style: TextStyle(
                          color: AppColors.secondary, letterSpacing: 2),
                    ),
                    Text(
                      "Librerian",
                      style: TextStyle(
                        color: AppColors.secondary,
                      ),
                    )
                  ],
                ),
                const Image(
                  image: AssetImage('assets/images/pcpsLogo.png'),
                  width: 110,
                  height: 40,
                  fit: BoxFit.cover,
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: size.width,
              child: Wrap(
                children: [
                  DashboardCard(
                      icon: Icons.history_sharp,
                      name: 'History',
                      onPressed: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                            const History(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;
                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      })
                ],
              ),
            ), const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Most Popular',
                  style: TextStyle(fontSize: 15),
                ),
                InkWell(
                  onTap: () {},
                  child: const Icon(
                    Icons.arrow_forward_ios_sharp,
                    size: 18,
                  ),
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
