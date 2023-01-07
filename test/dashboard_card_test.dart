import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../mymeals/lib/widget/dashboard_card.dart';

void main() {
  group('dashboard card', () {
    testWidgets('DashBoardCard displays meal name and nutritional information',
        (WidgetTester tester) async {
      // Create a DashBoardCard with test data
      final dashBoardCard = DashBoardCard(
        mealname: 'Test Meal',
        calories: '300',
        protein: '20',
        carbs: '40',
        fat: '10',
      );

      // Build the widget and attach it to the test tree
      await tester.pumpWidget(
        MaterialApp(
          home: dashBoardCard,
        ),
      );

      // Verify that the meal name is displayed
      expect(find.text('Test Meal'), findsOneWidget);

      // Verify that the nutritional information is displayed
      expect(find.text('300 kcal'), findsOneWidget);
      expect(find.text('40 g'), findsOneWidget);
      expect(find.text('10 g'), findsOneWidget);
      expect(find.text('20 g'), findsOneWidget);
    });
  });
}
