import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tubi/src/blocs/bloc_event.dart';
import 'package:flutter_tubi/src/blocs/bloc_state.dart';
import 'package:flutter_tubi/src/blocs/search_bloc.dart';
import 'package:flutter_tubi/src/models/movie.dart';
import 'package:flutter_tubi/src/ui/category/movie_category.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  SearchBloc _bloc = SearchBloc();
  String key;

  /// Should request these via the API.
  List<String> defaults = [
    "The Man",
    "Moby Dick",
    "Palm Swings",
    "Condo, The",
    "American Beach House",
    "Bikini Model Academy",
    "Blue My Mind",
    "Baby Fever",
    "All Out Dynfunktion!",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          return SafeArea(
              child: Scaffold(
                  backgroundColor: Color(0xff26262d),
                  body: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _hideKeyboard(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(children: <Widget>[
                          _buildSearchBar(context),
                          Expanded(
                              child: (key == null || key.isEmpty)
                                  ? _buildDefaultList()
                                  : _buildSearchResultList())
                        ]),
                      ))));
        });
  }

  _buildSearchBar(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: TextField(
          controller: TextEditingController(text: key),
          style: TextStyle(fontSize: 16),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              hintText: "Find movies, TV shows & more",
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          onSubmitted: (text) {
            this.key = text;
            _searchAction(key: text);
          },
          onChanged: (text) {
            this.key = text;
            if (text.isEmpty) {
              setState(() {});
            }
          },
        ));
  }

  _buildDefaultList() {
    return Padding(
        padding: EdgeInsets.only(top: 30),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  child: Text(
                "TRENDING SEARCHES",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )),
            ),
            Container(
                margin: EdgeInsets.only(top: 50),
                child: ListView.builder(
                    itemCount: defaults.length,
                    itemBuilder: (context, index) {
                      var value = defaults[index];
                      return Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: GestureDetector(
                              child: Text(
                                value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              onTap: () {
                                _searchAction(key: value);
                              }));
                    },
                    itemExtent: 50))
          ],
        ));
  }

  Widget _buildSearchResultList() {
    final state = _bloc.currentState;

    if (state is BlocStateLoaded) {
      final movies = state.data as List<Movie>;
      return MovieCategoryPage(
          movies: movies, title: "Search Result", showAppBar: false);
    }

    if (state is BlocStateError) {
      return Center(
        child: Text(state.error.toString()),
      );
    }

    return Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey)));
  }

  _searchAction({@required String key}) {
    this.key = key;
    _bloc.dispatch(BlocEventFetch());
  }

  _hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
