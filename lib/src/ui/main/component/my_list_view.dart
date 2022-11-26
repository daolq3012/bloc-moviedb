import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_base/src/bloc/movie_bloc/movie_state.dart';
import 'package:flutter_bloc_base/src/data/repository/movie_repository_impl.dart';
import 'package:flutter_bloc_base/src/models/models.dart';
import 'package:flutter_bloc_base/src/ui/theme/colors.dart';
import 'package:flutter_bloc_base/src/ui/widget/error_page.dart';
import 'package:flutter_gen/gen_l10n/resource.dart';

import '../../../bloc/movie_bloc/movie_bloc_sp.dart';

class MyListView extends StatefulWidget {
  final Function(Movie) actionOpenMovie;
  final Function actionLoadAll;

  const MyListView(
      {Key key, @required this.actionOpenMovie, @required this.actionLoadAll})
      : super(key: key);

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  MovieBlocSp _movieBloc;

  @override
  void initState() {
    super.initState();
    _movieBloc = MovieBlocSp(MovieRepositoryImpl());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _movieBloc.fetchMovieTopRate();
    });
  }

  @override
  void dispose() {
    _movieBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieState>(
      stream: _movieBloc.stateController.stream,
      initialData: MovieStateInit(),
      builder: (context, snapshot) {
        var state = snapshot.data;
        if (state is MovieStateInit) {
          return Center(child: const CircularProgressIndicator());
        } else if (state is MovieFetchError) {
          return ErrorPage(
            message: state.message,
            retry: () {
              _movieBloc.fetchMovieTopRate();
            },
          );
        } else if (state is MovieFetched) {
          return _createMyListView(context, state.movies);
        } else {
          return Text(AppLocalizations.of(context).cannotSupport);
        }
      },
    );
  }

  Widget _createMyListView(BuildContext context, List<Movie> movies) {
    final contentHeight = 4.0 * (MediaQuery.of(context).size.width / 2.4) / 3;
    return Container(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20.0, right: 16.0),
            height: 48.0,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    AppLocalizations.of(context).myList,
                    style: TextStyle(
                      color: groupTitleColor,
                      fontSize: 16.0,
                      fontFamily: 'Muli',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward, color: groupTitleColor),
                  onPressed: () {
                    return widget.actionLoadAll;
                  },
                )
              ],
            ),
          ),
          Container(
            height: contentHeight,
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return _createMyListItem(context, movies[index]);
              },
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => VerticalDivider(
                color: Colors.transparent,
                width: 6.0,
              ),
              itemCount: movies.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _createMyListItem(BuildContext context, Movie movie) {
    final width = MediaQuery.of(context).size.width / 2.6;
    return InkWell(
      onTap: () {
        widget.actionOpenMovie(movie);
      },
      child: Container(
        width: width,
        height: double.infinity,
        padding: EdgeInsets.only(bottom: 20.0),
        child: Card(
          elevation: 10.0,
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            width: width,
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                imageUrl: 'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                width: width,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
