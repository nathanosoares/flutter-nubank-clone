import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nubank/blocs/floating_cards_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class FloatingCards extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FloatingCardsState();
  }
}

class _FloatingCardsState extends State<FloatingCards>
    with SingleTickerProviderStateMixin {
  bool _goingUp = false;

  AnimationController _animationController;

  double top = 0;
  double maxTop = 0;
  Offset position = Offset(0, 0);
  double height = 0;
  double currentToPercentage = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    FloatingCardsBloc bloc = Provider.of<FloatingCardsBloc>(context);

    bloc.topAnimationControler.add(_animationController);

    double _height = MediaQuery.of(context).size.height;

    Observable combined = Observable.combineLatest4(
        bloc.position.stream,
        bloc.size.stream,
        bloc.top.stream,
        bloc.height.stream, (position, size, top, height) {
      double maxTop = _height - position.dy - 120;
      double currentToPercentage = 100 / maxTop * bloc.top.value;

      bloc.maxTop.add(maxTop);
      bloc.topPercentage.add(currentToPercentage);

      setState(() {
        this.top = top + ((size.height - height) / 2) - 20;
        this.currentToPercentage = currentToPercentage;
        this.height = height;
        this.maxTop = maxTop;
      });
    });

    return StreamBuilder(
      stream: combined,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, this.top),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: this.height,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: _buildPageView(context),
            onTap: () {
              if (bloc.top.value == this.maxTop) {
                bloc.animateTopEventSink.add(AnimateTopToUpEvent());
              }
            },
            onPanUpdate: (DragUpdateDetails details) {
              if (bloc.topAnimationControler.value.isAnimating) {
                bloc.topAnimationControler.value.stop(canceled: true);
              }

              if (bloc.top.value + details.delta.dy > 0 &&
                  bloc.top.value <= this.maxTop) {
                bool goingUp = false;

                if (details.delta.dy < 0) {
                  goingUp = true;
                }

                double newTop =
                    max(0, min(this.maxTop, bloc.top.value + details.delta.dy));

                bloc.top.add(newTop);

                setState(() {
                  _goingUp = goingUp;
                });
              }
            },
            onPanEnd: (DragEndDetails details) {
              if (_goingUp || this.currentToPercentage <= 20) {
                bloc.animateTopEventSink.add(AnimateTopToUpEvent());
              } else {
                bloc.animateTopEventSink.add(AnimateTopToDownEvent());
              }
            },
          ),
        ),
      ),
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

class PageIndicator extends StatefulWidget {
  final PageController controller;

  PageIndicator({
    @required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<PageIndicator> {
  PageController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.addListener(scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.hasClients) {
      return Container();
    }

    CustomPainter indicatorPainter = CirclePainter(
      color: Color.fromRGBO(255, 255, 255, .3),
      selectedColor: Colors.white,
      count: 3,
      page: widget.controller.page ?? controller.initialPage.toDouble(),
      padding: 4,
      radius: 4 / 2,
    );

    return CustomPaint(
      painter: indicatorPainter,
    );
  }

  void scrollListener() {
    setState(() {});
  }
}

class CirclePainter extends CustomPainter {
  double page;
  int count;
  Color color;
  Color selectedColor;
  double radius;
  double padding;
  Paint _circlePaint;
  Paint _selectedPaint;

  CirclePainter({
    this.page = 0.0,
    this.count = 0,
    this.color = Colors.white,
    this.selectedColor = Colors.grey,
    this.radius = 12.0,
    this.padding = 5.0,
  }) {
    _circlePaint = Paint();
    _circlePaint.color = color;

    _selectedPaint = Paint();
    _selectedPaint.color = selectedColor;

    this.page ??= 0.0;
    this.count ??= 0;
    this.color ??= Colors.white;
    this.selectedColor ??= Colors.grey;
    this.radius ??= 12.0;
    this.padding ??= 5.0;
  }

  double get totalWidth => count * radius * 2 + padding * (count - 1);

  @override
  void paint(Canvas canvas, Size size) {
    var centerWidth = size.width / 2;

    var startX = centerWidth - totalWidth / 2;

    for (var i = 0; i < count ?? 0; i++) {
      var x = startX + i * (radius * 2 + padding) + radius;
      canvas.drawCircle(Offset(x, radius), radius, _circlePaint);
    }

    var selectedX = startX + page * (radius * 2 + padding) + radius;
    canvas.drawCircle(Offset(selectedX, radius), radius, _selectedPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
