import 'package:flutter/material.dart';
import 'package:michaels_library/providers/auth.dart';
import 'package:michaels_library/providers/books_provider.dart';
import 'package:michaels_library/views/login.dart';
import 'package:michaels_library/views/main_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (_) => BooksProvider(),
          ),
        ],
        child: MainApp(),
      )
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return MaterialApp(
      title: 'Michaels Library',
      home: FutureBuilder<bool>(
        future: auth.isUserLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data) {
              return MainPage();
            } else {
              return Login();
            }
          }
          return Scaffold(
            body: Container(
              child: Center(child: CircularProgressIndicator(),),
            ),
          );
        },
      ),
    );
  }
}
