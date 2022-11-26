import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc_base/src/bloc/movie_image_bloc/movie_image_event.dart';
import 'package:flutter_bloc_base/src/bloc/movie_image_bloc/movie_image_state.dart';
import 'package:flutter_bloc_base/src/data/movie_repository.dart';

import '../base_bloc.dart';

class MovieImageBloc extends BaseBloc<GetMovieImagesEvent, MovieImageState> {
  final MovieRepository movieRepository;
  Connectivity connectivity = Connectivity();

  MovieImageBloc(this.movieRepository) : super(MovieImageInit()) {
    eventController.stream.listen((event) async {
      final connection = await connectivity.checkConnectivity();
      if (connection == ConnectivityResult.none) {
        state = GetMovieImagesError('Please check the network connection');
      }

      try {
        final images = await movieRepository.getMovieImages(event.movieId);
        state = GetMovieImagesSuccess(images);
      } on Exception catch (e) {
        state = GetMovieImagesError(e.toString());
      }

      stateController.sink.add(state);
    });
  }

  void getMovieImage(int movieId) {
    eventController.sink.add(GetMovieImagesEvent(movieId));
  }
}
