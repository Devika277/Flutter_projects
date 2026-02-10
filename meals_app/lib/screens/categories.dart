
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/data/Dummy_data.dart';
import 'package:meals_app/widgets/category_grid_items.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick your category'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          childAspectRatio: 3 /2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20
        ),  
        children:[
          //availableCategories.map((category) => CategoryGridItems(category:category.toList ))
          for (final category in availableCategories)
          CategoryGridItems(category: category)
        ],
        )
    );
  }
}