import 'package:flutter/material.dart';
import 'src/app.dart';

import 'package:bloc/bloc.dart';

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();

  return runApp(App());
}

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print('Transition: $transition');
  }
}
