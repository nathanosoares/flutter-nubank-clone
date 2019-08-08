import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nubank/src/blocs/floating_cards_bloc.dart';
import 'package:provider/provider.dart';
import 'src/app.dart';

void main() => runApp(MaterialApp(
      home: NuBankDemo(),
    ));

class NuBankDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return MultiProvider(
      providers: [
        Provider<FloatingCardsBloc>.value(value: FloatingCardsBloc()),
      ],
      child: MaterialApp(
        title: 'NuBank Clone',
        home: App(),
      ),
    );
  }
}
