// repositories/media_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/media.dart';

class MediaRepository {
  final String baseUrl;

  MediaRepository({required this.baseUrl});

  /// ✅ Fetch all media
  Future<List<Media>> fetchAllMedia() async {
    final response = await http.get(Uri.parse('$baseUrl/media/get-all'));

     if (response.statusCode == 200) {
    final decoded = json.decode(response.body);

    // Check if response is a Map (wrapped object)
    final List<dynamic> data =
        decoded is Map<String, dynamic> ? decoded['data'] ?? decoded['mediaList'] ?? [] : decoded;

    return data.map((item) => Media.fromJson(item)).toList();

    // if (response.statusCode == 200) {
    //   final List<dynamic> data = json.decode(response.body);
    //   return data.map((item) => Media.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load media');
    }
  }

  /// ✅ Fetch a single media by ID
  Future<Media> fetchMediaById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/media/$id'));

    if (response.statusCode == 200) {
      return Media.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load media details');
    }
  }

  /// ✅ Add new media
  Future<Media> addMedia(Media media) async {
    final response = await http.post(
      Uri.parse('$baseUrl/media'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(media.toJson()),
    );

    if (response.statusCode == 201) {
      return Media.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add media');
    }
  }

  /// ✅ Update media
  Future<Media> updateMedia(String id, Media media) async {
    final response = await http.put(
      Uri.parse('$baseUrl/media/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(media.toJson()),
    );

    if (response.statusCode == 200) {
      return Media.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update media');
    }
  }

  /// ✅ Delete media
  Future<void> deleteMedia(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/media/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete media');
    }
  }
}
