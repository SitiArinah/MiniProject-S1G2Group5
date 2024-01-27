//import 'package:camera/camera.dart';
import 'package:daily_expenses/login.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'Shoppenses';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView(
        ),
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

  ListTile _buildCategoryTile(String category, String amount) {
    return ListTile(
      leading: const Icon(Icons.attach_money),
      title: Text('$category - $amount'),
    );
  }
}
