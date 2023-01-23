import 'package:flutter/material.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CaloriesChart extends StatefulWidget {
  const CaloriesChart(
      {super.key,
      required this.weekly,
      required this.nutriDoc,
      this.testMode = false});
  final bool weekly; //True for weekly/False for monthly
  final String nutriDoc; // [calories, carbs , fat, protein]
  final bool testMode;

  @override
  State<CaloriesChart> createState() => _CaloriesChartState();
}

class _CaloriesChartState extends State<CaloriesChart> {
  dynamic inst;
  dynamic chartData = [ChartData()];

  @override
  void initState() {
    super.initState();
    if (!widget.testMode) {
      inst = UserDataServices();
      updateChart();
    } else {
      inst = 0;
    }
  }

  void updateChart() async {
    if (!widget.testMode) {
      chartData = await inst.plotCaloriesGraph(widget.weekly, widget.nutriDoc);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(title: AxisTitle(text: "Date")),
        primaryYAxis: NumericAxis(title: AxisTitle(text: widget.nutriDoc)),
        series: <ChartSeries<ChartData, DateTime>>[
          LineSeries<ChartData, DateTime>(
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y),
        ]);
  }
}
