import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';


import '../models/item_model.dart';
import '../models/trailer_model.dart';

class MovieApiProvider {
  Client _client = Client();
  final _apiKey = '802b2c4b88ea1183e50e6b285a27696e';
  final _baseUrl = "http://api.themoviedb.org/3/movie";

  Future<ItemModel> fetchMovieList() async {
    // print("MovieApiProvider:fetchMovieList");
    final response = await _client.get(
        "http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&page=7&language=ru&api_key=${_apiKey}");
    print(response.body.toString());
    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return ItemModel.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<TrailerModel> fetchTrailer(int movieId) async {
    final response =
        await _client.get("$_baseUrl/$movieId/videos?api_key=$_apiKey");
    if (response.statusCode == 200) {
      print(response.body.toString());
      return TrailerModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load trailers');
    }
  }
}
