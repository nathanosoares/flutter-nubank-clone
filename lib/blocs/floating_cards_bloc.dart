import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class FloatingCardsBloc {
  static double pageIndicatorVerticalPadding = 20;
  static double maxFloatingCardHeight = 350;

  var top = BehaviorSubject<double>.seeded(0);
  var maxTop = BehaviorSubject<double>.seeded(0);
  var topAnimationControler = BehaviorSubject<AnimationController>();
  var topPercentage = BehaviorSubject<double>.seeded(0);
  var size = BehaviorSubject<Size>.seeded(Size(0, 0));
  var position = BehaviorSubject<Offset>.seeded(Offset(0, 0));
  var pageController = BehaviorSubject<PageController>.seeded(PageController());
  var height = BehaviorSubject<double>.seeded(0);

  var _animateTopEvent = BehaviorSubject<AnimateTopEvent>();
  Sink<AnimateTopEvent> get animateTopEventSink => _animateTopEvent.sink;

  double get topPercentageToOpacity {
    double opacity = 1.0 - max(0, min(1, topPercentage.value / 100));

    if (opacity.isNaN) {
      opacity = 1.0;
    }

    return opacity;
  }

  FloatingCardsBloc() {
    _animateTopEvent.stream.listen(_mapAnimateTopEventToState);

    size.listen((size) {
      double _height = min(maxFloatingCardHeight, size.height);

      if (_height > size.height - 40 - 4) {
        _height = _height - 40 - 4;
      }

      if (_height < 0) {
        _height = 0;
      }

      height.add(_height);
    });
  }

  void dispose() {
    _animateTopEvent.close();

    topAnimationControler.close();
    top.close();
    maxTop.close();
    topPercentage.close();
    size.close();
    position.close();
    pageController.close();
    height.close();
  }

  void _mapAnimateTopEventToState(AnimateTopEvent event) {
    AnimationController controller = topAnimationControler.value;

    if (controller == null) {
      return;
    }

    controller.reset();

    Animation animation;

    if (event is AnimateTopToUpEvent) {
      animation = Tween<double>(begin: top.value, end: 0).animate(controller);
    } else {
      animation = Tween<double>(begin: top.value, end: maxTop.value)
          .animate(controller);
    }

    Function listener = () {
      top.add(animation.value);
    };

    controller.addListener(listener);

    controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        controller.removeListener(listener);
      }
    });

    controller.forward();
  }
}

abstract class AnimateTopEvent {}

class AnimateTopToUpEvent extends AnimateTopEvent {}

class AnimateTopToDownEvent extends AnimateTopEvent {}
