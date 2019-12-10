import 'package:flutter/material.dart';
import 'package:nubank/pages/dashboard/widgets/footer_card_item.dart';
class FooterCards extends StatefulWidget {
  @override
  _FooterCardsState createState() => _FooterCardsState();
}

class _FooterCardsState extends State<FooterCards> {
  List<FooterCardItem> _items = [
    FooterCardItem(
      icon: Icons.person_add,
      text: "Indicar amigos",
    ),
    FooterCardItem(
      icon: Icons.gavel,
      text: "Cobrar",
    ),
    FooterCardItem(
      icon: Icons.file_upload,
      text: "Depositar",
    ),
    FooterCardItem(
      icon: Icons.file_download,
      text: "Transferir",
    ),
    FooterCardItem(
      icon: Icons.settings_ethernet,
      text: "Ajustar limite",
    ),
    FooterCardItem(
      icon: Icons.payment,
      text: "Cartão virtual",
    ),
    FooterCardItem(
      icon: Icons.sort,
      text: "Organizar Atalhos",
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: _items.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 95,
            child: _items[index],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 10,
          );
        },
      ),
    );
  }
}
