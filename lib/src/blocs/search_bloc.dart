import 'package:bloc/bloc.dart';
import 'package:flutter_tubi/src/repositories/http_client.dart';

import './bloc_event.dart';
import './bloc_state.dart';

class SearchBloc extends Bloc<BlocEventFetch, BlocState> {
  final httpClient = ApiClient();
  String key;

  @override
  Stream<BlocState> mapEventToState(
    BlocState currentState,
     event,
  ) async* {
    if (event is BlocEventFetch) {
      yield BlocStateLoading();

      try {
        final movies = await httpClient.movieSearch(key: key);
        yield BlocStateLoaded(data: movies);
      } catch (e) {
        print(e);
        yield BlocStateError(error: e);
      }
    }
  }

  @override
  BlocState get initialState => BlocStateUninitialized();
}
