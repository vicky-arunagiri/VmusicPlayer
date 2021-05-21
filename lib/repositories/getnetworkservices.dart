import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_app/home/model/home_list_model.dart';

class GetNetworkServices {
  Future<MusicListModel> getData(String url) async {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return MusicListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
