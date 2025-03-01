import 'package:flutter/material.dart';
import 'package:library_management_sys/custom_widget_test.dart';
import 'package:library_management_sys/resource/routes.dart';
import 'package:library_management_sys/resource/routes_name.dart';
import 'package:library_management_sys/screens/auth/flashing_page.dart';
import 'package:library_management_sys/screens/auth/login_page.dart';
import 'package:library_management_sys/screens/lib_nav.dart';
import 'package:library_management_sys/screens/student/browse_books/review.dart';
import 'package:library_management_sys/screens/student_nav.dart';
import 'package:library_management_sys/screens/unauthorised_page.dart';
import 'package:library_management_sys/view_model/attributes/attr_author_view_model.dart';
import 'package:library_management_sys/view_model/attributes/attr_genre_view_model.dart';
import 'package:library_management_sys/view_model/auth_view_model.dart';
import 'package:library_management_sys/view_model/books/book_view_model.dart';
import 'package:library_management_sys/view_model/shared_pref_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => BooksViewModel()),
        ChangeNotifierProvider(create: (_) => AttrAuthorViewModel()),
        ChangeNotifierProvider(create: (_) => AttrGenreViewModel()),
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
