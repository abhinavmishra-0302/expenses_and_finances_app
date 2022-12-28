import 'package:expenses_and_finances/pages/login_page.dart';
import 'package:expenses_and_finances/pages/make_plan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import '../widgets/chart.dart';
import '../widgets/new_transaction.dart';
import '../widgets/transaction_list.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  late final user;
  DatabaseReference reference = FirebaseDatabase.instance.ref();

  List<Transactions> _userTransactions = [];

  _MyHomePageState() {
    user = auth.currentUser;
    reference.child(user!.uid).onValue.listen((event) {
      setState(() {
        _userTransactions = [];
        for (DataSnapshot snapshot in event.snapshot.children) {
          _userTransactions.add(Transactions(
              snapshot.key.toString(),
              snapshot.child("txnName").value.toString(),
              double.parse(snapshot.child("txnAmount").value.toString()),
              DateFormat("MMM dd, yyyy")
                  .parse(snapshot.child("txnDate").value.toString())));
        }
      });
    });
  }

  void _addNewTransaction(
      String id, String title, double amount, DateTime _txnDate) {
    final newTxn = Transactions(id, title, amount, _txnDate);
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

  List<Transactions> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.dateOfTxn.isAfter(
        DateTime.now().subtract(Duration(days: 30)),
      ) && tx.dateOfTxn.month == DateTime.now().month;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text("Finance & Expense Manager"),
      bottom: TabBar(
        tabs: [
          Tab(
            text: "Expenses",
          ),
          Tab(
            text: "Investments",
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            _startAddNewTransaction(context);
          },
          icon: Icon(Icons.add),
        )
      ],
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/profile.jpg"),
                                  ),
                                )),
                            Text(
                              user!.phoneNumber!.substring(3) as String,
                              style:
                                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            Container(
                              height: 25,
                              width: 25,
                              child: Image.asset(
                                "assets/images/arrow.png",
                                fit: BoxFit.scaleDown,
                              ),
                            )
                          ],
                        )
                      ])),
              ListTile(
                title: Text("Make a plan", style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return MakePlanPage();
                  }));
                },
              ),
              ListTile(
                title: Text("Log out", style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  auth.signOut();
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return LoginPage();
                  }));
                },
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
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
            Center(child: Text("Investments")),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            _startAddNewTransaction(context);
          },
        ),
      ),
    );
  }
}
