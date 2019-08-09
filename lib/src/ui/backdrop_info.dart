import 'package:flutter/material.dart';
import 'package:nubank/src/blocs/floating_cards_bloc.dart';
import 'package:provider/provider.dart';

class BackdropInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BackdropInfoState();
  }
}

class _BackdropInfoState extends State<BackdropInfo> {
  @override
  Widget build(BuildContext context) {
    FloatingCardsBloc floatingCardBloc =
        Provider.of<FloatingCardsBloc>(context);

    print(1 - floatingCardBloc.topPercentageToOpacity);

    return StreamBuilder(
      stream: floatingCardBloc.topPercentage.stream,
      initialData: floatingCardBloc.topPercentage.value,
      builder: (_, __) {
        return Opacity(
          opacity: 1 - floatingCardBloc.topPercentageToOpacity,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 95,
                  ),
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20,
                          bottom: 30,
                        ),
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Column(
                                children: <Widget>[
                                  Image(
                                    image:
                                        AssetImage('assets/images/qrcode.png'),
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                    filterQuality: FilterQuality.high,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      buildInfoText(),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      buildListDivider(),
                                      buildListItem(
                                          'Me ajuda', Icons.query_builder),
                                      buildListDivider(),
                                      buildListItem(
                                          'Perfil', Icons.query_builder),
                                      buildListDivider(),
                                      buildListItem('Configurar NuConta',
                                          Icons.query_builder),
                                      buildListDivider(),
                                      buildListItem('Configurar Cartão',
                                          Icons.query_builder),
                                      buildListDivider(),
                                      buildListItem('Configurações do app',
                                          Icons.query_builder),
                                      buildListDivider(),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      ButtonTheme(
                                        minWidth: double.infinity,
                                        height: 50,
                                        child: OutlineButton(
                                          child: Text(
                                            'Sair da conta'.toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Trueno',
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          onPressed: () {},
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(145, 64, 169, 1),
                                            style: BorderStyle.solid,
                                            width: 2,
                                          ),
                                          highlightedBorderColor : Color.fromRGBO(145, 64, 169, 1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildInfoText() {
    return Column(
      children: <Widget>[
        Text.rich(
          TextSpan(
            text: 'Banco ',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Trueno',
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(
                text: '260 - NuPagamentos S.A.',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text.rich(
          TextSpan(
            text: 'Agência ',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Trueno',
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(
                  text: '0001',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                  ))
            ],
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text.rich(
          TextSpan(
            text: 'Conta ',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Trueno',
              fontWeight: FontWeight.w300,
            ),
            children: [
              TextSpan(
                text: '40266338-7',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildListItem(String text, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.white,
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          Spacer(),
          Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget buildListDivider() {
    return Container(
      width: double.infinity,
      color: Color.fromRGBO(145, 64, 169, 1),
      height: 1.5,
    );
  }
}
