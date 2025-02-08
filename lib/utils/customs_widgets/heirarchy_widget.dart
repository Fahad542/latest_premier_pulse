import 'package:flutter/material.dart';



class Heirachy_widget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Balance',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '\$7,392.00',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIncomeExpenseCard('Income', '\$9,302.00', Colors.green),
                _buildIncomeExpenseCard('Expense', '\$2,790.00', Colors.red),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Detail of movements',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildMovementItem('Restaurant Manhattan', 'June 1, 2018', '\$170'),
                  _buildMovementItem('Deposit Freelance', 'June 1, 2018', '\$800'),
                  _buildMovementItem('Central Market', 'June 1, 2018', '\$50'),
                  _buildMovementItem('Salary Deposit', 'June 1, 2018', '\$4,200'),
                  _buildMovementItem('Central Market', 'June 1, 2018', '\$100'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseCard(String title, String amount, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildMovementItem(String title, String date, String amount) {
    return ListTile(
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(amount),
    );
  }
}