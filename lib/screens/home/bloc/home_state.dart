import 'package:musicplayer/screens/home/home.dart';

import '../../../models/song.dart';

class HomeState {
  final List<Song> list;
  Song? song;
  HomeState(this.list, {this.song});
  @override
  List<Object> get props => [list];
}

class Loading extends HomeState {
  Loading(super.list);
}

class Success extends HomeState {
  Success(super.list);
}

class Search extends HomeState {
  Search(super.list);
}

class NowPlaying extends HomeState {
  NowPlaying(super.list, {super.song});
}

class OnPause extends HomeState {
  OnPause(super.list, {super.song});
}

class OnStop extends HomeState {
  OnStop(super.list);
}
