import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tubi/src/models/models.dart';
import 'package:video_player/video_player.dart';
import './video_duration_toolbar.dart';
import './video_paly_controls.dart';
import 'share_data_widget.dart';

class VideoPlayerPageArguments {
  static final routeName = "videoPlayer";
  final Movie movie;
  final String url;

  VideoPlayerPageArguments({@required this.movie, @required this.url});
}

class VideoPlayerPage extends StatefulWidget {
  final Movie movie;
  final String url;

  VideoPlayerPage({Key key, @required this.movie, @required this.url})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerPageState();
  }
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController _controller;

  ValueNotifier<VideoPlayerValue> _controllerState;

  VoidCallback _controllerValueListener;

  bool _showControls = false;

  _VideoPlayerPageState() {
    _controllerValueListener = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  void initState() {
    super.initState();

    _statusBarEnable(false);

    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          if (_controller.value.initialized) {
            _controller.play();
          }
        });
      });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _controllerState = ValueNotifier(_controller.value);
    _controllerState.addListener(() {
      this.setState(() {});
    });

    _controller.addListener(_controllerValueListener);
  }

  @override
  void deactivate() {
    _controller.removeListener(_controllerValueListener);
    _statusBarEnable(true);

    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _controller.value.initialized;
    return MaterialApp(
        home: GestureDetector(
            onTap: () {
              this.setState(() {
                _showControls = !_showControls;
              });
            },
            child: Stack(
              children: <Widget>[
                ready
                    ? SizedBox.expand(
                        child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ))
                    : Container(),
                (_showControls ? _buildAppBar(context) : Container()),
                Stack(
                  children: <Widget>[
                    _buildControls(context),
                    ready ? Container() : _buildLoading()
                  ],
                )
              ],
            )));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        title: GestureDetector(
            child: Row(
          children: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            Text(widget.movie.title)
          ],
        )));
  }

  Widget _buildLoading() {
    return Center(
        child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))));
  }

  Widget _buildToolBar({VideoPlayerValue value}) {
    return ShareDataWidget(
        data: _controller.value,
        child: VideoDurationToolBar(controller: _controller));
  }

  Widget _buildControls(BuildContext context) {
    if (!_showControls) {
      return Container();
    }
    return SafeArea(
        minimum: EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Stack(children: <Widget>[
          Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: 30),
                height: 60,
                child: ShareDataWidget(
                    data: _controller.value,
                    child: VideoPlayControls(
                      controller: _controller,
                      togglePlayAction: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                      forwardAction: () {
                        setState(() {
                          _forwardAction();
                        });
                      },
                      backwardAction: () {
                        setState(() {
                          _backwardAction();
                        });
                      },
                    )),
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildToolBar(),
          )
        ]));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _controller.dispose();
    super.dispose();
  }

  _backwardAction() {
    if (_controller.value == null) return;

    var position = _controller.value.position.inSeconds;
    position = max(0, position - 15);

    _controller.seekTo(Duration(seconds: position));
  }

  _forwardAction() {
    if (_controller.value == null) return;

    var position = _controller.value.position.inSeconds;
    position = min(_controller.value.duration.inSeconds, position + 15);

    _controller.seekTo(Duration(seconds: position));
  }

  _statusBarEnable(bool enable) {
      SystemChrome.setEnabledSystemUIOverlays(
        enable ? SystemUiOverlay.values : []);
  }
}
