import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mymeals/model/recipe.dart';
import 'package:mymeals/widget/bottom_navbar.dart';
import 'package:mymeals/widget/calories_chart.dart';
import 'package:mymeals/widget/daily_counter.dart';
import 'package:mymeals/widget/dashboard_card.dart';
import 'package:mymeals/widget/data_tile.dart';
import 'package:mymeals/widget/ingridient_tile.dart';
import 'package:mymeals/widget/insertData.dart';
import 'package:mymeals/widget/insertproduct_popup.dart';
import 'package:mymeals/widget/main_drawer.dart';

void main() {
  group('Widgets Test', () {
    testWidgets('Navbar renders correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        bottomNavigationBar: BottomNavBar(),
      )));

      final titleOneFinder = find.text('Dashboard');
      final titleTwoFinder = find.text('Recipes');
      final titleThreeFinder = find.text('Data');

      expect(titleOneFinder, findsOneWidget);
      expect(titleTwoFinder, findsOneWidget);
      expect(titleThreeFinder, findsOneWidget);
    });

    testWidgets('Navbar routes renders correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        bottomNavigationBar: BottomNavBar(),
      )));

      final BottomNavBarState myWidgetState =
          tester.state(find.byType(BottomNavBar));

      myWidgetState.selectPage(1);
      expect(myWidgetState.selectedPageIndex, 1);
      expect(myWidgetState.pages[0]["title"], "Dashboard");
      expect(myWidgetState.pages[1]["title"], "Recipes");
      expect(myWidgetState.pages[2]["title"], "Your Data & Trends");
    });

    testWidgets('Meal Cards renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DashBoardCard(
            mealname: "pasta",
            calories: "100",
            carbs: "100",
            fat: "100",
            protein: "100",
          ),
        ),
      ));

      final titleOneFinder = find.text('pasta');
      final titleTwoFinder = find.text('100 kcal\n100 g\n100 g\n100 g\n');

      expect(titleOneFinder, findsOneWidget);
      expect(titleTwoFinder, findsOneWidget);
    });

    testWidgets('Data Tile renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DataTile(
            header: "Protein",
            body: "105",
            dataIcon: Icons.abc_sharp,
          ),
        ),
      ));

      final titleOneFinder = find.text('Protein');
      final titleTwoFinder = find.text('105');
      final iconFinder = find.byIcon(Icons.abc_sharp);

      expect(titleOneFinder, findsOneWidget);
      expect(titleTwoFinder, findsOneWidget);
      expect(iconFinder, findsOneWidget);
    });

    testWidgets('Ingredient Tile renders correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: IngridientTile(data: Ingridient(name: "cheese", size: "10g")),
        ),
      ));

      final titleOneFinder = find.text('cheese');
      final titleTwoFinder = find.text('10g');

      expect(titleOneFinder, findsOneWidget);
      expect(titleTwoFinder, findsOneWidget);
    });

    testWidgets('Drawer renders correctly', (tester) async {
      final scaffoldKey = GlobalKey<ScaffoldState>();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          drawer: const MainDrawer(
            testMode: true,
          ),
          key: scaffoldKey,
        ),
      ));

      scaffoldKey.currentState?.openDrawer();
      await tester.pump();

      expect(find.text("Home"), findsOneWidget);
      expect(find.text("Settings"), findsOneWidget);
      expect(find.text("Sign Out"), findsOneWidget);
    });

    testWidgets('Drawer buildListTile renders correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          drawer: MainDrawer(),
          body:
              MainDrawer().buildListTile("title", Icons.abc_sharp, () => null),
        ),
      ));

      final iconFinder = find.byIcon(Icons.abc_sharp);
      expect(iconFinder, findsOneWidget);
    });

    testWidgets('Dailycounter renders correclty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DailyCounter(
            testmode: true,
          ),
        ),
      ));
    });

    testWidgets('Chart plotting renders correclty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CaloriesChart(
            nutriDoc: "calories",
            weekly: true,
            testMode: true,
          ),
        ),
      ));
    });

    testWidgets('Insert data popup renders correclty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: InsertData(
            testMode: true,
          ),
        ),
      ));
    });
    testWidgets('Insert product popup renders correclty', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: InsertProdPopup(
            testMode: true,
          ),
        ),
      ));
    });

    testWidgets('Insert product popup save meal function behaves correclty',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: InsertProdPopup(
            testMode: true,
          ),
        ),
      ));

      final InsertProdPopupState myWidgetState =
          tester.state(find.byType(InsertProdPopup));

      expect(myWidgetState.saveMeal(), 0);
    });
  });
}
