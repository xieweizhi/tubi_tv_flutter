import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tubi/src/blocs/bloc_event.dart';
import 'package:flutter_tubi/src/blocs/bloc_state.dart';
import 'package:flutter_tubi/src/blocs/movie_details_bloc.dart';
import 'package:flutter_tubi/src/repositories/http_client.dart';
import 'package:flutter_tubi/src/repositories/repositories.dart';
import 'package:flutter_tubi/src/ui/home/home_movie_scroll_row.dart';
import 'package:flutter_tubi/src/ui/video_player/video_player.dart';
import '../../models/models.dart';
import '../../blocs/related_movies/bloc.dart';

class MoviePageArguments {
  static final routeName = "movies";
  final Movie movie;

  MoviePageArguments(this.movie);
}

class MoviePage extends StatefulWidget {
  final Movie movie;

  const MoviePage({Key key, @required this.movie}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MoviePageState();
  }
}

class _MoviePageState extends State<MoviePage> {
  Movie get movie => widget.movie;
  RelatedBloc _bloc;
  MovieDetailsBloc _movieDtailsBloc;

  final apiClient = ApiClient();

  @override
  void initState() {
    super.initState();

    var repo = RelatedRepository();
    _bloc = RelatedBloc(repository: repo, id: movie.id);
    _bloc.dispatch(FetchRelatedMoviesEvent());

    _movieDtailsBloc = MovieDetailsBloc(contentId: movie.id);
    _movieDtailsBloc.dispatch(BlocEventFetch());
  }

  @override
  Widget build(BuildContext context) {
    var topImageHeight = MediaQuery.of(context).size.width * 0.7;

    return BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          final isPortraitMode =
              MediaQuery.of(context).orientation == Orientation.portrait;

          return Scaffold(
              backgroundColor: Color(0xff26262d),
              appBar: AppBar(
                backgroundColor: Color(0xff26262d),
                title: Text('${movie.title}'),
              ),
              body: SafeArea(
                  child: Stack(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: _buildImageView(
                          context: context, height: topImageHeight)),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        padding: EdgeInsets.only(
                            top: isPortraitMode ? (topImageHeight - 160) : 30),
                        children: <Widget>[
                          _buildInfoRow(context),
                          _buildControlsRow(context),
                          _buildDescriptionRow(context),
                          Container(
                            child: _buildRelatedRow(state: state),
                          )
                        ],
                      ))
                ],
              )));
        });
  }

  Widget _buildImageView({BuildContext context, double height}) {
    return SizedBox(
        child: Stack(children: <Widget>[
      Container(
          height: height,
          width: MediaQuery.of(context).size.width,
          child: CachedNetworkImage(
              imageUrl: movie.backgrounds.first,
              placeholder: (context, url) {
                return Center(
                    child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey))));
              },
              fit: BoxFit.cover)),
      SizedBox.expand(
          child: Container(
              height: 300,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      stops: [0.5, 1.0],
                      colors: [Colors.black38, Color(0xff26262d)])))),
    ]));
  }

  Widget _buildInfoRow(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    width: 124,
                    height: 180,
                    child: CachedNetworkImage(
                        imageUrl: movie.posterarts.first, fit: BoxFit.cover)),
                SizedBox(width: 10),
                SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('${movie.title}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 26)),
                        SizedBox(height: 30),
                        (movie.year > 0
                            ? Text(
                                '(${movie.year}) · ${this._formatDuration(movie.duration)}\n${movie.tags.join()} ',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12))
                            : Text(''))
                      ],
                    )),
              ],
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: _ratingText(movie.ratings))
          ],
        ));
  }

  Widget _buildControlsRow(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(children: <Widget>[
                SizedBox(
                    width: 60,
                    height: 60,
                    child: IconButton(
                      onPressed: () {},
                      icon: Image.asset("assets/icons/add_to_queue_normal.png"),
                    )),
                Text('My Queue', style: TextStyle(fontSize: 12)),
              ]),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: IconButton(
                    onPressed: () {
                      final currentState = this._movieDtailsBloc.currentState;
                      if (currentState is BlocStateLoading) {
                        _showAlertDialog(context,
                            title: 'Loading',
                            message:
                                'Movie content is loading. Please try again later.');
                      }

                      if (currentState is BlocStateError) {
                        _showAlertDialog(context,
                            title: 'Error',
                            message: currentState.error.toString());
                      }

                      if (currentState is BlocStateLoaded) {
                        var theMovie = currentState.data as Movie;
                        if (theMovie.videoResources.isNotEmpty &&
                            theMovie.videoResources[0].manifest.url != null) {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                              VideoPlayerPageArguments.routeName,
                              arguments: VideoPlayerPageArguments(
                                  movie: theMovie,
                                  url:
                                      theMovie.videoResources[0].manifest.url));
                        } else {
                          _showAlertDialog(context,
                              title: 'Error',
                              message: 'Error loading movie resource.');
                        }
                      }
                    },
                    icon: Image.asset("assets/icons/play_large_normal.png"),
                  )),
              Column(
                children: <Widget>[
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset("assets/icons/share_normal.png"),
                      )),
                  Text('Share', style: TextStyle(fontSize: 12)),
                ],
              )
            ]));
  }

  Widget _buildDescriptionRow(BuildContext context) {
    var textSpans = List<TextSpan>();
    if (movie.directors != null && movie.directors.isNotEmpty) {
      textSpans.addAll([
        TextSpan(text: 'Director    ', style: TextStyle(color: Colors.grey)),
        TextSpan(
            text: movie.directors.join(', '),
            style: TextStyle(color: Colors.white))
      ]);
    }

    if (movie.actors != null && movie.actors.isNotEmpty) {
      textSpans.addAll([
        TextSpan(text: '\n'),
        TextSpan(text: '\n'),
        TextSpan(text: 'Starring    ', style: TextStyle(color: Colors.grey)),
        TextSpan(
            text: movie.actors.join(', '),
            style: TextStyle(color: Colors.white, height: 1.2))
      ]);
    }

    var richText = RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.apply(),
          children: textSpans,
        ));

    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            movie.description,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 40,
          ),
          richText
        ],
      ),
    );
  }

  Widget _ratingText(List<Map<String, String>> ratings) {
    var value = ratings.first['value'] ?? '';
    return ClipRRect(
        borderRadius: BorderRadius.circular(2.0),
        child: Container(
            color: Color(0xff474747),
            child: Padding(
                padding: EdgeInsets.all(6),
                child: Text(
                  value,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                ))));
  }

  Widget _buildRelatedRow({@required RelatedState state}) {
    if (state is RelatedLoaded) {
      if (state.movies.isEmpty) {
        return Container();
      }
      return Column(children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16, top: 16),
            child: Text('You May Also Like',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 20),
            height: 270,
            child: HomeMovieScrollRow(movies: state.movies, key: UniqueKey()))
      ]);
    }

    if (state is RelatedError) {
      return Container();
    }
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 30.0),
        child: Center(
            child: Container(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)))));
  }

  _showAlertDialog(BuildContext context, {String title, String message}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  String _formatDuration(int seconds) {
    if (seconds == null) return '';
    if (seconds <= 60) {
      return '$seconds sec';
    }
    if (seconds <= 60 * 60) {
      return '${(seconds / 60).floor()} min';
    }
    return '${(seconds / 60 / 60).round()} h ${(seconds / 60 % 60).floor()} min';
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _movieDtailsBloc.dispose();
  }
}
