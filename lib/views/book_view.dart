import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:michaels_library/objects/book.dart';
import 'package:michaels_library/providers/auth.dart';
import 'package:michaels_library/providers/books_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookView extends StatelessWidget {
  final Book book;

  BookView({this.book});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final booksProvider = Provider.of<BooksProvider>(context);
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(book.title),
              expandedHeight: 350,
              actions: <Widget>[
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
              ],
              flexibleSpace: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 120,
                    ),
                    Hero(
                      child: Image(
                        width: 120,
                        image: NetworkImage(book.coverUrl),
                        fit: BoxFit.cover,
                      ),
                      tag: 'coverImage${book.id}',
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: RatingBar(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                child: Icon(Icons.file_download),
                              ),
                              SizedBox(height: 16,),
                              Text('Download'),
                            ],
                          ),
                        ),
                        onTap: (){
                          booksProvider.downloadFile(book);
                        },
                        borderRadius: BorderRadius.circular(3),
                      ),
                      InkWell(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                child: Icon(Icons.star),
                              ),
                              SizedBox(height: 16,),
                              Text('Review'),
                            ],
                          ),
                        ),
                        onTap: (){
                          booksProvider.readBook(book);
                        },
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
