import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/main_drawer.dart';
import 'dishes.dart';
import 'your_recipes.dart'; // Adjust the import path to your project structure

class AddRecipeScreen extends StatefulWidget {
  static const String routeName = '/add-recipe';

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleC = TextEditingController();
  final TextEditingController ingredientsC = TextEditingController();
  final TextEditingController stepsC = TextEditingController();
  String? _selectedCategory;
  String? _selectedType;

  List<String> _categories = ['Breakfast', 'Lunch', 'Dinner'];
  List<String> _types = ['Veg', 'Non-Veg'];

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

  void _addRecipe() {
    if (_formKey.currentState?.validate() ?? false) {
      String title = titleC.text.trim();
      String ingredients = ingredientsC.text.trim();
      String steps = stepsC.text.trim();
      String category = _selectedCategory ?? '';
      String type = _selectedType ?? '';

      setState(() {
        titleC.clear();
        ingredientsC.clear();
        stepsC.clear();
        _selectedCategory = null;
        _selectedType = null;
        mealsi.add(Dishes(title: title, ingredients: ingredients, steps: steps));
        saveIntoSP();
      });

      // Navigate back to 'Your Recipes' page
      Navigator.of(context).pushNamed(YourRecipes.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Recipe'),
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleC,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the recipe title';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: ingredientsC,
                  decoration: InputDecoration(
                    labelText: 'Ingredients',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the ingredients';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: stepsC,
                  decoration: InputDecoration(
                    labelText: 'Steps',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the steps';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: Text('Select Category'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  },
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  hint: Text('Select Type'),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  items: _types.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select whether it is veg or non-veg';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _addRecipe,
                    child: Text('Submit'),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddRecipeScreen(),
    routes: {
      AddRecipeScreen.routeName: (context) => AddRecipeScreen(),
      YourRecipes.routeName: (context) => YourRecipes(),
    },
  ));
}
