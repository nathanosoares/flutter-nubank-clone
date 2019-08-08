import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/floating_cards_bloc.dart';
import 'package:provider/provider.dart';

class FloatingCards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FloatingCardsState();
  }
}

class _FloatingCardsState extends State<FloatingCards>
    with SingleTickerProviderStateMixin {
  double maxTop = 0;

  AnimationController _animationController;

  bool _goingUp = false;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    FloatingCardsBloc bloc = Provider.of<FloatingCardsBloc>(context);

    double _height = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: bloc.position.stream,
      initialData: Offset(0, 0),
      builder: (_, AsyncSnapshot<Offset> positionSnapshop) {
        return StreamBuilder(
          stream: bloc.size.stream,
          initialData: Size(0, 0),
          builder: (_, AsyncSnapshot<Size> sizeSnapshot) {
            return StreamBuilder(
              stream: bloc.top.stream,
              initialData: 0.0,
              builder: (_, AsyncSnapshot<double> topSnapshop) {
                maxTop = _height -
                    positionSnapshop.data.dy -
                    sizeSnapshot.data.height * 0.4;

                double currentToPercentage = 100 / maxTop * bloc.top.value;

                bloc.topPercentage.add(currentToPercentage);

                return Positioned(
                  top: topSnapshop.data,
                  width: sizeSnapshot.data.width,
                  height: sizeSnapshot.data.height,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (bloc.top.value == maxTop) {
                        _animate(context, AnimateDirection.UP);
                      }
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      if (_animationController.isAnimating) {
                        _animationController.stop(canceled: true);
                      }

                      if (bloc.top.value + details.delta.dy > 0 &&
                          bloc.top.value <= maxTop) {
                        bool goingUp = false;

                        if (details.delta.dy < 0) {
                          goingUp = true;
                        }

                        double newTop = max(
                            0, min(maxTop, bloc.top.value + details.delta.dy));

                        bloc.top.add(newTop);

                        setState(() {
                          _goingUp = goingUp;
                        });
                      }
                    },
                    onPanEnd: (DragEndDetails details) {
                      if (_goingUp || currentToPercentage <= 20) {
                        _animate(context, AnimateDirection.UP);
                      } else {
                        _animate(context, AnimateDirection.DOWN);
                      }
                    },
                    child: buildPageView(context),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  PageView buildPageView(BuildContext context) {
    FloatingCardsBloc bloc = Provider.of<FloatingCardsBloc>(context);

    return PageView.builder(
      controller: bloc.pageController.value,
      itemCount: 3,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(2))),
        ),
      ),
    );
  }

  _animate(BuildContext context, AnimateDirection direction) {
    FloatingCardsBloc bloc = Provider.of<FloatingCardsBloc>(context);

    _animationController.reset();

    Animation animation;

    if (direction == AnimateDirection.UP) {
      animation = Tween<double>(begin: bloc.top.value, end: 0)
          .animate(_animationController);

      setState(() {
        this._goingUp = false;
      });
    } else {
      animation = Tween<double>(begin: bloc.top.value, end: maxTop)
          .animate(_animationController);
    }

    Function listener = () {
      bloc.top.add(animation.value);
    };

    _animationController.addListener(listener);

    _animationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _animationController.removeListener(listener);
      }
    });

    _animationController.forward();
  }
}

enum AnimateDirection { UP, DOWN }
