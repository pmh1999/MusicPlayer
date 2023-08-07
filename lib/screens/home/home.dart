import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayer/screens/home/bloc/home_state.dart';

import '../../models/song.dart';
import 'bloc/home_cubit.dart';

class Home extends StatelessWidget {
  late HomeCubit _cubit;
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) {
          _cubit = HomeCubit(Loading([]));
          _cubit.fetch();
          return _cubit;
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Zing MP3 TOP 100"),
              actions: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: InkWell(
                        child: const Text("Reload"),
                        onTap: () {
                          _cubit.fetch();
                        }),
                  ),
                )
              ],
            ),
            body: BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
              if (state is Loading) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all()),
                        child: TextField(
                          onChanged: (value) {
                            _cubit.search(value);
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            hintText: 'Search Title or Artist',
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              bottom: (state is NowPlaying || state is OnPause)
                                  ? 86
                                  : 0),
                          padding: const EdgeInsets.only(top: 58),
                          child: ListView(
                              children: state.list
                                  .map((s) => ListTile(
                                        dense: false,
                                        leading: Hero(
                                            tag: s.name ?? "",
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.network(
                                                s.thumbnail ?? "",
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                        title: Text(s.name ?? ""),
                                        subtitle: Text(
                                          s.performer ?? "",
                                        ),
                                        onTap: () {
                                          _cubit.playMusic(s);
                                        },
                                      ))
                                  .toList())),
                      (state is NowPlaying || state is OnPause)
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: NowPLayingWidget(
                                song: state.song ?? Song(),
                                onPause: () {
                                  if (state is OnPause) {
                                    _cubit.resume(state.song ?? Song());
                                  } else
                                    _cubit.pause(state.song ?? Song());
                                },
                                onStop: () {
                                  _cubit.stop();
                                },
                                isPause: state is OnPause,
                              ))
                          : SizedBox()
                    ],
                  ),
                );
              }
            }),
          ),
        ));
  }
}

class NowPLayingWidget extends StatelessWidget {
  late Song song;
  Function onPause;
  Function onStop;
  late bool isPause;
  NowPLayingWidget(
      {required this.song,
      required this.onPause,
      required this.onStop,
      required this.isPause});



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: Color(0xffA2B5B2), borderRadius: BorderRadius.circular(20.0)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Song cover
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              song.thumbnail ?? "",
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 15,
          ),

          // Title and artist
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Title
                Text(
                  song.name ?? "  ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 1),
                  maxLines: 3,
                ),
                // Artist
                Text(song.performer ?? "",
                    style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Center(
                  child: GestureDetector(
                    onTap: () {
                      onPause.call();
                    },
                    child: Icon(
                      isPause
                          ? Icons.play_circle_outlined
                          : Icons.pause_circle_outline,
                      color: const Color(0xff9B6A6C),
                      size: 30.0,
                    ),
                  ),
               ),

          SizedBox(width: 8),

          Center(
            child: GestureDetector(
              onTap: () {
                onStop.call();
              },
              child: const Icon(
                Icons.cancel_outlined,
                color: Color(0xff9B6A6C),
                size: 30.0,
              ),
            ),
          ),

          //
        ],
      ),
    );
  }
}
