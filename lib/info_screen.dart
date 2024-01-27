import 'package:flutter/material.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info Screen'),
      ),
      body: ListView(
        children: [
          _buildInfoTile(),
          // Add other widgets or content as needed
        ],
      ),
    );
  }

  ListTile _buildInfoTile() {
    return ListTile(
      leading: const Icon(Icons.info),
      title: const Text(
        'Shopensess is an all-in-one application designed'
            ' for seamless shopping and expense management. It empowers '
            'users to effortlessly track daily expenses, categorize spending, '
            'and gain valuable insights for effective budgeting. '
            'With features like shopping list creation, prioritization, '
            'and purchase tracking, Shopensess ensures users stay organized '
            'during their shopping endeavors.'
            'Providing a comprehensive financial overview, '
            'Shopensess highlights key metrics, such as total expenses, '
            'remaining budget, and savings.',
      ),
    );
  }
}
