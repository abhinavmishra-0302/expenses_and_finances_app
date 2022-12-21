import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function _addNewTxn;

  NewTransaction(this._addNewTxn);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

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
                onSubmitted: (_){
                  if(!titleController.text.isEmpty && double.parse(amountController.text) > 0) {
                    widget._addNewTxn(titleController.text,
                        double.parse(amountController.text));
                    Navigator.of(context).pop();
                  }
                },
              ),
              TextButton(onPressed: () {
                if(!titleController.text.isEmpty && double.parse(amountController.text) > 0) {
                  widget._addNewTxn(titleController.text,
                      double.parse(amountController.text));
                }

                Navigator.of(context).pop();
              }, child: Text("Add Transaction")),
            ],
          ),
        )
    );
  }
}
