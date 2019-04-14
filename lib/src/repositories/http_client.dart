import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class ApiClient {
  static const baseUrl = 'https://uapi.adrise.tv';
  final http.Client httpClient = http.Client();
  Map<String, String> _headers = {
    "Accept-Encoding": "deflate, gzip;q=1.0, *;q=0.5"
  };

  Future<HomePageModel> fetchHomePage() async {
    final homeUrl =
        '$baseUrl/matrix/homescreen?app_id=tubitv&device_id=3B17D64C-8A40-4234-A80E-0C3020F621B7&expand=2&limit=40&page_enabled=false&platform=iphone&user_id=0';
    final homeResponse = await this.httpClient.get(homeUrl, headers: _headers);

    if (homeResponse.statusCode != 200) {
      throw Exception('error getting home page data');
    }

    final json = jsonDecode(homeResponse.body);
    return HomePageModel.fromJson(json);
  }

  Future<List<Movie>> fetchRelatedMovies({@required String id}) async {
    final url =
        '$baseUrl/cms/content/$id/related?app_id=tubitv&device_id=3B17D64C-8A40-4234-A80E-0C3020F621B7&page_enabled=false&platform=iphone&user_id=0';
    final response = await this.httpClient.get(url, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('error getting related movies');
    }

    final movies = (jsonDecode(response.body) as List)
        .map((json) => Movie.fromJson(json))
        .toList();
    return movies;
  }

  Future<Movie> fetchMovieDetails({@required String contentId}) async {
    final url =
        '$baseUrl/cms/content?app_id=tubitv&content_id=$contentId&device_id=3B17D64C-8A40-4234-A80E-0C3020F621B7&includeChannels=true&page_enabled=false&platform=iphone&user_id=1';
    final response = await this.httpClient.get(url, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('error getting movie details');
    }
    final json = jsonDecode(response.body);

    return Movie.fromJson(json);
  }

  Future<List<Movie>> movieSearch({@required String key}) async {
    final url =
        '$baseUrl/cms/search?app_id=tubitv&categorize=true&device_id=3B17D64C-8A40-4234-A80E-0C3020F621B7&page_enabled=false&platform=iphone&search=$key&user_id=0';
    final response = await this.httpClient.get(url, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('error searching movies');
    }
    final json = jsonDecode(response.body);

    var moviesJson = (json['contents'] as Map<String, dynamic>);
    var movies = Map<String, Movie>();
    moviesJson.forEach((k, v) {
      movies[k] = Movie.fromJson(v);
    });

    return movies.values.toList();
  }
}
