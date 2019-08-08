import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';

class FloatingCardsBloc {
  var top = BehaviorSubject<double>.seeded(0);
  var topPercentage = BehaviorSubject<double>.seeded(0);
  var size = BehaviorSubject<Size>.seeded(Size(0, 0));
  var position = BehaviorSubject<Offset>.seeded(Offset(0, 0));
  var pageController = BehaviorSubject<PageController>.seeded(PageController());

  final _dragUpdateDetailsController = StreamController<DragUpdateDetails>();

  Sink get dragUpdateDetailsSink => _dragUpdateDetailsController.sink;

  FloatingCardsBloc() {
    _dragUpdateDetailsController.stream.listen(_onDragUpdateDetails);
  }

  void _onDragUpdateDetails(DragUpdateDetails details) {
    top.add(top.value + details.delta.dy);
  }

  void dispose() {
    _dragUpdateDetailsController.close();

    top.close();
    topPercentage.close();
    size.close();
    position.close();
    pageController.close();
  }
}
