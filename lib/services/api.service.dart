import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/url_consts.dart';

class APIService {
  final httpClient = http.Client();

  get(
    String url,
    String? query,
  ) async {
    try {
      if (query == null) {
        final response = await http.get(
          Uri.parse('$url?api_key=${Constants.apiKey}'),
        );
        if (response.statusCode == 200) {
          return json.decode(response.body);
        }
      } else {
        final response = await http.get(
          Uri.parse('$url?query=$query&api_key=${Constants.apiKey}'),
        );
        if (response.statusCode == 200) {
          return json.decode(response.body);
        }
      }
    } catch (e) {
      print('ERROR $e');
    }
  }
}
