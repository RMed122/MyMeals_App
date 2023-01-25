import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:faker/faker.dart';
import 'package:mymeals/main.dart' as app;
import 'package:mymeals/screens/home_screen.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/widget/calories_chart.dart';
import 'package:mymeals/widget/daily_counter.dart';
import 'package:mymeals/widget/dashboard_card.dart';
import 'package:mymeals/widget/data_tile.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  final String fakeEmail = Faker().internet.email();

  group('Major Features Integration Tests: ', () {
    testWidgets('Register using Email and Password', (tester) async {
      app.main();

      await tester.pumpAndSettle();
      //wait for app to load
      await Future.delayed(const Duration(seconds: 5), (() {
        expect(find.text('Login'), findsNWidgets(2));
      }));
      final Finder noAcctButton = find.byType(TextButton);
      await tester.tap(noAcctButton);
      await Future.delayed(const Duration(seconds: 2), (() {}));

      final Finder emailTextField = find.byType(TextFormField).first;
      final Finder passTextField = find.byType(TextFormField).last;
      final Finder registerButton = find.byType(ElevatedButton).first;

      await tester.enterText(emailTextField, fakeEmail);
      await tester.enterText(passTextField, "123456789");
      FocusManager.instance.primaryFocus?.unfocus();
      await Future.delayed(const Duration(seconds: 3), (() {}));

      await tester.tap(registerButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));
      expect(find.text("Dashboard"), findsAtLeastNWidgets(1));
    });

    testWidgets('Adding one meal', (tester) async {
      app.main();

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5), (() {}));
      final Finder addButton = find.byType(FloatingActionButton).first;
      await tester.tap(addButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder manualInsertButton = find.byType(FloatingActionButton).last;
      await tester.tap(manualInsertButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder mealNameTextField = find.byType(TextFormField).at(0);
      final Finder mealKCalTextFields = find.byType(TextFormField).at(1);
      final Finder mealCarbTextFields = find.byType(TextFormField).at(2);
      final Finder mealFatsTextFields = find.byType(TextFormField).at(3);
      final Finder mealProtTextFields = find.byType(TextFormField).at(4);
      await tester.enterText(mealNameTextField, "Test Meal");
      await tester.enterText(mealKCalTextFields, "100");
      await tester.enterText(mealCarbTextFields, "100");
      await tester.enterText(mealFatsTextFields, "100");
      await tester.enterText(mealProtTextFields, "100");
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder saveButton = find.byType(TextButton).last;
      await tester.tap(saveButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder closeButton = find.byType(TextButton).first;
      await tester.tap(closeButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      await tester.drag(find.byType(DailyCounter), const Offset(0, 200));
      await Future.delayed(const Duration(seconds: 5), (() {}));

      expect(find.byType(DashBoardCard), findsAtLeastNWidgets(1));
    });

    testWidgets('Getting random recipe', (tester) async {
      app.main();

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder recipeNavBarButton = find.byIcon(Icons.restaurant_menu);
      await tester.tap(recipeNavBarButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder recipeButton = find.byType(VerticalCardPager);
      await tester.tap(recipeButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder searchButton = find.byType(TextButton).first;
      await tester.tap(searchButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder recipeResultButton = find.byType(VerticalCardPager);
      await tester.tap(recipeResultButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      expect(find.text("Ingridients"), findsAtLeastNWidgets(1));
      expect(find.text("Nutriments"), findsAtLeastNWidgets(1));
    });

    testWidgets('Search Recipes based on ingredients', (tester) async {
      app.main();

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder recipeNavBarButton = find.byIcon(Icons.restaurant_menu);
      await tester.tap(recipeNavBarButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      await tester.drag(find.byType(VerticalCardPager), const Offset(0, 500));
      await Future.delayed(const Duration(seconds: 2), (() {}));
      await tester.drag(find.byType(VerticalCardPager), const Offset(0, 500));
      await Future.delayed(const Duration(seconds: 2), (() {}));

      final Finder recipeButton = find.byType(VerticalCardPager);
      await tester.tap(recipeButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder ingrTextField = find.byType(TextField);
      await tester.enterText(ingrTextField, "beef");
      await Future.delayed(const Duration(seconds: 2), (() {}));

      final Finder searchButton = find.byType(TextButton).first;
      await tester.tap(searchButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder recipeResultButton = find.byType(VerticalCardPager);
      await tester.tap(recipeResultButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      expect(find.text("Ingridients"), findsAtLeastNWidgets(1));
      expect(find.text("Nutriments"), findsAtLeastNWidgets(1));
    });

    testWidgets('Analyze Recipe', (tester) async {
      app.main();

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder recipeNavBarButton = find.byIcon(Icons.restaurant_menu);
      await tester.tap(recipeNavBarButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      await tester.drag(find.byType(VerticalCardPager), const Offset(0, -500));
      await Future.delayed(const Duration(seconds: 2), (() {}));

      final Finder recipeButton = find.byType(VerticalCardPager);
      await tester.tap(recipeButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder ingrTextField = find.byType(TextField);
      await tester.enterText(ingrTextField.first, "100g beef");
      await tester.enterText(ingrTextField.last, "Test Meal");
      await Future.delayed(const Duration(seconds: 2), (() {}));

      final Finder searchButton = find.byType(TextButton).first;
      await tester.tap(searchButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      expect(find.text("Analysis Result"), findsAtLeastNWidgets(1));
    });

    testWidgets('See meal data and trends', (tester) async {
      app.main();

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder recipeNavBarButton = find.byIcon(Icons.analytics);
      await tester.tap(recipeNavBarButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder dataTiles = find.byType(DataTile);
      final Finder charts = find.byType(CaloriesChart);

      expect(dataTiles, findsNWidgets(16));
      expect(charts, findsNWidgets(8));
    });

    testWidgets('Change Theme in Settings', (tester) async {
      app.main();

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder recipeNavBarButton = find.byIcon(Icons.menu);
      await tester.tap(recipeNavBarButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder settingsButton = find.text("Settings");
      await tester.tap(settingsButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder themeSettingsButton = find.text("App Theme");
      await tester.tap(themeSettingsButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder darkThemeButton = find.text("Dark Theme");
      await tester.tap(darkThemeButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final HomeScreenState myWidgetState =
          tester.state(find.byType(HomeScreen));
      expect(myWidgetState.themeMode, ThemeMode.dark);
    });

    testWidgets('Set target calories in Settings', (tester) async {
      app.main();

      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder recipeNavBarButton = find.byIcon(Icons.menu);
      await tester.tap(recipeNavBarButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder settingsButton = find.text("Settings");
      await tester.tap(settingsButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      final Finder targetKcalSettingsButton = find.byIcon(Icons.bolt);
      await tester.tap(targetKcalSettingsButton);
      await Future.delayed(const Duration(seconds: 3), (() {}));

      final String targetKcal = (Random().nextInt(1500) + 1000).toString();
      final Finder targetKcalTextField = find.byType(TextField);
      await tester.enterText(targetKcalTextField, targetKcal);
      await Future.delayed(const Duration(seconds: 3), (() {}));

      final Finder submitButton = find.byIcon(Icons.save);
      await tester.tap(submitButton);
      await Future.delayed(const Duration(seconds: 5), (() {}));

      int userTargetKcal = await UserDataServices().getTargetCalories();
      expect(userTargetKcal.toString(), targetKcal);
    });
  });
}
//Sign IN Test
    // testWidgets('Sign in using Email and Password', (tester) async {
    //   // app.main();

    //   // await tester.pumpAndSettle();
    //   //wait for app to load
    //   await Future.delayed(const Duration(seconds: 5), (() {
    //     expect(find.text('Login'), findsNWidgets(2));
    //   }));
    //   final Finder emailTextField = find.byType(TextFormField).first;
    //   final Finder passTextField = find.byType(TextFormField).last;
    //   final Finder loginButton = find.byType(ElevatedButton).first;
    //   await tester.enterText(emailTextField, fakeEmail);
    //   await tester.enterText(passTextField, "123456789");
    //   FocusManager.instance.primaryFocus?.unfocus();
    //   await Future.delayed(const Duration(seconds: 2), (() {}));

    //   await tester.tap(loginButton);
    //   await Future.delayed(const Duration(seconds: 5), (() {}));

    //   expect(find.text("Dashboard"), findsAtLeastNWidgets(1));
    // });

//Sign to run test individually

      // //wait for app to load
      // await Future.delayed(const Duration(seconds: 5), (() {
      //   expect(find.text('Login'), findsNWidgets(2));
      // }));
      // final Finder emailTextField = find.byType(TextFormField).first;
      // final Finder passTextField = find.byType(TextFormField).last;
      // final Finder loginButton = find.byType(ElevatedButton).first;
      // await tester.enterText(emailTextField, "abc@abc.comcom");
      // await tester.enterText(passTextField, "123456789");
      // FocusManager.instance.primaryFocus?.unfocus();
      // await Future.delayed(const Duration(seconds: 2), (() {}));
      // await tester.tap(loginButton);
      // await Future.delayed(const Duration(seconds: 5), (() {}));
      // //Sign In Done