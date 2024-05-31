import 'dart:convert';
import 'dart:ui' as ui;

import 'package:http/http.dart' as http;

import '../constants/url_consts.dart';

class APIService {
  final httpClient = http.Client();

  get(
    String url,
    String? query,
  ) async {
    try {
      final utf8Decoder = utf8.decoder;
      var locale = ui.window.locale.languageCode;

      if (query == null) {
        final response = await http.get(
          Uri.parse('$url?api_key=${Constants.apiKey}&language=$locale'),
          headers: {
            "Content-Type": "application/json;charset=utf-8",
          },
        );
        if (response.statusCode == 200) {
          final decodedResponse = utf8Decoder.convert(response.bodyBytes);
          return json.decode(decodedResponse);
        }
      } else {
        final response = await http.get(
          Uri.parse(
              '$url?query=$query&api_key=${Constants.apiKey}&language=$locale'),
          headers: {
            "Content-Type": "application/json;charset=utf-8",
          },
        );
        if (response.statusCode == 200) {
          final decodedResponse = utf8Decoder.convert(response.bodyBytes);
          return json.decode(decodedResponse);
        }
      }
    } catch (e) {
      ///TODO: need to create exceptions in app
      print('ERROR $e');
    }
  }
}
