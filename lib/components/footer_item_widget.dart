import 'package:flutter/material.dart';

List<FooterItem> footerItems = [
  FooterItem(
    icon: Icons.person_add,
    text: "Indicar amigos",
  ),
  FooterItem(
    icon: Icons.gavel,
    text: "Cobrar",
  ),
  FooterItem(
    icon: Icons.file_upload,
    text: "Depositar",
  ),
  FooterItem(
    icon: Icons.file_download,
    text: "Transferir",
  ),
  FooterItem(
    icon: Icons.settings_ethernet,
    text: "Ajustar limite",
  ),
  FooterItem(
    icon: Icons.payment,
    text: "Cartão virtual",
  ),
  FooterItem(
    icon: Icons.sort,
    text: "Organizar Atalhos",
  )
];

class FooterItem extends StatelessWidget {
  final String text;
  final IconData icon;

  FooterItem({@required this.text, @required this.icon, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        Spacer(),
        Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 15),
        )
      ],
    );
  }
}
