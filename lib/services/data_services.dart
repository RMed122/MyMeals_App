import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartData {
  ChartData({this.x, this.y});
  final DateTime? x;
  final int? y;
}

class UserDataServices {
  final fireStore = FirebaseFirestore.instance;

  void firstLoginSetUp() async {
    final data =
        fireStore.collection('users').where("id", isEqualTo: getUserEmail());
    try {
      await data.get().then((value) {
        value.docs.first;
      });
    } catch (e) {
      fireStore.collection('users').add({"id": getUserEmail()});
    }
  }

  String? getUserEmail() {
    User? loggedInUser = FirebaseAuth.instance.currentUser;
    String? userEmail;
    if (loggedInUser != null) {
      userEmail = loggedInUser.email;
    }
    return userEmail;
  }

  dynamic getUserDoc() async {
    late String userDoc;
    final data =
        fireStore.collection('users').where("id", isEqualTo: getUserEmail());
    await data.get().then((value) {
      userDoc = value.docs.first.id;
    });
    return userDoc;
  }

  dynamic addCalories(String mealName, int calories, String mealType, int carbs,
      int protein, int fat) async {
    try {
      String userDoc = await getUserDoc();
      fireStore.collection('users').doc(userDoc).collection("meals").add({
        'time': Timestamp.now(),
        'name': mealName,
        'calories': calories,
        'carbs': carbs,
        'protein': protein,
        'fat': fat,
        'type': mealType
      });
      return 1;
    } catch (e) {
      return 0;
    }
  }

  void setTargetCalories(int targetCalories) async {
    String userDoc = await getUserDoc();
    fireStore
        .collection('users')
        .doc(userDoc)
        .update({"targetCalories": targetCalories});
  }

  dynamic getTargetCalories() async {
    late int targetCalories;
    String userDoc = await getUserDoc();

    try {
      final data = fireStore.collection('users').doc(userDoc);
      await data.get().then((value) {
        targetCalories = value["targetCalories"];
      });
    } catch (e) {
      targetCalories = 2500;
    }
    return targetCalories;
  }

  dynamic getMissedTarget(bool weekly) async {
    int target = await getTargetCalories();
    List<int> meals = await getDayWeekmonthNutri("calories",
        weekly: weekly, monthly: !weekly, returnList: true);
    int counter = 0;
    for (var meal in meals) {
      if (meal > target) {
        counter++;
      }
    }
    return counter;
  }

  dynamic getMostCaloric(bool weekly) async {
    List<int> meals = await getDayWeekmonthNutri("calories",
        weekly: weekly, monthly: !weekly, returnList: true);

    return meals.reduce(max);
  }

  dynamic getDayWeekmonthNutri(String nutriDoc,
      {bool weekly = false,
      bool monthly = false,
      bool returnList = false}) async {
    String userDoc = await getUserDoc();
    DateTime now = DateTime.now();
    int weeklyInt = 0;
    int monthInt = 0;
    if (weekly) {
      weeklyInt = 7;
    } else if (monthly) {
      monthInt = 1;
    }
    final data = fireStore
        .collection('users')
        .doc(userDoc)
        .collection("meals")
        .where("time",
            isGreaterThanOrEqualTo:
                DateTime(now.year, now.month - monthInt, now.day - weeklyInt));
    late List<int> meals = [];
    await data.get().then((value) {
      for (dynamic meal in value.docs) {
        meals.add(meal.get(nutriDoc));
      }
    });
    if (meals.isEmpty) {
      meals = [0];
    }
    if (returnList) {
      return meals;
    } else {
      return meals.reduce((a, b) => a + b);
    }
  }

  dynamic plotCaloriesGraph(bool weekly, String nutriDoc) async {
    String userDoc = await getUserDoc();
    DateTime now = DateTime.now();
    int week = 0;
    int month = 0;
    if (weekly) {
      week = 7;
    } else {
      month = 1;
    }
    var snapShotsValue = await fireStore
        .collection('users')
        .doc(userDoc)
        .collection("meals")
        .where("time",
            isGreaterThanOrEqualTo:
                DateTime(now.year, now.month - month, now.day - week))
        .get();
    List<ChartData> chartData = snapShotsValue.docs
        .map((e) => ChartData(
            x: DateTime.fromMillisecondsSinceEpoch(
                e.data()['time'].millisecondsSinceEpoch),
            y: e.data()[nutriDoc]))
        .toList();
    return chartData;
  }
}
