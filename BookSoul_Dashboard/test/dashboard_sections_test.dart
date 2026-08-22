import 'package:flutter_test/flutter_test.dart';
import 'package:booksoul_dashboard/main.dart';

void main() {
  test('Dashboard defines all administrative sections', () {
    expect(AdminPage.values, hasLength(8));
    expect(AdminPage.values, contains(AdminPage.overview));
    expect(AdminPage.values, contains(AdminPage.books));
    expect(AdminPage.values, contains(AdminPage.users));
    expect(AdminPage.values, contains(AdminPage.metrics));
    expect(AdminPage.values, contains(AdminPage.integrations));
  });
}
