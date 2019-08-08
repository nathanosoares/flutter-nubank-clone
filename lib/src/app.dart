import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/components/footer_item_widget.dart';
import 'package:myapp/components/top_widget.dart';
import 'package:myapp/src/blocs/floating_cards_bloc.dart';
import 'package:myapp/src/ui/floating_cards.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with SingleTickerProviderStateMixin {
  final GlobalKey _emptyExpandedKey = GlobalKey();

  Widget _emptyExpanded;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getEmptyExpandedSize();
    });

    super.initState();

    _emptyExpanded = Expanded(
      key: _emptyExpandedKey,
      child: Container(),
    );
  }

  @override
  void dispose() {
    Provider.of<FloatingCardsBloc>(context).dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = MediaQuery.of(context).padding;

    double _height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;

    FloatingCardsBloc floatingCardBloc =
        Provider.of<FloatingCardsBloc>(context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(130, 38, 158, 1),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: _height * 0.035),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              TopWidget(),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  overflow: Overflow.visible,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _emptyExpanded,
                        StreamBuilder(
                          stream: floatingCardBloc.topPercentage.stream,
                          initialData: floatingCardBloc.topPercentage.value,
                          builder: (_, AsyncSnapshot<double> snapshtop) {
                            double opacity =
                                1.0 - max(0, min(1, snapshtop.data / 100));

                            if (opacity.isNaN) {
                              opacity = 1.0;
                            }

                            return Opacity(
                              opacity: opacity,
                              child: Column(
                                children: <Widget>[
                                  StreamBuilder(
                                    stream:
                                        floatingCardBloc.pageController.stream,
                                    initialData:
                                        floatingCardBloc.pageController.value,
                                    builder: (_,
                                        AsyncSnapshot<PageController>
                                            snapshot) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: _height * 0.04),
                                        child: PageIndicator(
                                          controller: snapshot.data,
                                        ),
                                      );
                                    },
                                  ),
                                  Container(
                                    height: 95.0,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: _height * 0.027),
                                      itemCount: footerItems.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: _height * 0.008),
                                        child: Container(
                                          width: 95,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  145, 64, 169, 1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4))),
                                          child: Padding(
                                            padding: EdgeInsets.all(8),
                                            child: footerItems[index],
                                          ),
                                        ),
                                      ),
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    Stack(
                      overflow: Overflow.visible,
                      // fit: StackFit.expand,
                      children: <Widget>[FloatingCards()],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getEmptyExpandedSize() {
    final BuildContext context = _emptyExpandedKey.currentContext;

    final RenderBox containerRenderBox = context.findRenderObject();

    final containerSize = containerRenderBox.size;

    final containerPosition = containerRenderBox.localToGlobal(Offset.zero);

    FloatingCardsBloc floatingCardBloc =
        Provider.of<FloatingCardsBloc>(context);

    floatingCardBloc.size.add(containerSize);
    floatingCardBloc.position.add(containerPosition);
  }
}

class PageIndicator extends StatefulWidget {
  final PageController controller;

  PageIndicator({
    @required this.controller,
  });

  @override
  State<StatefulWidget> createState() => PageIndicatorState();
}

class PageIndicatorState extends State<PageIndicator> {
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
