import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Recipes, ingredients, cooks',
                prefixIcon: Icon(Icons.search_rounded),
                filled: true,
                fillColor: Color(0xFFF6F6F6),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
