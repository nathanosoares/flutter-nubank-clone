import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';

class FloatingCardsBloc {
  var top = BehaviorSubject<double>.seeded(0);
  var topPercentage = BehaviorSubject<double>.seeded(0);
  var size = BehaviorSubject<Size>.seeded(Size(0, 0));
  var position = BehaviorSubject<Offset>.seeded(Offset(0, 0));
  var pageController = BehaviorSubject<PageController>.seeded(PageController());

  void dispose() {
    top.close();
    topPercentage.close();
    size.close();
    position.close();
    pageController.close();
  }
}

abstract class AnimateTopEvent {}

class AnimateTopToUpEvent extends AnimateTopEvent {}

class AnimateTopToDownEvent extends AnimateTopEvent {}
