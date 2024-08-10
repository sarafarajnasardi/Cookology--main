import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/main_drawer.dart';
import 'dishes.dart'; // Adjust the import path to your project structure

class YourRecipes extends StatefulWidget {
  static const String routeName = '/your-recipes';

  @override
  _YourRecipesState createState() => _YourRecipesState();
}

class _YourRecipesState extends State<YourRecipes> {
  List<Dishes> mealsi = List.empty(growable: true);
  late SharedPreferences sp;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    sp = await SharedPreferences.getInstance();
    readFromSP();
  }

  void saveIntoSP() {
    List<String> dishListString = mealsi.map((dish) => jsonEncode(dish.toJson())).toList();
    sp.setStringList('myData', dishListString);
  }

  void readFromSP() {
    List<String>? dishListString = sp.getStringList('myData');
    if (dishListString != null) {
      setState(() {
        mealsi = dishListString.map((dish) => Dishes.fromJson(jsonDecode(dish))).toList();
      });
    }
  }

  void deleteRecipe(int index) {
    setState(() {
      mealsi.removeAt(index);
      saveIntoSP();
    });
  }

  Widget getRow(int index) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: Icon(
          Icons.restaurant_menu,
          color: Theme.of(context).primaryColor,
          size: 40,
        ),
        title: Text(
          mealsi[index].title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingredients:',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              mealsi[index].ingredients,
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(height: 12),
            Text(
              'Steps:',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              mealsi[index].steps,
              style: TextStyle(color: Colors.black54),
            ),

          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.redAccent,
          ),
          onPressed: () => deleteRecipe(index),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipes'),
      ),
      drawer: MainDrawer(),
      body: mealsi.isEmpty
          ? Center(
        child: Text(
          'No Recipes yet..',
          style: TextStyle(fontSize: 22,color: Colors.black),
        ),
      )
          : ListView.builder(
        itemCount: mealsi.length,
        itemBuilder: (context, index) {
          return getRow(index);
        },
      ),
    );
  }
}
