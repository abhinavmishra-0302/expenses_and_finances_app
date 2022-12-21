import 'package:expenses_and_finances/widgets/chart.dart';
import 'package:expenses_and_finances/widgets/new_transaction.dart';
import 'package:expenses_and_finances/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              titleMedium: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              titleSmall: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.normal,
                  fontSize: 10))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final List<Transaction> _userTransactions = [];

  void _addNewTransaction(String title, double amount, DateTime _txnDate) {
    final newTxn =
        Transaction(DateTime.now().toString(), title, amount, _txnDate);
    setState(() {
      _userTransactions.add(newTxn);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.dateOfTxn.isAfter(
        DateTime.now().subtract(Duration(days: 7)),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("Finance & Expense Manager"),
      actions: [
        IconButton(
          onPressed: () {
            _startAddNewTransaction(context);
          },
          icon: Icon(Icons.add),
        )
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.3,
              child: Chart(_recentTransaction)),
          Container(
              height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top) *
                  0.7,
              child: TransactionList(_userTransactions)),
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          _startAddNewTransaction(context);
        },
      ),
    );
  }
}
