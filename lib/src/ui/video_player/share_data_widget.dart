import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShareDataWidget extends InheritedWidget {
  final VideoPlayerValue data;

  ShareDataWidget({Key key, this.child, @required this.data})
      : super(key: key, child: child);

  final Widget child;

  static ShareDataWidget of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ShareDataWidget)
        as ShareDataWidget);
  }

  @override
  bool updateShouldNotify(ShareDataWidget oldWidget) {
    print("should notify");
    return true;
  }
}
