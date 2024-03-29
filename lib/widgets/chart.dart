import 'package:expenses_and_finances/models/transaction.dart';
import 'package:expenses_and_finances/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transactions> _recentTransaction;

  Chart(this._recentTransaction);

  List<Map<String, Object>> get groupedTransactionValue {
    return List.generate(DateTime.now().day, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0;

      for (int i = 0; i < _recentTransaction.length; i++) {
        if (_recentTransaction[i].dateOfTxn.day == weekDay.day &&
            _recentTransaction[i].dateOfTxn.month == weekDay.month &&
            _recentTransaction[i].dateOfTxn.year == weekDay.year) {
          totalSum += _recentTransaction[i].valueOfTxn;
        }
      }

      return {"day": DateFormat("d/M").format(weekDay), "amount": totalSum};
    });
  }

  double get maxSpending {
    return groupedTransactionValue.fold(0.0, (sum, item){
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
         itemBuilder: (context, index){
           // groupedTransactionValue.map((data) {
             return ChartBar(groupedTransactionValue[index]["day"].toString(), groupedTransactionValue[index]["amount"] as double, maxSpending == 0 ? 0.0 : (groupedTransactionValue[index]["amount"] as double) / maxSpending);
           // }).toList();
         },
          itemCount: groupedTransactionValue.length,
        ),
      ),
    );
  }
}
