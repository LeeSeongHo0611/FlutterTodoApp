import 'package:flutter/material.dart';
import 'package:todo_list/views/todoView.dart';            // todoView 가져오기
import 'package:todo_list/views/tableCalendarScreen.dart'; // 달력 화면 가저오기
import 'package:todo_list/views/weatherScreen.dart';       // 날씨 화면
import 'package:todo_list/views/memoView.dart';            // 메모 화면

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
            '오늘의 할일 ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 33.0,
            ),
          ),
        ),
      ),
      body: Center( // 화면 중앙 배치
        child: GridView.count(
          crossAxisCount: 2, // 2개의 열로 나누어 표시
          padding: EdgeInsets.all(16.0),
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          shrinkWrap: true, // 그리드 크기를 컨텐츠 크기에 맞춤
          children: <Widget>[
            _buildCategoryCard(context, '달력', Icons.calendar_today, TableCalendarScreen()),
            _buildCategoryCard(context, '날씨', Icons.wb_sunny, WeatherScreen()),
            _buildCategoryCard(context, '할일', Icons.list, TodoView()), // MainView -> TodoView로 변경
            _buildCategoryCard(context, '메모', Icons.note, MemoView()),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
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

