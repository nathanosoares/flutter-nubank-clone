import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nubank/src/blocs/floating_cards_bloc.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';

void main() => runApp(MaterialApp(
      home: NubankClone(),
    ));

class NubankClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
        Provider<FloatingCardsBloc>.value(value: FloatingCardsBloc()),
      ],
      child: MaterialApp(
        title: 'NuBank Clone',
        home: App(),
        color: Color.fromRGBO(130, 38, 158, 1),
        theme: ThemeData(
          accentColor: Color.fromRGBO(130, 38, 158, 1),
        ),
      ),
    );
  }
}
