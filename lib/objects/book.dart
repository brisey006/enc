class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String publisher;
  final int year;
  final String genre;
  final String slug;
  final String coverUrl;
  final int size;
  final DateTime createdAt;
  final DateTime updatedAt;

  static const BASE_URL = 'http://172.16.0.20:5000';

  Book({ this.size, this.author, this.coverUrl, this.createdAt, this.description, this.genre, this.id, this.publisher, this.slug, this.title, this.updatedAt, this.year });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'],
      author: json['author'],
      coverUrl: '$BASE_URL${json['coverUrl']}',
      createdAt: DateTime.parse(json['createdAt']),
      description: json['description'],
      genre: json['genre'],
      id: json['_id'],
      publisher: json['publisher'],
      size: json['size'],
      slug: json['slug'],
      updatedAt: DateTime.parse(json['updatedAt']),
      year: json['year']
    );
  }
}