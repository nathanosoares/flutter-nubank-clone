import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nubank/pages/dashboard/dashboard.dart';
import 'package:provider/provider.dart';

void main() => runApp(_NubankClone());

class _NubankClone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MultiProvider(
      providers: [
      ],
      child: MaterialApp(
        title: 'NuBank Clone',
        routes: {
          '/': (context) => DashboardPage()
        },
        initialRoute: '/',
        color: Color.fromRGBO(130, 38, 158, 1),
        theme: ThemeData(
          accentColor: Color.fromRGBO(130, 38, 158, 1),
        ),
      ),
    );
  }
}
