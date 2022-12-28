import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> _userTransactions;

  TransactionList(this._userTransactions);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _userTransactions.isEmpty
            ? Column(
                children: [
                  Text(
                    "No transaction stored yet!",
                    style: ThemeData.light().textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 200,
                      child: Image.asset(
                        "assets/images/waiting.png",
                        fit: BoxFit.cover,
                      )),
                ],
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Theme.of(context).primaryColorDark,
                            width: 2,
                          )),
                          child: Text(
                            "₹ ${_userTransactions[index]
                                    .valueOfTxn
                                    .toStringAsFixed(1)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: "Quicksand",
                              color: Theme.of(context).primaryColorDark,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _userTransactions[index].title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: "Quicksand",
                                  color: Colors.black),
                            ),
                            Text(
                              DateFormat("MMMM dd, yyyy")
                                  .format(_userTransactions[index].dateOfTxn),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: "Quicksand",
                                  color: Colors.black26),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: _userTransactions.length,
              ));
  }
}
