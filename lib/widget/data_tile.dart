import 'package:flutter/material.dart';
import 'package:mymeals/services/data_services.dart';

class DataTile extends StatefulWidget {
  const DataTile(
      {super.key,
      required this.header,
      required this.body,
      required this.dataIcon});
  final String header;
  final String body;
  final IconData dataIcon;

  @override
  State<DataTile> createState() => _DataTileState();
}

class _DataTileState extends State<DataTile> {
  UserDataServices inst = UserDataServices();
  dynamic chartData = [ChartData()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              widget.dataIcon,
              color: Theme.of(context).colorScheme.secondary,
              size: 35,
            ),
            const SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    widget.header,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    widget.body,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
