import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mvvm/res/color.dart';




class Chart extends StatefulWidget {
  @override
  _PieChartExampleState createState() => _PieChartExampleState();
}

class _PieChartExampleState extends State<Chart> {
  double piValue = 70;  // Example value, you can set it dynamically
  double remainingPercentage = 100 - 70;  // This is the remaining percentage

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  backgroundColor: AppColors.greencolor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PieChart(
          PieChartData(
            sectionsSpace: 0,
            centerSpaceRadius: 40,
            sections: (piValue > 100)
                ? [
              PieChartSectionData(
                color: Colors.green,
                value: piValue,
                title: '${piValue}%',
                radius: 50,
                titleStyle: TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ]
                : List.generate(
              2,
                  (index) {
                // Index 0 for the green section, and Index 1 for the red section
                double value = index == 0 ? piValue : remainingPercentage;
                String title = index == 0
                    ? '${piValue}%'
                    : '${remainingPercentage}%';
                Color color = index == 0 ? Colors.green : Colors.red;

                return PieChartSectionData(
                  color: color,
                  value: value,
                  title: title,
                  radius: 50,
                  titleStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
