import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function _addNewTxn;

  NewTransaction(this._addNewTxn);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _txnDate = DateTime(1900);

  DatabaseReference reference = FirebaseDatabase.instance.ref();
  final user = FirebaseAuth.instance.currentUser;

  void _presentDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019),
        lastDate: DateTime.now()).then((datePicked) {
          if(datePicked == null){
            return;
          }
          setState(() {
            _txnDate = datePicked;
          });
    });
  }

  void _addTxn(){
    if (!titleController.text.isEmpty &&
        double.parse(amountController.text) > 0 && _txnDate != DateTime(1900)) {
      final id = (_txnDate.millisecondsSinceEpoch-DateTime.now().millisecondsSinceEpoch).abs().toString();

      widget._addNewTxn(id, titleController.text,
          double.parse(amountController.text), _txnDate);

        reference.child(user!.uid).child(id).set(
          {
            "txnName" : titleController.text,
            "txnAmount" : amountController.text,
            "txnDate" : DateFormat("MMM dd, yyyy").format(_txnDate),
          }
        );

    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: "Title"),
            controller: titleController,
          ),
          TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: "Amount"),
            controller: amountController,
            keyboardType: TextInputType.number,
            onSubmitted: (_) {
              if (!titleController.text.isEmpty &&
                  double.parse(amountController.text) > 0 && _txnDate != DateTime(1900)) {
                widget._addNewTxn(
                    titleController.text, double.parse(amountController.text), _txnDate);
                Navigator.of(context).pop();
              }
            },
          ),
          Container(
            height: 70,
            child: Row(
              children: [
                Expanded(child: Text("Picked date : ${_txnDate == DateTime(1900) ? "No date chosen!" : DateFormat.yMd().format(_txnDate)}",)),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    "Choose a date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
              onPressed: () {
                _addTxn();
              },
              child: Text("Add Transaction")),
        ],
      ),
    ));
  }
}
