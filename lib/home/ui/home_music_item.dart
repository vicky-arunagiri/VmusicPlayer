import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:music_app/home/model/home_list_model.dart';
import 'package:music_app/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomeItem extends StatefulWidget {
  final Results musicModel;
  HomeItem({Key key, this.musicModel}) : super(key: key);
  @override
  _HomeItemState createState() => _HomeItemState();
}

class _HomeItemState extends State<HomeItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMusicRow();
  }

  Widget _buildMusicRow() {
    var playerProvider = Provider.of<HomeProvider>(context, listen: false);
    playerProvider.resetStreams();
    bool _isSelectedRadio;
    if (playerProvider.currentSong == null) {
      _isSelectedRadio = false;
    } else {
      _isSelectedRadio =
          this.widget.musicModel.trackId == playerProvider.currentSong.trackId;
    }
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            this.widget.musicModel.trackName,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF182545),
            ),
          ),
          Text(this.widget.musicModel.artistName, maxLines: 2),
          Text(
            this.widget.musicModel.collectionName,
            maxLines: 2,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
      leading: _image(this.widget.musicModel.artworkUrl100),
      trailing: Wrap(
        spacing: -10.0, // gap between adjacent chips
        runSpacing: 0.0, // gap between lines
        children: <Widget>[
          _buildPlayStopIcon(
            playerProvider,
            _isSelectedRadio,
          ),
        ],
      ),
    );
  }

  Widget _image(url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
        color: Color(0xFFFFE5EC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Widget _buildPlayStopIcon(HomeProvider playerProvider, bool _isSelectedSong) {
    return IconButton(
      icon: _buildAudioButton(playerProvider, _isSelectedSong),
      onPressed: () {
        if (!playerProvider.isStopped() && _isSelectedSong) {
          playerProvider.stopSong();
        } else {
          if (!playerProvider.isLoading()) {
            playerProvider.initAudioPlugin();
            playerProvider.setAudioPlayer(this.widget.musicModel);

            playerProvider.playSong();
          }
        }
      },
    );
  }

  getSpinkKit() {
    return SpinKitWave(
      color: Color(0xFF5eb0e5),
      size: 20.0,
    );
  }

  Widget _buildAudioButton(HomeProvider model, _isSelectedSong) {
    if (_isSelectedSong) {
      if (model.isLoading()) {
        return Center(
          child: getSpinkKit(),
        );
      }

      if (!model.isStopped()) {
        return Center(
          child: getSpinkKit(),
        );
      }

      if (model.isStopped()) {
        return Icon(MaterialCommunityIcons.play_circle,
            size: 30, color: Color(0xFF828282));
      }
    } else {
      return Icon(MaterialCommunityIcons.play_circle,
          size: 30, color: Color(0xFF828282));
    }

    return new Container();
  }
}
