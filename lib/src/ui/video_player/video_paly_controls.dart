import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef VideoPlayDidButtonAction = void Function();

class VideoPlayControls extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback togglePlayAction;
  final VoidCallback backwardAction;
  final VoidCallback forwardAction;

  const VideoPlayControls(
      {Key key,
      @required this.controller,
      this.togglePlayAction,
      this.backwardAction,
      this.forwardAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayControlsState();
  }
}

class _VideoPlayControlsState extends State<VideoPlayControls> {

  @override
  Widget build(BuildContext context) {
    final playing = widget.controller.value.isPlaying ?? false;
    return SizedBox.expand(
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      FlatButton(
        onPressed: () {
          widget.backwardAction();
        },
        child: SizedBox(
          width: 30,
          height: 30,
          child: Image.asset(
            "assets/icons/rew_15_normal.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
      FlatButton(
        onPressed: () {
          widget.togglePlayAction();
        },
        child: SizedBox(
          width: 50,
          height: 50,
          child: Image.asset(
            "assets/icons/${playing ? "pause_normal.png" : "play_large_normal.png"}",
            fit: BoxFit.fill,
          ),
        ),
      ),
      FlatButton(
        onPressed: () {
          widget.forwardAction();
        },
        child: SizedBox(
          width: 30,
          height: 30,
          child: Image.asset(
            "assets/icons/fwd_15_normal.png",
            fit: BoxFit.fill,
          ),
        ),
      ),
    ]));
  }
}
