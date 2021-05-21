import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:music_app/home/provider/home_provider.dart';
import 'package:music_app/home/ui/home_music_item.dart';
import 'package:music_app/home/ui/home_now_playing.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  bool isDataRequested = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var playerProvider = Provider.of<HomeProvider>(context, listen: false);

    playerProvider.initAudioPlugin();
    playerProvider.resetStreams();
    playerProvider.fetchAllSongs(searchQuery: "Party LET");

    _searchQuery.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    var SongsBloc = Provider.of<HomeProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      isDataRequested = true;
      SongsBloc.fetchAllSongs(
        searchQuery: _searchQuery.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color green = Color(0xFFFFD4D4);
    return Scaffold(
      backgroundColor: Color(0xFFFFD4D4),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "V Music Player",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E21AC)),
        ),
        elevation: 0,
        backgroundColor: green,
      ),
      body: Column(
        children: [_searchBar(), _songsList(), _nowPlaying()],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.search),
          new Flexible(
            child: new TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5),
                hintText: 'Search Song',
              ),
              controller: _searchQuery,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Widget _songsList() {
    return Consumer<HomeProvider>(
      builder: (context, musicModel, child) {
        if (musicModel.allMusicList.length > 0) {
          return new Expanded(
            child: Padding(
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                      itemCount: musicModel.allMusicList.length,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return HomeItem(
                            musicModel: musicModel.allMusicList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      })
                ],
              ),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
          );
        }

        if (isDataRequested) {
          isDataRequested = false;
          return getSpinkKit();
        }

        if (musicModel.allMusicList.length == 0) {
          return new Expanded(
            child: _noData(),
          );
        }

        return getSpinkKit();
      },
    );
  }

  getSpinkKit() {
    return SpinKitFadingCircle(
      color: Color(0xFF4F4F4F),
      size: 30.0,
    );
  }

  Widget _noData() {
    String noDataTxt = "";
    bool showTextMessage = false;

    noDataTxt = "No Music Found";
    showTextMessage = true;

    return Column(
      children: [
        new Expanded(
          child: Center(
            child: showTextMessage
                ? new Text(
                    noDataTxt,
                    textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : getSpinkKit(),
          ),
        ),
      ],
    );
  }

  Widget _nowPlaying() {
    var playerProvider = Provider.of<HomeProvider>(context, listen: true);
    playerProvider.resetStreams();
    String trackName;
    String trackImage;
    if (playerProvider.currentSong == null) {
      trackName = "";
      trackImage = "";
    } else {
      trackName = playerProvider.currentSong.trackName;
      trackImage = playerProvider.currentSong.artworkUrl100;
    }
    return Visibility(
      visible: playerProvider.getPlayerState() == MusicPlayerState.PLAYING,
      child: HomeNowPlaying(
        musicTitle: trackName,
        musicImageURL: trackImage,
      ),
    );
  }
}
