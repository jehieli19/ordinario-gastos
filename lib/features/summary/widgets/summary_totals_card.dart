import 'package:flutter/material.dart';

class SummaryTotalsCard extends StatelessWidget {
  const SummaryTotalsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Total del mes'),
        subtitle: Text('Total del día'),
      ),
    );
  }
}
