import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '오늘의 할일',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 33.0,
            ),
          ),
        ),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          shrinkWrap: true,
          children: <Widget>[
            _buildCategoryCard(context, '달력', Icons.calendar_today, '/calendar'),
            _buildCategoryCard(context, '날씨', Icons.wb_sunny, '/weather'),
            _buildCategoryCard(context, '할일', Icons.list, '/todo'),
            _buildCategoryCard(context, '메모', Icons.note, '/memo'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 64.0, color: Colors.blue),
            SizedBox(height: 16.0),
            Text(title, style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
