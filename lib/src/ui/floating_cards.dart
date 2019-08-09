import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nubank/src/blocs/floating_cards_bloc.dart';
import 'package:provider/provider.dart';

class FloatingCards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FloatingCardsState();
  }
}

class _FloatingCardsState extends State<FloatingCards>
    with SingleTickerProviderStateMixin {
  bool _goingUp = false;

  AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 150));
  }

  @override
  Widget build(BuildContext context) {
    FloatingCardsBloc bloc = Provider.of<FloatingCardsBloc>(context);

    if (bloc.topAnimationControler.value == null) {
      bloc.topAnimationControler.add(animationController);
    }

    double _height = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: bloc.position.stream,
      initialData: bloc.position.value,
      builder: (_, AsyncSnapshot<Offset> positionSnapshot) {
        return StreamBuilder(
          stream: bloc.size.stream,
          initialData: bloc.size.value,
          builder: (_, AsyncSnapshot<Size> sizeSnapshot) {
            return StreamBuilder(
              stream: bloc.top.stream,
              initialData: bloc.top.value,
              builder: (_, AsyncSnapshot<double> topSnapshop) {
                double maxTop = _height - positionSnapshot.data.dy - 120;

                double currentToPercentage = 100 / maxTop * bloc.top.value;

                bloc.maxTop.add(maxTop);
                bloc.topPercentage.add(currentToPercentage);

                return StreamBuilder(
                  stream: bloc.height.stream,
                  initialData: bloc.height.value,
                  builder: (_, AsyncSnapshot<double> heightSnapshot) {
                    double top = topSnapshop.data +
                        ((sizeSnapshot.data.height - heightSnapshot.data) / 2) -
                        20;

                    return Transform.translate(
                      offset: Offset(0, top),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: heightSnapshot.data,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            if (bloc.top.value == maxTop) {
                              bloc.animateTopEventSink
                                  .add(AnimateTopToUpEvent());
                            }
                          },
                          onPanUpdate: (DragUpdateDetails details) {
                            if (bloc.topAnimationControler.value.isAnimating) {
                              bloc.topAnimationControler.value
                                  .stop(canceled: true);
                            }

                            if (bloc.top.value + details.delta.dy > 0 &&
                                bloc.top.value <= maxTop) {
                              bool goingUp = false;

                              if (details.delta.dy < 0) {
                                goingUp = true;
                              }

                              double newTop = max(
                                  0,
                                  min(maxTop,
                                      bloc.top.value + details.delta.dy));

                              bloc.top.add(newTop);

                              setState(() {
                                _goingUp = goingUp;
                              });
                            }
                          },
                          onPanEnd: (DragEndDetails details) {
                            if (_goingUp || currentToPercentage <= 20) {
                              bloc.animateTopEventSink
                                  .add(AnimateTopToUpEvent());
                              // _animate(context, AnimateDirection.UP);
                            } else {
                              bloc.animateTopEventSink
                                  .add(AnimateTopToDownEvent());
                              // _animate(context, AnimateDirection.DOWN);
                            }
                          },
                          child: _buildPageView(context),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  PageView _buildPageView(BuildContext context) {
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
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
      ),
    );
  }
}
