import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget(
    this.name, {
    Key key,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image(
          image: AssetImage('assets/images/nubank-logo.png'),
          height: 30,
          color: Colors.white,
          fit: BoxFit.fitWidth,
          filterQuality: FilterQuality.high,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          this.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: 'Trueno',
          ),
        )
      ],
    );
  }
}
