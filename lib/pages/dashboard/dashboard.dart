import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nubank/pages/dashboard/widgets/footer_cards.dart';
import 'package:nubank/pages/dashboard/widgets/logo.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DashboardState();
  }
}

class _DashboardState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  GlobalKey _keyFloatingCards = GlobalKey();

  AnimationController controller;
  bool floatingCardsToUp = false;
  double floatingCardsYOffset = 0;
  double floatingCardsInitialYOffset = 0;
  double floatingCardsMaxYOffset = 0;
  double get floatingCardsYPercentege {
    return floatingCardsYOffset / floatingCardsMaxYOffset;
  }

  double get footerCardsOpacity {
    double opacity = 1.0 - max(0, min(1, floatingCardsYPercentege));

    if (opacity.isNaN) {
      opacity = 1.0;
    }

    return opacity;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 150),
    );
  }

  _afterLayout(_) {
    _getPositions();
  }

  _getPositions() {
    RenderBox renderFloatingCards =
        _keyFloatingCards.currentContext.findRenderObject();

    setState(() {
      this.floatingCardsInitialYOffset =
          renderFloatingCards.localToGlobal(Offset.zero).dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      this.floatingCardsMaxYOffset = MediaQuery.of(context).size.height -
          this.floatingCardsInitialYOffset -
          80;
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(130, 38, 158, 1),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildHeader(context),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Opacity(
                    opacity: floatingCardsYPercentege,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: LogoWidget('a'),
                    ),
                  ),
                  Opacity(
                    opacity: footerCardsOpacity,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: buildFooterCards(context),
                      ),
                    ),
                  ),
                  // BackdropInfo(),
                  buildFloatingCards(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildHeader(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (floatingCardsYPercentege == 1.0) {
          _animateFloatingCards(AnimeteFloatingCardsToTopEvent());
        } else if (floatingCardsYPercentege == 0) {
          _animateFloatingCards(AnimeteFloatingCardsToDownEvent());
        }
      },
      child: Column(
        children: <Widget>[
          LogoWidget('Nathan'),
          Transform.rotate(
            angle: -(pi / 100 * floatingCardsYPercentege * 100),
            child: Opacity(
              opacity: 0.5,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildFooterCards(BuildContext context) {
    return FooterCards();
  }

  buildFloatingCards(BuildContext context) {
    return Transform.translate(
      key: _keyFloatingCards,
      offset: Offset(0, this.floatingCardsYOffset),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          if (this.controller.isAnimating) {
            this.controller.stop(canceled: true);
          }

          setState(() {
            this.floatingCardsYOffset = min(this.floatingCardsMaxYOffset,
                max(0, this.floatingCardsYOffset + details.delta.dy));

            this.floatingCardsToUp = details.delta.dy < 0;
          });
        },
        onPanEnd: (DragEndDetails details) {
          if (this.floatingCardsToUp || this.floatingCardsYPercentege <= 0.2) {
            _animateFloatingCards(AnimeteFloatingCardsToTopEvent());
          } else {
            _animateFloatingCards(AnimeteFloatingCardsToDownEvent());
          }
        },
        onTap: () {
          if (this.floatingCardsYPercentege == 1) {
            _animateFloatingCards(AnimeteFloatingCardsToTopEvent());
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            color: Colors.white,
            height: min(MediaQuery.of(context).size.height / 2, 400),
            child: LogoWidget(''),
          ),
        ),
      ),
    );
  }

  _animateFloatingCards(AnimateFloatingCardsEvent event) {
    if (controller == null) {
      return;
    }

    controller.reset();

    Animation animation;

    if (event is AnimeteFloatingCardsToTopEvent) {
      animation = Tween<double>(begin: floatingCardsYOffset, end: 0)
          .animate(controller);
    } else {
      animation = Tween<double>(
              begin: floatingCardsYOffset, end: floatingCardsMaxYOffset)
          .animate(controller);
    }

    Function listener = () {
      setState(() {
        floatingCardsYOffset = animation.value;
      });
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

abstract class AnimateFloatingCardsEvent {}

class AnimeteFloatingCardsToTopEvent extends AnimateFloatingCardsEvent {}

class AnimeteFloatingCardsToDownEvent extends AnimateFloatingCardsEvent {}
