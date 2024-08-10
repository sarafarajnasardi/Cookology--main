import 'package:cookology/screens/Your_Recipes.dart';
import 'package:cookology/screens/tabs_screen.dart';
import 'package:flutter/material.dart';

import '../screens/filters_screen.dart';
import '../screens/add_recipe_screen.dart'; // Import the AddRecipeScreen

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon, VoidCallback tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Colors.blueGrey,
            child: Text(
              'CookBook!',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile('Meals', Icons.restaurant, () {
            Navigator.of(context).pushReplacementNamed(TabsScreen.routeName);
          }),
          buildListTile('Filters', Icons.filter_alt_rounded, () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(FiltersScreen.routeName);
          }),
          buildListTile('Add Recipe', Icons.add, () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(AddRecipeScreen.routeName); // Navigate to AddRecipeScreen
          }),
          buildListTile('Your Recipe', Icons.receipt_long_outlined, () {
            Navigator.pop(context);
            Navigator.of(context).pushNamed(YourRecipes.routeName); // Navigate to AddRecipeScreen
          }),
        ],
      ),
    );
  }
}

