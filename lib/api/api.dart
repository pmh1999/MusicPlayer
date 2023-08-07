import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';

import '../const.dart';
import '../models/song.dart';

class Api {
  Dio dio = Dio();
  Future<List<Song>> fetchChart() async {
    Response response = await dio.get(CHART_URL);
    String msg = response.data['msg'];
    if (msg == 'Success') {
      print(response.data['data']['song']);
      var data = response.data['data']['song'];
      return (data as List<dynamic>)
          .map((dynamic json) => Song.fromJson(json))
          .toList();
    } else {
      return [];
    }
  }

  Future<String> getKey(String link) async {
    var url = Uri.parse(BASE_URL + link);

    final response = await http.get(url);
    String body = utf8.decoder.convert(response.bodyBytes);
    int indexStart = body.indexOf('data-source');
    int indexEnd = body.indexOf('data-id', indexStart);
    return body.substring(indexStart + 13, indexEnd - 2);
  }
}
