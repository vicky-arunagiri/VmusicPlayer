import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:music_app/home/provider/home_provider.dart';
import 'package:provider/provider.dart';

class HomeNowPlaying extends StatefulWidget {
  final String musicTitle;
  final String musicImageURL;
  HomeNowPlaying({Key key, this.musicTitle, this.musicImageURL})
      : super(key: key);

  @override
  _HomeNowPlayingState createState() => _HomeNowPlayingState();
}

class _HomeNowPlayingState extends State<HomeNowPlaying> {
  double progressValue = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var playerProvider = Provider.of<HomeProvider>(context, listen: false);
    return Container(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Color(0xFF828282)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 65.0,
                        width: 290.0,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0xFFFAFAFA), width: 3.0),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                  child: Icon(MaterialCommunityIcons.rewind,
                                      size: 30.0, color: Color(0xFFFAFAFA)),
                                  onTap: () {
                                    int indexOfSong = playerProvider
                                        .allMusicList
                                        .indexWhere((song) =>
                                            song.trackId ==
                                            playerProvider.currentSong.trackId);
                                    if (0 == indexOfSong) {
                                      return;
                                    }
                                    playerProvider.initAudioPlugin();
                                    playerProvider.setAudioPlayer(playerProvider
                                        .allMusicList[indexOfSong - 1]);
                                    playerProvider.playSong();
                                  }),
                              Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    color: Color(0xFFFAFAFA),
                                    shape: BoxShape.circle),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.stop,
                                    size: 30.0,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    playerProvider.stopSong();
                                  },
                                ),
                              ),
                              InkWell(
                                child: Icon(MaterialCommunityIcons.fast_forward,
                                    size: 30.0, color: Color(0xFFFAFAFA)),
                                onTap: () {
                                  int indexOfSong = playerProvider.allMusicList
                                      .indexWhere((song) =>
                                          song.trackId ==
                                          playerProvider.currentSong.trackId);
                                  int songListLength =
                                      playerProvider.allMusicList.length;
                                  if (songListLength == indexOfSong) {
                                    return;
                                  }
                                  playerProvider.initAudioPlugin();
                                  playerProvider.setAudioPlayer(playerProvider
                                      .allMusicList[indexOfSong + 1]);
                                  playerProvider.playSong();
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Slider(
                          value: progressValue,
                          min: 0.0,
                          activeColor: Color(0xFFFAFAFA),
                          inactiveColor: Color(0xFFFAFAFA),
                          max: playerProvider.currentSong.trackTimeMillis
                              .toDouble(),
                          onChanged: (double value) {
                            setState(() => progressValue = value);
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
