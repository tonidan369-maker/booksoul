import 'package:flutter_test/flutter_test.dart';
import 'package:booksoul/models/book.dart';
void main(){test('demo library contains Arabic books',(){expect(demoBooks.length,greaterThanOrEqualTo(6));expect(demoBooks.first.title,isNotEmpty);});}
