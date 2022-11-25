import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc_base/src/bloc/base_bloc.dart';
import 'package:flutter_bloc_base/src/bloc/movie_bloc/movie_event.dart';
import 'package:flutter_bloc_base/src/bloc/movie_bloc/movie_state.dart';

import '../../data/movie_repository.dart';

class MovieBlocSp extends BaseBloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  final Connectivity connectivity = Connectivity();

  MovieBlocSp(this.movieRepository) : super(MovieInit()) {
    eventController.stream.listen((MovieEvent event) async {
      // người ta thường tách hàm này ra 1 hàm riêng và đặt tên là: mapEventToState
      // đúng như cái tên, hàm này nhận event xử lý và cho ra output là state

      if (event is FetchMovieWithType) {
        try {
          final movies = await movieRepository.fetchMovies(event.type);
          state = MovieFetched(movies, event.type);
        } on Exception catch (e) {
          state = MovieFetchError(e.toString());
        }
      }

      final connectResult = await connectivity.checkConnectivity();
      if (connectResult == ConnectivityResult.none) {
        state = MovieFetchError('Please check the network connection');
      }

      // add state mới vào stateController để bên UI nhận được
      stateController.sink.add(state);
    });
  }

  @override
  StreamController<MovieEvent> provideEventController() {
    return StreamController<MovieEvent>();
  }

  @override
  StreamController<MovieState> provideStateController() {
    return StreamController<MovieState>();
  }
}
