import 'package:flutter/material.dart';
import 'package:mymeals/model/recipe.dart';
import 'package:mymeals/services/data_services.dart';
import 'package:mymeals/widget/ingridient_tile.dart';
import 'package:mymeals/widget/bottom_navbar.dart';
import 'package:mymeals/widget/main_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe data;
  RecipeDetailScreen({required this.data});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  UserDataServices inst = UserDataServices();
  bool showSaveAlert = false;
  bool showSaveDialog = false;
  int portions = 0;
  String dialogMessage = "An error happened";
  String successSave = "  Add meal to daily consumed meals";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController(initialScrollOffset: 0.0);
    _scrollController.addListener(() {
      changeAppBarColor(_scrollController);
    });
  }

  void addMealtoDb() {
    try {
      double divideBy = 1;
      if (portions != 0 &&
          portions < int.parse(widget.data.nutriments[0].size)) {
        divideBy = portions / int.parse(widget.data.nutriments[0].size);
      }
      dynamic bitError = inst.addCalories(
          widget.data.title,
          (int.parse(widget.data.calories.replaceAll(RegExp(r'[^0-9]'), '')) *
                  divideBy)
              .round(),
          widget.data.mealTime,
          (int.parse(widget.data.nutriments[4].size.replaceAll(RegExp(r'[^0-9]'), '')) *
                  divideBy)
              .round(),
          (int.parse(widget.data.nutriments[5].size
                      .replaceAll(RegExp(r'[^0-9]'), '')) *
                  divideBy)
              .round(),
          (int.parse(widget.data.nutriments[3].size
                      .replaceAll(RegExp(r'[^0-9]'), '')) *
                  divideBy)
              .round());
      successSave = " Meal Already Added";
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Meal Added Successfully'),
      ));
      setState(() {});

      if (bitError == 1) {
        showSaveAlert = true;
      }
    } catch (e) {
      showSaveAlert = true;
      setState(() {});
    }
  }

  changeAppBarColor(ScrollController scrollController) {
    if (scrollController.position.hasPixels) {
      if (scrollController.position.pixels > 2.0) {
        setState(() {});
      }
      if (scrollController.position.pixels <= 2.0) {
        setState(() {});
      }
    } else {
      setState(() {});
    }
  }

  // fab to write review
  showFAB(TabController tabController) {
    int reviewTabIndex = 2;
    if (tabController.index == reviewTabIndex) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      bottomNavigationBar: BottomNavBar(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Your Recipe'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Visibility(
          visible: showSaveDialog,
          child: Center(
            child: AlertDialog(
                title: const Text('Healthy Search'),
                content: SingleChildScrollView(
                    child: SizedBox(
                        //height: 200,
                        child: Column(children: [
                  const Divider(
                    height: 5,
                  ),
                  const Divider(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (value) {
                      if (value != null) {
                        portions = int.parse(value);
                      }

                      setState(() {});
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          'Number of Portions (Max: ${widget.data.nutriments[0].size})',
                    ),
                  ),
                ]))),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      showSaveDialog = false;
                      setState(() {});
                      addMealtoDb();
                    },
                    child: const Text('Save Meal'),
                  ),
                  TextButton(
                    onPressed: () {
                      showSaveDialog = false;
                      setState(() {});
                    },
                    child: const Text('Cancel'),
                  )
                ]),
          ),
        ),
        Visibility(
            visible: showSaveAlert,
            child: Container(
                padding: EdgeInsets.only(top: 200),
                child: AlertDialog(
                    title: const Text('Notification!'),
                    content: Text(dialogMessage),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          showSaveAlert = false;
                          setState(() {});
                        },
                        child: const Text('OK'),
                      )
                    ]))),
        Visibility(
            visible: !showSaveAlert && !showSaveDialog,
            child: Expanded(
                child: ListView(
              controller: _scrollController,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              children: [
                // Section 1 - Recipe Image
                Container(
                  height: 280,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.data.photo),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Colors.black.withOpacity(0.5),
                          Colors.transparent
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    height: 280,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                // Section 2 - Recipe Info
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.only(top: 20, bottom: 30, left: 16, right: 16),
                  color: Theme.of(context).colorScheme.primary,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recipe Calories and Time
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              "${widget.data.calories} | Portions: ${widget.data.nutriments[0].size}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.alarm, size: 16, color: Colors.white),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              '${widget.data.time} min',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      // Recipe Title
                      Container(
                        margin: EdgeInsets.only(bottom: 12, top: 16),
                        child: Text(
                          widget.data.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'inter'),
                        ),
                      ),
                      // Recipe Description
                      GestureDetector(
                          onTap: () {
                            launchUrl(Uri.parse(widget.data.description
                                .replaceFirst("http:", "https:")));
                          },
                          onLongPress: () async {
                            await Clipboard.setData(
                                ClipboardData(text: widget.data.description));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Copied link to clipboard'),
                            ));
                          },
                          child: Row(children: [
                            const Icon(
                              Icons.open_in_new,
                              color: Colors.white,
                            ),
                            Text(
                              "  See Full Recipe and Instructions",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  height: 150 / 100),
                            )
                          ])),
                      const Divider(
                        height: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            showSaveDialog = true;
                            setState(() {});
                          },
                          child: Row(children: [
                            const Icon(
                              Icons.playlist_add,
                              color: Colors.white,
                            ),
                            Text(
                              successSave,
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                  height: 150 / 100),
                            )
                          ])),
                    ],
                  ),
                ),
                // Tabbar ( Ingridients, nutriments )
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).colorScheme.secondary,
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      setState(() {
                        _tabController.index = index;
                      });
                    },
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black.withOpacity(0.6),
                    labelStyle: TextStyle(
                        fontFamily: 'inter', fontWeight: FontWeight.w500),
                    indicatorColor: Colors.black,
                    tabs: [
                      Tab(
                        text: 'Ingridients',
                      ),
                      Tab(
                        text: 'Nutriments',
                      ),
                    ],
                  ),
                ),
                // IndexedStack based on TabBar index
                IndexedStack(
                  index: _tabController.index,
                  children: [
                    // Ingridients
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.data.ingridients.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return IngridientTile(
                          data: widget.data.ingridients[index],
                        );
                      },
                    ),
                    // nutriments
                    ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: widget.data.nutriments.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return IngridientTile(
                          data: widget.data.nutriments[index],
                        );
                      },
                    ),
                  ],
                ),
              ],
            )))
      ]),
    );
  }
}
