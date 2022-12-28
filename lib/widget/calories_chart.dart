import 'package:flutter/material.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CaloriesChart extends StatefulWidget {
  const CaloriesChart({super.key, required this.weekly});
  final bool weekly; //True for weekly/False for monthly

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
    chartData = await inst.plotCaloriesGraph(widget.weekly);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(),
        series: <ChartSeries<ChartData, DateTime>>[
          LineSeries<ChartData, DateTime>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y),
        ]);
  }
}
