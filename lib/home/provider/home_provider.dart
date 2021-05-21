import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/home/model/home_list_model.dart';
import 'package:music_app/home/provider/home_music_download.dart';

enum MusicPlayerState { LOADING, STOPPED, PLAYING, PAUSED, COMPLETED }

class HomeProvider with ChangeNotifier {
  Results _musicDetails;
  List<Results> _musicList;
  List<Results> allMusicList;
  AudioPlayer _audioPlayer;
  int get totalRecords => _musicList != null ? _musicList.length : 0;

  Results get currentSong => _musicDetails;

  getPlayerState() => _playerState;

  getAudioPlayer() => _audioPlayer;

  getCurrentSong() => _musicDetails;

  MusicPlayerState _playerState = MusicPlayerState.STOPPED;
  StreamSubscription _positionSubscription;
  HomeProvider() {
    _initStreams();
  }
  void _initStreams() {
    if (_musicDetails == null) {
      if (_musicList != null && _musicList.length > 0) {
        _musicDetails = _musicList[0];
      }
    }
  }

  void resetStreams() {
    _initStreams();
  }

  void initAudioPlugin() {
    if (_playerState == MusicPlayerState.STOPPED) {
      _audioPlayer = new AudioPlayer();
    } else {
      _audioPlayer = getAudioPlayer();
    }
  }

  setAudioPlayer(Results music) async {
    _musicDetails = music;

    await initAudioPlayer();
    notifyListeners();
  }

  initAudioPlayer() async {
    updatePlayerState(MusicPlayerState.LOADING);

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (_playerState == MusicPlayerState.LOADING && p.inMilliseconds > 0) {
        updatePlayerState(MusicPlayerState.PLAYING);
      }

      notifyListeners();
    });

    _audioPlayer.onPlayerStateChanged.listen((AudioPlayerState state) async {
      if (state == AudioPlayerState.PLAYING) {
        updatePlayerState(MusicPlayerState.PLAYING);
        notifyListeners();
      } else if (state == AudioPlayerState.STOPPED ||
          state == AudioPlayerState.COMPLETED) {
        updatePlayerState(MusicPlayerState.STOPPED);
        notifyListeners();
      }
    });
  }

  playSong() async {
    await _audioPlayer.play(currentSong.previewUrl, stayAwake: true);
  }

  playNextSong() async {
    await _audioPlayer.play(currentSong.previewUrl, stayAwake: true);
  }

  playPreviousSong() async {
    await _audioPlayer.play(currentSong.previewUrl, stayAwake: true);
  }

  stopSong() async {
    if (_audioPlayer != null) {
      _positionSubscription?.cancel();
      updatePlayerState(MusicPlayerState.STOPPED);
      await _audioPlayer.stop();
    }
    //await _audioPlayer.dispose();
  }

  bool isPlaying() {
    return getPlayerState() == MusicPlayerState.PLAYING;
  }

  bool isLoading() {
    return getPlayerState() == MusicPlayerState.LOADING;
  }

  bool isStopped() {
    return getPlayerState() == MusicPlayerState.STOPPED;
  }

  fetchAllSongs({
    String searchQuery = "",
  }) async {
    stopSong();
    _musicList = <Results>[];
    allMusicList = <Results>[];
    String urlfor = "https://itunes.apple.com/search?term=" +
        searchQuery +
        "&entity=musicArtist" +
        "&entity=song";
    MusicListModel model = await MusicDownload.fetchAllSongs(urlfor);

    if (model != null && model.results.length > 0) {
      allMusicList.addAll(model.results);
    }
    notifyListeners();
  }

  void updatePlayerState(MusicPlayerState state) {
    _playerState = state;
    notifyListeners();
  }
}
