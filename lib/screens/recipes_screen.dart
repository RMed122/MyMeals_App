import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../widget/category_item.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();

  static _RecipesScreenState of(BuildContext context) =>
      context.findAncestorStateOfType<_RecipesScreenState>()!;
}

class _RecipesScreenState extends State<RecipesScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text("RECIPES HERE");
  }
}
