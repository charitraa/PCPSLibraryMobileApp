import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/books/book_view_model.dart';
import '../../../widgets/custom_search.dart';
import '../../../widgets/dropdowns/drop_down.dart';

import '../../../resource/colors.dart';
import '../../../widgets/book/book_widget.dart';
import '../../../widgets/explore/explore_header.dart';

class StudentBrowseBooks extends StatefulWidget {
  const StudentBrowseBooks({super.key});

  @override
  State<StudentBrowseBooks> createState() => _BrowseBooksState();
}

class _BrowseBooksState extends State<StudentBrowseBooks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 0;
  late ScrollController _scrollController;
  bool isLoad=false;
  String message='';
  _scrollListener(){
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      loadMore();
    }
    if (_scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        message = "reach the top";
      });
    }
  }
  loadMore ()async{
    setState(() {
      isLoad=true;
    });
    try{
      await Provider.of<BooksViewModel>(context, listen: false)
          .loadMoreBooks(context);
      setState(() {
        isLoad=false;
      });
    }catch(e){
      setState(() {
        isLoad=false;
      });
    }
  }
  fetchBooks ()async{
      await Provider.of<BooksViewModel>(context, listen: false)
          .fetchBooksList(context);

  }
  @override
  void initState() {
    fetchBooks();
    _scrollController=ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }
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
              child: CustomGenre(
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
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double itemWidth = (constraints.maxWidth - (10 * 2)) / 3;
                    double itemHeight = 180;
                    double aspectRatio = itemWidth / itemHeight;

                    return  Consumer<BooksViewModel>(
                      builder: (context, value, child) {
                        final books = value.booksList;
                        if (books.isEmpty) {
                          return const Center(
                            child: Text(
                              'No Books available.',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: const EdgeInsets.only(bottom: 18),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 15,
                            childAspectRatio: aspectRatio,
                          ),
                          itemCount: books.length,
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController,
                          itemBuilder: (context, i) {
                            return BookWidget(
                              bookImage: books.,
                              title: "sd",
                              author:"sdf",
                            );
                          },
                        );

                      },
                    );
                  },
                ),
              ),





            ],
          ),
        ),
      ),
    );
  }
}
