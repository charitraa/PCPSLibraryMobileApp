import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/routes.dart';
import 'package:library_management_sys/resource/routes_name.dart';
import 'package:library_management_sys/screens/student/my_wishlist/std_wishlist.dart';
import 'package:library_management_sys/view_model/attributes/attr_author_view_model.dart';
import 'package:library_management_sys/view_model/attributes/attr_genre_view_model.dart';
import 'package:library_management_sys/view_model/attributes/attr_publisher_view_model.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/view_model/books/book_view_model.dart';
import 'package:library_management_sys/view_model/books/comment_view_model.dart';
import 'package:library_management_sys/view_model/reservations/reservation_view_model.dart';
import 'package:library_management_sys/view_model/shared_pref_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => BooksViewModel()),
        ChangeNotifierProvider(create: (_) => AttrAuthorViewModel()),
        ChangeNotifierProvider(create: (_) => AttrGenreViewModel()),
        ChangeNotifierProvider(create: (_) => AttrPublisherViewModel()),
        ChangeNotifierProvider(create: (_) => CommentViewModel()),
        ChangeNotifierProvider(create: (_) => ReservationViewModel()),

      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'poppins',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesName.flash,
        onGenerateRoute: Routes.generateRoute,

      ),
    );
  }
}
