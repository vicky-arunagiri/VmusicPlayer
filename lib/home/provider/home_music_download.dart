import 'package:music_app/home/model/home_list_model.dart';
import 'package:music_app/repositories/getnetworkservices.dart';

class MusicDownload {
  static Future<MusicListModel> fetchAllSongs(String url) async {
    final serviceResponse = await GetNetworkServices().getData(url);
    print("Server Response${serviceResponse.toJson()}");
    return serviceResponse;
  }
}
