import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nubank/src/blocs/floating_cards_bloc.dart';
import 'package:provider/provider.dart';

class TopWidget extends StatelessWidget {
  const TopWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FloatingCardsBloc floatingCardBloc =
        Provider.of<FloatingCardsBloc>(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network(
              "https://aws1.discourse-cdn.com/nubank/original/1X/0e91acb8692ef95f8446675084ced03e892f16c2.png",
              height: 35,
              color: Colors.white,
              fit: BoxFit.fitWidth,
              filterQuality: FilterQuality.high,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                "Nathan",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: floatingCardBloc.topPercentage.stream,
              initialData: floatingCardBloc.topPercentage.value,
              builder: (_, AsyncSnapshot<double> snapshot) {
                return Transform.rotate(
                  angle: -(pi / 100 * snapshot.data),
                  child: Opacity(
                    opacity: 0.5,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                );
              },
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
