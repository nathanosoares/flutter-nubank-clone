import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FloatingCardsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
    );
  }  
}

class _PageIndicator extends StatefulWidget {
  final PageController controller;

  _PageIndicator({
    @required this.controller,
  });

  @override
  State<StatefulWidget> createState() => _PageIndicatorState();
}

class _PageIndicatorState extends State<_PageIndicator> {
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

    CustomPainter indicatorPainter = _CirclePainter(
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

class _CirclePainter extends CustomPainter {
  double page;
  int count;
  Color color;
  Color selectedColor;
  double radius;
  double padding;
  Paint _circlePaint;
  Paint _selectedPaint;

  _CirclePainter({
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
