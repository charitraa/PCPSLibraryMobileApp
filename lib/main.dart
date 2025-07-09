import 'package:flutter/material.dart';
import 'package:library_management_sys/resource/routes.dart';
import 'package:library_management_sys/resource/routes_name.dart';
import 'package:library_management_sys/view_model/attributes/attr_author_view_model.dart';
import 'package:library_management_sys/view_model/attributes/attr_genre_view_model.dart';
import 'package:library_management_sys/view_model/attributes/attr_publisher_view_model.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/view_model/book_requests/request_view_model.dart';
import 'package:library_management_sys/view_model/books/book_view_model.dart';
import 'package:library_management_sys/view_model/books/comment_view_model.dart';
import 'package:library_management_sys/view_model/books/online_books_view_model.dart';
import 'package:library_management_sys/view_model/books/recommended_view_model.dart';
import 'package:library_management_sys/view_model/notifications/notification_view_model.dart';
import 'package:library_management_sys/view_model/reservations/reservation_view_model.dart';
import 'package:library_management_sys/view_model/shared_pref_view_model.dart';
import 'package:library_management_sys/view_model/users/my_book_view_model.dart';
import 'package:library_management_sys/view_model/users/my_due_view_model.dart';
import 'package:library_management_sys/view_model/users/my_pay_view_model.dart';
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
        ChangeNotifierProvider(create: (_) => RecommendedViewModel()),
        ChangeNotifierProvider(create: (_) => MyBooksViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
        ChangeNotifierProvider(create: (_) => OnlineBooksViewModel()),
        ChangeNotifierProvider(create: (_) => BookRequestViewModel()),
        ChangeNotifierProvider(create: (_) => MyDueViewModel()),
        ChangeNotifierProvider(
          create: (_) => NotificationViewModel(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling, // Apply global text scaling
            ),
            child: MaterialApp(
              title: 'PCPS Library',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                useMaterial3: true,
                scaffoldBackgroundColor: Colors.white,
                fontFamily: 'Poppins',
              ),
              debugShowCheckedModeBanner: false,
              initialRoute: RoutesName.flash,
              onGenerateRoute: Routes.generateRoute,
            ),
          );
        },
      ),
    );
  }
}
