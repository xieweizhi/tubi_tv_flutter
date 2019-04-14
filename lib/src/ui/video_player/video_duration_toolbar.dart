import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'share_data_widget.dart';

class VideoDurationToolBar extends StatefulWidget {
  final VideoPlayerController controller;

  const VideoDurationToolBar({Key key, @required this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VideoDurationToolBarState();
  }
}

class _VideoDurationToolBarState extends State<VideoDurationToolBar> {
  VideoPlayerController get controller => widget.controller;
  VoidCallback listener;

  _VideoDurationToolBarState() {
    listener = () {
      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void deactivate() {
    controller.removeListener(listener);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    print("shared: "+ShareDataWidget.of(context).data.toString());
    return Container(
      height: 30,
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        SizedBox(
            child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 120),
                child: Text(_position(value: ShareDataWidget.of(context).data),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                    textAlign: TextAlign.right))),
        Expanded(
            child: VideoProgressIndicator(
          widget.controller,
          allowScrubbing: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
        )),
        SizedBox(
            child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 120),
                child: Text(_duration(value: ShareDataWidget.of(context).data),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                    textAlign: TextAlign.left)))
      ]),
    );
  }

  String _duration({@required VideoPlayerValue value}) {
    final pos = value.position.inSeconds;
    final seconds = value.duration.inSeconds - pos;
    return "${seconds / 60 ~/ 60}:${(seconds / 60 % 60).toInt()}:${seconds % 60}";
  }

  String _position({@required VideoPlayerValue value}) {
    final seconds = value.position.inSeconds;
    return "${seconds / 60 ~/ 60}:${(seconds / 60 % 60).toInt()}:${seconds % 60}";
  }
}
