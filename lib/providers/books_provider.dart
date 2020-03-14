import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:michaels_library/objects/book.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'package:pointycastle/asymmetric/api.dart';
import 'package:string_validator/string_validator.dart';

class BooksProvider extends ChangeNotifier {
  static const BASE_URL = 'http://172.16.0.20:5000';
  static const platform = const MethodChannel('com.digitalhundred/encrypt');

  List<Book> _books;

  List<Book> get books => _books;


  List<Book> _parseBooks(String responseBody) {
    final parsed = json.decode(responseBody)["docs"].cast<Map<String, dynamic>>();

    return parsed.map<Book>((json) => Book.fromJson(json)).toList();
  }


  void getBooks () async {
    final String url = '$BASE_URL/api/books/list/1/20';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');

    try {
      final response = await http.get(url, headers: { HttpHeaders.authorizationHeader: token },);
      _books = _parseBooks(response.body);
      notifyListeners();
    } on SocketException catch(e) {
      print(e);
    }
  }

  Future<void> encryptFile() async {
    try {
      final storageDir = await getExternalStorageDirectory();
      File bookFile = File('${storageDir.path}/book.pdf');
      final String result = await platform.invokeMethod('encryptFile', {'path': bookFile.path});
      print(result);
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void downloadFile (Book book) async {
    final mainDir = await getApplicationDocumentsDirectory();
    File privateKeyFile = File('${mainDir.path}/private_key.pem');
    File publicKeyFile = File('${mainDir.path}/public_key.pem');

    final String url = '$BASE_URL/api/books/request-token/${book.id}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');

    try {
      final response = await http.get(url, headers: { HttpHeaders.authorizationHeader: token },);
      String encoded = response.body;
      final privateKey = await parseKeyFromFile<RSAPrivateKey>(privateKeyFile.path);
      final publicKey = await parseKeyFromFile<RSAPublicKey>(publicKeyFile.path);

      final decrypt = enc.Encrypter(enc.RSA(privateKey: privateKey, encoding: enc.RSAEncoding.OAEP));
      final key = decrypt.decrypt(enc.Encrypted.from64(encoded));

      print(key);

      final encryptKey = enc.Encrypter(enc.RSA(publicKey: publicKey, encoding: enc.RSAEncoding.OAEP));
      final encrypted = encryptKey.encrypt(key);

      final storageDir = await getExternalStorageDirectory();
      Directory dir = Directory('${storageDir.path}/${book.slug}');
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
      dir.createSync();

      String link = '$BASE_URL/api/books/download-book/${book.id}';

      try {

        HttpClient client = new HttpClient();
        final request = await client.postUrl(Uri.parse(link));
        request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
        request.headers.set('authorization', token);
        request.write('{ "file": "${encrypted.base64}" }');

        final response = await request.close();

        int downloaded = 0;
        int fileNumber = 0;

        final aesKey = enc.Key.fromUtf8('my 32 length key................');
        final iv = enc.IV.fromLength(16);
        final encrypter = enc.Encrypter(enc.AES(aesKey, mode: enc.AESMode.cbc));

        response.listen((d) {
          downloaded += d.length;
          double percentage = ((downloaded / book.size) * 100);

          var base = base64Encode(d);

          File chunk = File('${dir.path}/$fileNumber.chk');
          print(percentage);
          final data = encrypter.encrypt(base, iv: iv);
          chunk.writeAsStringSync(data.base64);
          fileNumber += 1;
        });
      } on SocketException catch(e) {
        print(e);
      }

    } on SocketException catch(e) {
      print(e);
    }
  }

  void readBook(Book book) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.get('token');

    final storageDir = await getExternalStorageDirectory();
    Directory dir = Directory('${storageDir.path}/${book.slug}');
    
    File bookFile = File('${storageDir.path}/${book.slug}1.pdf');
    final bookStream = bookFile.openWrite();

    final aesKey = enc.Key.fromUtf8('my 32 length key................');
    final iv = enc.IV.fromLength(16);
    final encrypter = enc.Encrypter(enc.AES(aesKey, mode: enc.AESMode.cbc));

    int files = dir.listSync().length;

    for (int i = 0; i < files; i++) {
      File file = File('${dir.path}/$i.chk');
      final bytes = file.readAsStringSync();
      final decrypted = encrypter.decrypt64(bytes, iv: iv);
      bookStream.add(base64.decode(decrypted));
      print(i);
    }
    bookStream.close();
    print('done');
  }
}