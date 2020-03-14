import 'package:flutter/material.dart';
import 'package:michaels_library/objects/book.dart';
import 'package:michaels_library/objects/book.dart';
import 'package:michaels_library/providers/books_provider.dart';
import 'package:michaels_library/views/book_view.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    final booksProviders = Provider.of<BooksProvider>(context, listen: false);
    booksProviders.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    final booksProvider = Provider.of<BooksProvider>(context);
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Library'),
          actions: <Widget>[
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.more_vert),
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Saved',
              ),
              Tab(
                text: 'Book Shelf',
              ),
              Tab(
                text: 'Wishlist',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              child: Center(
                child: Text('Saved'),
              ),
            ),
            Container(
              child: booksProvider.books == null ? Center(
                child: CircularProgressIndicator(),
              ) : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: booksProvider.books.length,
                itemBuilder: (context, index) {

                  Book book = booksProvider.books[index];
                  TextStyle basicTextStyle = TextStyle(color: Colors.black54);
                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    child: InkWell(
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            child: Hero(
                              child: Image(
                                image: NetworkImage(book.coverUrl),
                                width: 72,
                              ),
                              tag: 'coverImage${book.id}',
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(book.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),),
                                SizedBox(height: 16,),
                                Text(book.author, style: basicTextStyle,),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.black54,),
                            onPressed: (){

                            },
                          ),
                        ],
                      ),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BookView(book: book,)));
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              child: Center(
                child: Text('Chat'),
              ),
            ),
          ],
        ),
        drawer: Drawer(),
      ),
    );
  }
}
