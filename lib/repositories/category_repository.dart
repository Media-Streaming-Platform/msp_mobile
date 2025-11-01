import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';

class CategoryRepository {
  final String baseUrl;

  CategoryRepository({required this.baseUrl});

  /// Fetch all categories
 Future<List<Category>> fetchAllCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/category/get-all-categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
