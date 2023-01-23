import 'package:flutter_test/flutter_test.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() {
  group('Data Services', () {
    test("First Login setup creates user collection", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      String testMail = await inst.firstLoginSetUp();

      expect(testMail, "test@test.com");
    });

    test("Get User email returns user email", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      String? testMail = inst.getUserEmail();

      expect(testMail, "test@test.com");
    });

    test("Get User data document id", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();
      String? userDoc = await inst.getUserDoc();

      expect(userDoc, isNotNull);
    });

    test("Add calories to Firestore", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();
      dynamic returnState =
          await inst.addCalories("mealName", 100, "mealType", 100, 100, 100);

      expect(returnState, 1);
    });

    test("Add target calories to Firestore", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();
      await inst.setTargetCalories(1000);

      late int targetCalories;
      final data =
          mockFirestore.collection('users').doc(await inst.getUserDoc());
      await data.get().then((value) {
        targetCalories = value["targetCalories"];
      });

      expect(targetCalories, 1000);
    });

    test("Get Target calories from Firestore", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();
      await inst.setTargetCalories(1500);
      int target = await inst.getTargetCalories();

      expect(target, 1500);
    });

    test("Get default target calories in case user did not set it", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();
      int target = await inst.getTargetCalories();

      expect(target, 2500);
    });

    test("Get meals over target from Firestore", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();
      await inst.setTargetCalories(50);

      await inst.addCalories("mealName", 100, "mealType", 100, 100, 100);
      await inst.addCalories("mealName", 100, "mealType", 100, 100, 100);
      await inst.addCalories("mealName", 10, "mealType", 100, 100, 100);
      int overTarget = await inst.getMissedTarget(true);

      expect(overTarget, 2);
    });

    test("Get most caloric meal from Firestore", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();
      await inst.setTargetCalories(50);

      await inst.addCalories("mealName", 200, "mealType", 100, 100, 100);
      await inst.addCalories("mealName", 100, "mealType", 100, 100, 100);
      await inst.addCalories("mealName", 10, "mealType", 100, 100, 100);
      int mostCal = await inst.getMostCaloric(true);

      expect(mostCal, 200);
    });

    test("Get Daily Caloric data from Firestore", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();

      await inst.addCalories("mealName", 200, "mealType", 100, 100, 100);
      await inst.addCalories("mealName", 100, "mealType", 100, 100, 100);
      await inst.addCalories("mealName", 10, "mealType", 100, 100, 100);
      int sumCal = await inst.getDayWeekmonthNutri("calories");

      expect(sumCal, 310);
    });

    test("Get empty Daily Caloric data from Firestore", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();
      int sumCal = await inst.getDayWeekmonthNutri("calories");

      expect(sumCal, 0);
    });

    test("Get Chart data to plot weekly calories data", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();

      await inst.addCalories("mealName", 200, "mealType", 100, 100, 100);
      await inst.addCalories("mealName", 100, "mealType", 100, 100, 100);
      await inst.addCalories("mealName", 10, "mealType", 100, 100, 100);

      dynamic chartData = await inst.plotCaloriesGraph(true, "calories");

      expect(chartData, isNotNull);
    });

    test("Get daily meals from Firestore", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();

      await inst.addCalories("mealName0", 200, "mealType", 100, 100, 100);
      await inst.addCalories("mealName1", 100, "mealType", 100, 100, 100);
      await inst.addCalories("mealName2", 10, "mealType", 100, 100, 100);

      dynamic meals = await inst.getDailyMeals();

      expect(meals[0]["name"], "mealName0");
      expect(meals[1]["name"], "mealName1");
      expect(meals[2]["name"], "mealName2");
    });

    test("Get daily meals when empty from Firestore", () async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();

      dynamic meals = await inst.getDailyMeals();

      expect(meals, [0]);
    });
  });
}
