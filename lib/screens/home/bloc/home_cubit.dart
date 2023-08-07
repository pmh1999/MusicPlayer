import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:flutter_radio_player/models/frp_source_modal.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musicplayer/api/api.dart';
import 'package:musicplayer/const.dart';
import 'package:musicplayer/screens/home/bloc/home_state.dart';

import '../../../models/song.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(super.initialState);
  List<Song> list = [];
  var player = AudioPlayer();
  final FlutterRadioPlayer _flutterRadioPlayer = FlutterRadioPlayer();
  List<MediaSources> listSongs = [];
  late FRPSource frpSource;

  Future<void> fetch() async {
    emit(Loading([]));
    list = await Api().fetchChart();
    init();
    emit(Success(list));
  }

  void init() {
    _flutterRadioPlayer.initPlayer();
    list.forEach((song) {
      var tmp = song.link?.split('/');
      String code = tmp![3].replaceAll('.html', '/128');
      listSongs.add(MediaSources(
          url: STREAMING_URL + code,
          description: song.performer,
          isPrimary: song == list.first ? true : false,
          title: song.name,
          isAac: true));
    });
    frpSource = FRPSource(mediaSources: listSongs);
  }

  void playMusic(Song song) async {
    _flutterRadioPlayer.addMediaSources(frpSource!);
    _flutterRadioPlayer.seekToMediaSource((song.position ?? 2) - 1, true);

    emit(NowPlaying(list, song: song));
  }

  void pause(Song song) {
    _flutterRadioPlayer.pause();
    emit(OnPause(list, song: song));
  }

  void resume(Song song) {
    _flutterRadioPlayer.playOrPause();
    emit(NowPlaying(list, song: song));
  }

  void stop() {
    _flutterRadioPlayer.pause();
    emit(OnStop(list));
  }

  void search(String searchString) {
    List<Song> searchList = [];
    list.forEach(
      (element) {
        if (element.name!.toLowerCase().contains(searchString.toLowerCase()) ||
            element.performer!
                .toLowerCase()
                .contains(searchString.toLowerCase())) searchList.add(element);
      },
    );
    emit(Search(searchList));
  }
}
