import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_base/src/bloc/movie_image_bloc/movie_image_event.dart';
import 'package:flutter_bloc_base/src/bloc/movie_image_bloc/movie_image_state.dart';
import 'package:flutter_bloc_base/src/data/movie_repository.dart';

class MovieImageBloc extends Bloc<GetMovieImagesEvent, MovieImageState> {
  final MovieRepository movieRepository;
  Connectivity connectivity = Connectivity();

  MovieImageBloc(this.movieRepository) : super(MovieImageInit()) {
    on<GetMovieImagesEvent>((event, emit) async {
      final connection = await connectivity.checkConnectivity();
      if (connection == ConnectivityResult.none) {
        emit(GetMovieImagesError('Please check the network connection'));
        return;
      }
      try {
        final images = await movieRepository.getMovieImages(event.movieId);
        emit(GetMovieImagesSuccess(images));
        return;
      } on Exception catch (e) {
        emit(GetMovieImagesError(e.toString()));
      }
    });
  }
}
