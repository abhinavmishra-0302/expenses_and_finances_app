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
                if (!titleController.text.isEmpty &&
                    double.parse(amountController.text) > 0 && _txnDate != DateTime(1900)) {
                  widget._addNewTxn(titleController.text,
                      double.parse(amountController.text), _txnDate);
                }

                Navigator.of(context).pop();
              },
              child: Text("Add Transaction")),
        ],
      ),
    ));
  }
}
