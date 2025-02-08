import 'package:flutter/material.dart';
import 'package:library_management_sys/screens/librerian/browse_books/admin_browse.dart';
import 'package:library_management_sys/screens/librerian/dashboard/lib_dash.dart';

class LibrarianNavBar extends StatefulWidget {
  const LibrarianNavBar({super.key});

  @override
  State<LibrarianNavBar> createState() => _LibrarianNavBarState();
}

class _LibrarianNavBarState extends State<LibrarianNavBar> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  final List<Widget> _pages = [
    const LibrerianDashboard(),
    const Center(child: Text('Home Page')),
    const AdminBrowseBooks(),
    const Center(child: Text('Profile Page')),
    const Center(child: Text('Finale Page')),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        width: size.width,
        height: 80,
        color: Colors.transparent,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(size.width, 80),
              painter: BNBCustomPainter(),
            ),
            Center(
              heightFactor: 0.5,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff393A8F),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu_book_sharp,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _navigateToPage(2);
                  },
                ),
              ),
            ),
            SizedBox(
              width: size.width,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.dashboard, 'Home', 0),
                  _buildNavItem(Icons.bookmark_remove_sharp, 'Books', 1),
                  const SizedBox(width: 48), // Space for the FAB
                  _buildNavItem(Icons.my_library_books_sharp, 'Issue', 2),
                  _buildNavItem(Icons.settings, 'Setting', 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String name, int index) {
    return InkWell(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _currentIndex == index ? const Color(0xff393A8F) : Colors.grey,
          ),
          Text(name, style: const TextStyle(fontSize: 10)),
        ],
      ),
      onTap: () => _navigateToPage(index),
    );
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20);
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: const Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, const Color(0xff393A8F), 10, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
