import 'package:bloc/bloc.dart';
import 'package:flutter_tubi/src/repositories/http_client.dart';
import 'package:meta/meta.dart';

import './bloc_event.dart';
import './bloc_state.dart';

class MovieDetailsBloc extends Bloc<BlocEventFetch, BlocState> {
  final httpClient = ApiClient();
  final String contentId;

  MovieDetailsBloc({@required this.contentId});

  @override
  Stream<BlocState> mapEventToState(
    BlocState currentState,
     event,
  ) async* {
    if (event is BlocEventFetch) {
      yield BlocStateLoading();

      try {
        final movie = await httpClient.fetchMovieDetails(contentId: contentId);
        yield BlocStateLoaded(data: movie);
      } catch (e) {
        print(e);
        yield BlocStateError(error: e);
      }
    }
  }

  @override
  BlocState get initialState => BlocStateUninitialized();
}
