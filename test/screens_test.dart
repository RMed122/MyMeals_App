import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mymeals/main.dart';
import 'package:mymeals/model/recipe.dart';
import 'package:mymeals/screens/dashboard_screen.dart';
import 'package:mymeals/screens/data_screen.dart';
import 'package:mymeals/screens/home_screen.dart';
import 'package:mymeals/screens/login_screen.dart';
import 'package:mymeals/screens/recipe_details_screen.dart';
import 'package:mymeals/screens/recipes_screen.dart';
import 'package:mymeals/screens/recipesearch_results.dart';
import 'package:mymeals/screens/register_screen.dart';
import 'package:mymeals/screens/setttings_screen.dart';
import 'package:mymeals/screens/tabs_screen.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('Screen Tests', () {
    testWidgets('MyApp Screen renders correctly', (tester) async {
      await tester.pumpWidget(const MyApp(
        testMode: true,
      ));
    });

    testWidgets('MyApp Screen renders correctly', (tester) async {});

    testWidgets('Dashboard Screen renders correctly', (tester) async {
      final mockFirestore = FakeFirebaseFirestore();
      await tester.pumpWidget(MaterialApp(
          home: DashBoard(
        testMode: true,
        mockFirestore: mockFirestore,
      )));
    });

    testWidgets('Dashboard Screen add card renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: DashBoard(
        testMode: true,
      )));

      final DashBoardState myWidgetState = tester.state(find.byType(DashBoard));
      myWidgetState.addMealtoList();
      myWidgetState.onRefresh();
      expect(myWidgetState.mealList.length, 1);
    });

    testWidgets('Dashboard Screen gets card info form Firestore',
        (tester) async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();
      await tester.pumpWidget(MaterialApp(
          home: DashBoard(
        testMode: true,
        mockFirestore: mockFirestore,
      )));
      await inst.addCalories("mealName", 200, "mealType", 200, 200, 200);
      final DashBoardState myWidgetState = tester.state(find.byType(DashBoard));
      await myWidgetState.addMealtoList();
      myWidgetState.onRefresh();
      expect(myWidgetState.mealList.length, 2);
    });

    testWidgets('Data Screen renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: DataScreen(
        testMode: true,
      )));
    });

    testWidgets('HomeScreen renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: HomeScreen(
        testMode: true,
      )));
    });

    testWidgets('HomeScreen Sets the light theme correctly', (tester) async {
      SharedPreferences.setMockInitialValues({"theme": "light"});
      await tester.pumpWidget(const MaterialApp(
          home: HomeScreen(
        testMode: true,
      )));

      final HomeScreenState myWidgetState =
          tester.state(find.byType(HomeScreen));
      expect(await myWidgetState.setThemeMode(), "light");
    });

    testWidgets('HomeScreen Sets the dark theme correctly', (tester) async {
      SharedPreferences.setMockInitialValues({"theme": "dark"});
      await tester.pumpWidget(const MaterialApp(
          home: HomeScreen(
        testMode: true,
      )));

      final HomeScreenState myWidgetState =
          tester.state(find.byType(HomeScreen));
      expect(await myWidgetState.setThemeMode(), "dark");
    });

    testWidgets('HomeScreen Sets the system theme correctly', (tester) async {
      SharedPreferences.setMockInitialValues({"theme": "system"});
      await tester.pumpWidget(const MaterialApp(
          home: HomeScreen(
        testMode: true,
      )));

      final HomeScreenState myWidgetState =
          tester.state(find.byType(HomeScreen));
      expect(await myWidgetState.setThemeMode(), "system");
    });

    testWidgets('HomeScreen Change theme Sets the state of the theme correctly',
        (tester) async {
      SharedPreferences.setMockInitialValues({"theme": "light"});
      await tester.pumpWidget(const MaterialApp(
          home: HomeScreen(
        testMode: true,
      )));

      final HomeScreenState myWidgetState =
          tester.state(find.byType(HomeScreen));
      await myWidgetState.changeTheme(ThemeMode.light);
      expect(myWidgetState.themeMode, ThemeMode.light);
    });

    testWidgets('HomeScreen Routes initiate correctly', (tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(MaterialApp(
          navigatorObservers: [mockObserver],
          home: const HomeScreen(
            testMode: true,
          )));
      expect(find.byType(DashBoard), findsOneWidget);
    });

    testWidgets('LoginScreen renders correctly', (tester) async {
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth();
      await tester.pumpWidget(MaterialApp(
          home: LoginScreen(
        testMode: true,
        mockGoogleSignIn: googleSignIn,
        mockAuth: auth,
      )));
    });

    testWidgets('LoginScreen Loggs in correctly', (tester) async {
      final user = MockUser(
        isAnonymous: false,
        uid: '001',
        email: 'test@test.com',
        displayName: 'Doe',
      );
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth(mockUser: user);
      await tester.pumpWidget(MaterialApp(
          home: LoginScreen(
        testMode: true,
        mockAuth: auth,
        mockGoogleSignIn: googleSignIn,
      )));

      final LoginScreenState myWidgetState =
          tester.state(find.byType(LoginScreen));
      myWidgetState.emailController.text = "test@test.com";
      await myWidgetState.signin();

      expect(auth.currentUser!.email, 'test@test.com');
    });

    testWidgets('LoginScreen Google Loggs in correctly', (tester) async {
      final user = MockUser(
        isAnonymous: false,
        uid: '001',
        email: 'test@test.com',
        displayName: 'Doe',
      );
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth(mockUser: user);
      await tester.pumpWidget(MaterialApp(
          home: LoginScreen(
        testMode: true,
        mockAuth: auth,
        mockGoogleSignIn: googleSignIn,
      )));

      final LoginScreenState myWidgetState =
          tester.state(find.byType(LoginScreen));
      await myWidgetState.googleSignIn();
      expect(auth.currentUser!.email, 'test@test.com');
    });

    testWidgets('Recipe Details Screen renders correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: RecipeDetailScreen(
        data: Recipe(
            title: "pasta",
            photo: "photo",
            calories: "100",
            mealTime: "lunch",
            time: "now",
            description: "description",
            ingridients: [Ingridient(name: "name", size: "size")],
            nutriments: [Ingridient(name: "name", size: "size")]),
        testMode: true,
      )));
    });
    testWidgets('Recipe Details Screen adds meal to FireStore correctly',
        (tester) async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();

      await tester.pumpWidget(MaterialApp(
          home: RecipeDetailScreen(
        data: Recipe(
            title: "pasta",
            photo: "photo",
            calories: "100",
            mealTime: "lunch",
            time: "time",
            description: "description",
            ingridients: [
              Ingridient(name: "name", size: "3")
            ],
            nutriments: [
              Ingridient(name: "name", size: "3"),
              Ingridient(name: "name", size: "3"),
              Ingridient(name: "name", size: "3"),
              Ingridient(name: "name", size: "3"),
              Ingridient(name: "name", size: "3"),
              Ingridient(name: "name", size: "3")
            ]),
        testMode: true,
        mockFirestore: mockFirestore,
      )));

      final RecipeDetailScreenState myWidgetState =
          tester.state(find.byType(RecipeDetailScreen));
      myWidgetState.portions = 0;
      await myWidgetState.addMealtoDb();
      expect(myWidgetState.successSave, " Meal Already Added");
      expect(myWidgetState.showSaveAlert, false);
    });

    testWidgets('Recipe Screen renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: RecipesScreen(
        testMode: true,
      )));
    });

    testWidgets('Recipe Screen Search by ingr behaves correctly',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: RecipesScreen(
        testMode: true,
      )));

      final RecipesScreenState myWidgetState =
          tester.state(find.byType(RecipesScreen));
      myWidgetState.calories = "10";
      myWidgetState.mealTime = 'Breakfast';
      myWidgetState.mealType = 'American';
      int response = await myWidgetState.searchbyIngr();
      expect(response, 0);
    });

    testWidgets('Recipe Screen healthy Search by behaves correctly',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: RecipesScreen(
        testMode: true,
      )));

      final RecipesScreenState myWidgetState =
          tester.state(find.byType(RecipesScreen));
      myWidgetState.calories = "1000";
      myWidgetState.mealTime = 'Dinner';
      int response = await myWidgetState.searchHealthy();
      expect(response, 0);
    });

    testWidgets('Recipe Screen random Search by behaves correctly',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: RecipesScreen(
        testMode: true,
      )));

      final RecipesScreenState myWidgetState =
          tester.state(find.byType(RecipesScreen));
      myWidgetState.mealTime = 'Snack';
      int response = await myWidgetState.randomRecipe();
      expect(response, 0);
    });

    testWidgets('Recipe Screen Explore Search behaves correctly',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: RecipesScreen(
        testMode: true,
      )));

      final RecipesScreenState myWidgetState =
          tester.state(find.byType(RecipesScreen));
      myWidgetState.mealTime = 'Snack';
      myWidgetState.mealType = 'Italian';
      int response = await myWidgetState.randomTypeRecipe();
      expect(response, 0);
    });

    testWidgets('Recipe Screen Analysis behaves correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: RecipesScreen(
        testMode: true,
      )));

      final RecipesScreenState myWidgetState =
          tester.state(find.byType(RecipesScreen));
      myWidgetState.ingredients = 'test';
      int response = await myWidgetState.recipeAnalysis();
      expect(myWidgetState.showResultDialog, true);
      expect(response, 0);
    });

    testWidgets('Recipe Screen Analysis saves result', (tester) async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await tester.pumpWidget(MaterialApp(
          home: RecipesScreen(
        testMode: true,
        mockFirestore: mockFirestore,
      )));

      await inst.firstLoginSetUp();
      final RecipesScreenState myWidgetState =
          tester.state(find.byType(RecipesScreen));
      myWidgetState.ingredients = '100g beef';
      myWidgetState.recipeAnalysisResult = {
        "kcal": 100,
        "fat": 100,
        "protein": 100,
        "carbs": 100,
      };
      myWidgetState.mealName = "Test";
      dynamic response = await myWidgetState.saveAnalysisResult();
      expect(response.length, 1);
    });

    testWidgets('Recipe Screen dialog controller behaves correctly',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: RecipesScreen(
        testMode: true,
      )));

      final RecipesScreenState myWidgetState =
          tester.state(find.byType(RecipesScreen));

      myWidgetState.dialogController(0);
      expect(myWidgetState.showCasualDialog, true);

      myWidgetState.dialogController(1);
      expect(myWidgetState.showHealthyDialog, true);

      myWidgetState.dialogController(2);
      expect(myWidgetState.showRandomDialog, true);

      myWidgetState.dialogController(3);
      expect(myWidgetState.showAnalyzeDialog, true);

      myWidgetState.dialogController(4);
      expect(myWidgetState.showTypeDialog, true);
    });

    testWidgets('Recipe Search Screen renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: RecipeSearchResultScreen(
        testMode: true,
        searchResults: {},
      )));
    });

    testWidgets('Recipe Search Screen initialized correctly', (tester) async {
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(MaterialApp(
        navigatorObservers: [mockObserver],
        home: const RecipeSearchResultScreen(
          testMode: true,
          searchResults: {
            "recipeByIngr": [
              {
                "label": "Homemade Brown Sugar Recipe",
                "image":
                    "https://edamam-product-images.s3.amazonaws.com/web-img/ce0/ce03b4b005a873f357c36cc317e32791.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjECQaCXVzLWVhc3QtMSJHMEUCIQCvL2HZCdChOE6uP%2FcuSfGqY%2FMxM081k%2Bx8P%2BfZh8u%2BaQIgQam6y6ruCgAuMd%2FSDlGUcg7wIf1o0iUoAOCapepBqD0q1QQIjf%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwxODcwMTcxNTA5ODYiDPeYLRqmX6rJxpcwUyqpBE5sA8wvdvhChoJGyX53VYzDF3QwBx2vuoq0uIgsLb%2BMU19B%2FuJV7QDqEMVWiSvCyxBccvdcEq3KeBYxYeDcy4vA2ndYOCogTkmTqrxr8cmBOkE%2Fu8Ckerf2cV%2BnLUBkUAtOgaE4GpYP2da0Ztb0aXpiGvFR9rL39xVmoT%2F%2Fj6tjSn72ud3RqF5PyyQApxRoA7wujb9SA%2BNTw6PyB6c6%2BVQefRhMMmRrA4MbKbTusqjY79IevskTFiB1d2ialcQVAGD3sl1RpE4CrJw3llddVycgjagJff%2FVivZc%2FgIqWc%2BRJgtkVDxZeR6powhZlEKirzaU8Bp5xIFdsnfmJpYe%2FHaAOOqq5NMls5wrRFjCFbiwp9YuPQQxaWOchRV5FtDTrZrK0YCLgIQvkmJ4xSrB1rJim1oAU2xl%2FAQtQi%2FZf%2BEQ6bLPpB6LSLGH%2BMWMyGMexuqV%2BAHlGpUTn%2B5WgNaKV7U3PxkAP2cXZCZA1qzB2CtoACsjIq3jD4bDbS%2FpAVSp874XfwpMU8GQM89tbRHhLUE%2BfW3DCoKZYCmZfHwiT2lt%2BRZMjICOqXiRmm%2FFWPIgCQG1UL%2F9C8WHTIPt%2FKXPAvq5eZYseI5UfqLOJ7voUQu7qh7yS1ejGiu%2B%2BY3kmVoDvYLI2tkKVt7LWiVfzG%2FDpsBYmmEUxm2Rh8lLI3rd4SRlyytH6j%2FbkI3%2B0VkdGn5hRv3HniCVlwMlGbvdxrfpEE439liJNtwruy8whf6pngY6qQFhS%2FmGr3TduBLKP9UJQe951u1AQ2cSRA%2FbSjNB5TVnQJfWrspXG67%2BZTCQz938VdzWHHRTLRLYOAWIMONubWyW%2Fo6N50NPtQj0tVsTG1nEdr%2FI%2BPbQ2isTbtbEtyL7a1EO7XmBDNhzt1t5Puq12fDx82edEu6Fxh1aX3m2Qijn0nrzMILpe1fl877voa5weBerLXEQzGcTFt4DqpGL0RVP3emCG%2BJ97WEF&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230120T124853Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFIZKVXPVR%2F20230120%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=7943b19dc71eac7750be9a2b7d0746200f67886f1bccda5bd89945df2c30f4b5",
                "url":
                    "https://www.seriouseats.com/recipes/2017/02/homemade-diy-brown-sugar-recipe.html",
                "yield": 4.0,
                "ingredients": [
                  {
                    "text":
                        "12 1/2 ounces white or toasted sugar (about 1 3/4 cups; 355g)",
                    "quantity": 12.5,
                    "measure": "ounce",
                    "food": "sugar",
                    "weight": 354.3690390625,
                    "foodCategory": "sugars",
                    "foodId": "food_axi2ijobrk819yb0adceobnhm1c2",
                    "image":
                        "https://www.edamam.com/food-img/ecb/ecb3f5aaed96d0188c21b8369be07765.jpg"
                  },
                  {
                    "text":
                        "1 1/2 ounces unsulfured molasses, not blackstrap (about 2 tablespoons; 40g)",
                    "quantity": 1.5,
                    "measure": "ounce",
                    "food": "molasses",
                    "weight": 42.5242846875,
                    "foodCategory": "sugar syrups",
                    "foodId": "food_b61rwdgbx1ch0yabdfbn5b18umam",
                    "image":
                        "https://www.edamam.com/food-img/800/800f6133e1db5bef8332290e0b23b2cc.jpg"
                  }
                ],
                "calories": 1494.728606765625,
                "totalWeight": 396.89332375000004,
                "totalTime": 5.0,
                "cuisineType": ["american"],
                "mealType": ["snack"],
                "totalNutrients": {
                  "ENERC_KCAL": {
                    "label": "Energy",
                    "quantity": 1494.728606765625,
                    "unit": "kcal"
                  },
                  "FAT": {
                    "label": "Fat",
                    "quantity": 0.042524284687500004,
                    "unit": "g"
                  },
                  "CHOCDF": {
                    "label": "Carbs",
                    "quantity": 386.0765632016563,
                    "unit": "g"
                  },
                  "PROCNT": {"label": "Protein", "quantity": 0.0, "unit": "g"},
                },
              },
              {
                "label": "Homemade Brown Sugar Recipe",
                "image":
                    "https://edamam-product-images.s3.amazonaws.com/web-img/ce0/ce03b4b005a873f357c36cc317e32791.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjECQaCXVzLWVhc3QtMSJHMEUCIQCvL2HZCdChOE6uP%2FcuSfGqY%2FMxM081k%2Bx8P%2BfZh8u%2BaQIgQam6y6ruCgAuMd%2FSDlGUcg7wIf1o0iUoAOCapepBqD0q1QQIjf%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwxODcwMTcxNTA5ODYiDPeYLRqmX6rJxpcwUyqpBE5sA8wvdvhChoJGyX53VYzDF3QwBx2vuoq0uIgsLb%2BMU19B%2FuJV7QDqEMVWiSvCyxBccvdcEq3KeBYxYeDcy4vA2ndYOCogTkmTqrxr8cmBOkE%2Fu8Ckerf2cV%2BnLUBkUAtOgaE4GpYP2da0Ztb0aXpiGvFR9rL39xVmoT%2F%2Fj6tjSn72ud3RqF5PyyQApxRoA7wujb9SA%2BNTw6PyB6c6%2BVQefRhMMmRrA4MbKbTusqjY79IevskTFiB1d2ialcQVAGD3sl1RpE4CrJw3llddVycgjagJff%2FVivZc%2FgIqWc%2BRJgtkVDxZeR6powhZlEKirzaU8Bp5xIFdsnfmJpYe%2FHaAOOqq5NMls5wrRFjCFbiwp9YuPQQxaWOchRV5FtDTrZrK0YCLgIQvkmJ4xSrB1rJim1oAU2xl%2FAQtQi%2FZf%2BEQ6bLPpB6LSLGH%2BMWMyGMexuqV%2BAHlGpUTn%2B5WgNaKV7U3PxkAP2cXZCZA1qzB2CtoACsjIq3jD4bDbS%2FpAVSp874XfwpMU8GQM89tbRHhLUE%2BfW3DCoKZYCmZfHwiT2lt%2BRZMjICOqXiRmm%2FFWPIgCQG1UL%2F9C8WHTIPt%2FKXPAvq5eZYseI5UfqLOJ7voUQu7qh7yS1ejGiu%2B%2BY3kmVoDvYLI2tkKVt7LWiVfzG%2FDpsBYmmEUxm2Rh8lLI3rd4SRlyytH6j%2FbkI3%2B0VkdGn5hRv3HniCVlwMlGbvdxrfpEE439liJNtwruy8whf6pngY6qQFhS%2FmGr3TduBLKP9UJQe951u1AQ2cSRA%2FbSjNB5TVnQJfWrspXG67%2BZTCQz938VdzWHHRTLRLYOAWIMONubWyW%2Fo6N50NPtQj0tVsTG1nEdr%2FI%2BPbQ2isTbtbEtyL7a1EO7XmBDNhzt1t5Puq12fDx82edEu6Fxh1aX3m2Qijn0nrzMILpe1fl877voa5weBerLXEQzGcTFt4DqpGL0RVP3emCG%2BJ97WEF&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230120T124853Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFIZKVXPVR%2F20230120%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=7943b19dc71eac7750be9a2b7d0746200f67886f1bccda5bd89945df2c30f4b5",
                "url":
                    "https://www.seriouseats.com/recipes/2017/02/homemade-diy-brown-sugar-recipe.html",
                "yield": 4.0,
                "ingredients": [
                  {
                    "text":
                        "12 1/2 ounces white or toasted sugar (about 1 3/4 cups; 355g)",
                    "quantity": 12.5,
                    "measure": "ounce",
                    "food": "sugar",
                    "weight": 354.3690390625,
                    "foodCategory": "sugars",
                    "foodId": "food_axi2ijobrk819yb0adceobnhm1c2",
                    "image":
                        "https://www.edamam.com/food-img/ecb/ecb3f5aaed96d0188c21b8369be07765.jpg"
                  },
                  {
                    "text":
                        "1 1/2 ounces unsulfured molasses, not blackstrap (about 2 tablespoons; 40g)",
                    "quantity": 1.5,
                    "measure": "ounce",
                    "food": "molasses",
                    "weight": 42.5242846875,
                    "foodCategory": "sugar syrups",
                    "foodId": "food_b61rwdgbx1ch0yabdfbn5b18umam",
                    "image":
                        "https://www.edamam.com/food-img/800/800f6133e1db5bef8332290e0b23b2cc.jpg"
                  }
                ],
                "calories": 1494.728606765625,
                "totalWeight": 396.89332375000004,
                "totalTime": 5.0,
                "cuisineType": ["american"],
                "mealType": ["snack"],
                "totalNutrients": {
                  "ENERC_KCAL": {
                    "label": "Energy",
                    "quantity": 1494.728606765625,
                    "unit": "kcal"
                  },
                  "FAT": {
                    "label": "Fat",
                    "quantity": 0.042524284687500004,
                    "unit": "g"
                  },
                  "CHOCDF": {
                    "label": "Carbs",
                    "quantity": 386.0765632016563,
                    "unit": "g"
                  },
                  "PROCNT": {"label": "Protein", "quantity": 0.0, "unit": "g"},
                },
              },
              {
                "label": "Homemade Brown Sugar Recipe",
                "image":
                    "https://edamam-product-images.s3.amazonaws.com/web-img/ce0/ce03b4b005a873f357c36cc317e32791.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjECQaCXVzLWVhc3QtMSJHMEUCIQCvL2HZCdChOE6uP%2FcuSfGqY%2FMxM081k%2Bx8P%2BfZh8u%2BaQIgQam6y6ruCgAuMd%2FSDlGUcg7wIf1o0iUoAOCapepBqD0q1QQIjf%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwxODcwMTcxNTA5ODYiDPeYLRqmX6rJxpcwUyqpBE5sA8wvdvhChoJGyX53VYzDF3QwBx2vuoq0uIgsLb%2BMU19B%2FuJV7QDqEMVWiSvCyxBccvdcEq3KeBYxYeDcy4vA2ndYOCogTkmTqrxr8cmBOkE%2Fu8Ckerf2cV%2BnLUBkUAtOgaE4GpYP2da0Ztb0aXpiGvFR9rL39xVmoT%2F%2Fj6tjSn72ud3RqF5PyyQApxRoA7wujb9SA%2BNTw6PyB6c6%2BVQefRhMMmRrA4MbKbTusqjY79IevskTFiB1d2ialcQVAGD3sl1RpE4CrJw3llddVycgjagJff%2FVivZc%2FgIqWc%2BRJgtkVDxZeR6powhZlEKirzaU8Bp5xIFdsnfmJpYe%2FHaAOOqq5NMls5wrRFjCFbiwp9YuPQQxaWOchRV5FtDTrZrK0YCLgIQvkmJ4xSrB1rJim1oAU2xl%2FAQtQi%2FZf%2BEQ6bLPpB6LSLGH%2BMWMyGMexuqV%2BAHlGpUTn%2B5WgNaKV7U3PxkAP2cXZCZA1qzB2CtoACsjIq3jD4bDbS%2FpAVSp874XfwpMU8GQM89tbRHhLUE%2BfW3DCoKZYCmZfHwiT2lt%2BRZMjICOqXiRmm%2FFWPIgCQG1UL%2F9C8WHTIPt%2FKXPAvq5eZYseI5UfqLOJ7voUQu7qh7yS1ejGiu%2B%2BY3kmVoDvYLI2tkKVt7LWiVfzG%2FDpsBYmmEUxm2Rh8lLI3rd4SRlyytH6j%2FbkI3%2B0VkdGn5hRv3HniCVlwMlGbvdxrfpEE439liJNtwruy8whf6pngY6qQFhS%2FmGr3TduBLKP9UJQe951u1AQ2cSRA%2FbSjNB5TVnQJfWrspXG67%2BZTCQz938VdzWHHRTLRLYOAWIMONubWyW%2Fo6N50NPtQj0tVsTG1nEdr%2FI%2BPbQ2isTbtbEtyL7a1EO7XmBDNhzt1t5Puq12fDx82edEu6Fxh1aX3m2Qijn0nrzMILpe1fl877voa5weBerLXEQzGcTFt4DqpGL0RVP3emCG%2BJ97WEF&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230120T124853Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFIZKVXPVR%2F20230120%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=7943b19dc71eac7750be9a2b7d0746200f67886f1bccda5bd89945df2c30f4b5",
                "url":
                    "https://www.seriouseats.com/recipes/2017/02/homemade-diy-brown-sugar-recipe.html",
                "yield": 4.0,
                "ingredients": [
                  {
                    "text":
                        "12 1/2 ounces white or toasted sugar (about 1 3/4 cups; 355g)",
                    "quantity": 12.5,
                    "measure": "ounce",
                    "food": "sugar",
                    "weight": 354.3690390625,
                    "foodCategory": "sugars",
                    "foodId": "food_axi2ijobrk819yb0adceobnhm1c2",
                    "image":
                        "https://www.edamam.com/food-img/ecb/ecb3f5aaed96d0188c21b8369be07765.jpg"
                  },
                  {
                    "text":
                        "1 1/2 ounces unsulfured molasses, not blackstrap (about 2 tablespoons; 40g)",
                    "quantity": 1.5,
                    "measure": "ounce",
                    "food": "molasses",
                    "weight": 42.5242846875,
                    "foodCategory": "sugar syrups",
                    "foodId": "food_b61rwdgbx1ch0yabdfbn5b18umam",
                    "image":
                        "https://www.edamam.com/food-img/800/800f6133e1db5bef8332290e0b23b2cc.jpg"
                  }
                ],
                "calories": 1494.728606765625,
                "totalWeight": 396.89332375000004,
                "totalTime": 5.0,
                "cuisineType": ["american"],
                "mealType": ["snack"],
                "totalNutrients": {
                  "ENERC_KCAL": {
                    "label": "Energy",
                    "quantity": 1494.728606765625,
                    "unit": "kcal"
                  },
                  "FAT": {
                    "label": "Fat",
                    "quantity": 0.042524284687500004,
                    "unit": "g"
                  },
                  "CHOCDF": {
                    "label": "Carbs",
                    "quantity": 386.0765632016563,
                    "unit": "g"
                  },
                  "PROCNT": {"label": "Protein", "quantity": 0.0, "unit": "g"},
                },
              },
            ]
          },
        ),
      ));

      final RecipeSearchResultScreenState myWidgetState =
          tester.state(find.byType(RecipeSearchResultScreen));
      expect(myWidgetState.seeRecipeDetails(0) is Recipe, true);
    });

    testWidgets('Register Screen renders correctly', (tester) async {
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth();
      await tester.pumpWidget(MaterialApp(
          home: RegisterScreen(
        testMode: true,
        mockAuth: auth,
        mockGoogleSignIn: googleSignIn,
      )));
    });

    testWidgets('Register Screen register saves creates account',
        (tester) async {
      final googleSignIn = MockGoogleSignIn();
      final auth = MockFirebaseAuth();
      await tester.pumpWidget(MaterialApp(
          home: RegisterScreen(
        testMode: true,
        mockAuth: auth,
        mockGoogleSignIn: googleSignIn,
      )));

      final RegisterScreenState myWidgetState =
          tester.state(find.byType(RegisterScreen));
      myWidgetState.emailController.text = "abc@abc.com";
      await myWidgetState.register();
      expect(auth.currentUser!.email, myWidgetState.emailController.text);
    });

    testWidgets('Settings Screen renders correctly', (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: SettingsScreen(
        testMode: true,
      )));
    });

    testWidgets('Settings Screen theme popup renders correctly',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: SettingsScreen(
        testMode: true,
      )));
      final SettingsScreenState myWidgetState =
          tester.state(find.byType(SettingsScreen));
      myWidgetState.themePopUp();
      expect(myWidgetState.showThemeMenu, true);
    });

    testWidgets('Settings Screen calories popup renders correctly',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: SettingsScreen(
        testMode: true,
      )));
      final SettingsScreenState myWidgetState =
          tester.state(find.byType(SettingsScreen));
      myWidgetState.caloriesPopUp();
      expect(myWidgetState.showThemeMenu, false);
      expect(myWidgetState.showCaloriesMenu, true);
    });

    testWidgets(
        'Settings Save target calories behaves correctly with Firestore',
        (tester) async {
      final mockFirestore = FakeFirebaseFirestore();
      UserDataServices inst =
          UserDataServices(testMode: true, mockFirestore: mockFirestore);
      await inst.firstLoginSetUp();

      await tester.pumpWidget(MaterialApp(
          home: SettingsScreen(
        testMode: true,
        mockFirestore: mockFirestore,
      )));
      final SettingsScreenState myWidgetState =
          tester.state(find.byType(SettingsScreen));
      myWidgetState.targetCalories = "2500";
      myWidgetState.saveTargetCalories();
      expect(myWidgetState.targetCalories, "2500");
      expect(myWidgetState.showSaveAlert, false);
      expect(myWidgetState.showCaloriesMenu, false);
    });

    testWidgets('Settings Screen changes theme correctly', (tester) async {
      SharedPreferences.setMockInitialValues({"theme": "light"});
      await tester.pumpWidget(const MaterialApp(
          home: SettingsScreen(
        testMode: true,
      )));

      final SettingsScreenState myWidgetState =
          tester.state(find.byType(SettingsScreen));
      SharedPreferences prefs = await myWidgetState.setTheme("dark");
      expect(prefs.get("theme"), "dark");
    });

    testWidgets('Bottom Drawer Screen renders correctly', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: TabsScreen(
        testMode: true,
      )));
    });
  });
}
