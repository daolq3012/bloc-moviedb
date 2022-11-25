import 'package:connectivity/connectivity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_base/src/bloc/movie_bloc/movie_event.dart';
import 'package:flutter_bloc_base/src/bloc/movie_bloc/movie_state.dart';
import 'package:flutter_bloc_base/src/data/movie_repository.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;
  Connectivity connectivity = Connectivity();

  MovieBloc(this.movieRepository) : super(MovieInit()) {
    on<FetchMovieWithType>((event, emit) async {
      final connectResult = await connectivity.checkConnectivity();
      if (connectResult == ConnectivityResult.none) {
        emit(MovieFetchError('Please check the network connection'));
        return;
      }
      try {
        final movies = await movieRepository.fetchMovies(event.type);
        emit(MovieFetched(movies, event.type));
        return;
      } on Exception catch (e) {
        emit(MovieFetchError(e.toString()));
      }
    });
  }
}
