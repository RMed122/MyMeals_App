import 'package:flutter/material.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CaloriesChart extends StatefulWidget {
  const CaloriesChart(
      {super.key, required this.weekly, required this.nutriDoc});
  final bool weekly; //True for weekly/False for monthly
  final String nutriDoc; // [calories, carbs , fat, protein]

  @override
  State<CaloriesChart> createState() => _CaloriesChartState();
}

class _CaloriesChartState extends State<CaloriesChart> {
  UserDataServices inst = UserDataServices();
  dynamic chartData = [ChartData()];

  @override
  void initState() {
    super.initState();
    updateChart();
  }

  void updateChart() async {
    chartData = await inst.plotCaloriesGraph(widget.weekly, widget.nutriDoc);
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
