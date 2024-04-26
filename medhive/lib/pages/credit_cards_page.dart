import 'package:flutter/material.dart';
import 'package:medhive/pages/card_validation_page.dart';

class CreditCardsPage extends StatefulWidget {
  const CreditCardsPage({super.key});

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  List<String> cards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Cards'),
      ),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cards[index]), // Display card detail
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
              const CardValidationPage()));
        },
        tooltip: 'Add Card',
        child: Icon(Icons.add),
      ),
    );
  }
}
