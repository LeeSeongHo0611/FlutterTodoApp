import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/views/mainPage.dart';  //  메인 화면
import 'package:todo_list/views/todoView.dart';  //  할일 보기
import 'package:todo_list/views/addTodo.dart';   //  할일 추가 화면
import 'package:todo_list/views/clearList.dart'; //  완료된 할 일 화면
import 'package:todo_list/views/tableCalendarScreen.dart'; // 달력 api 화면
import 'package:intl/date_symbol_data_local.dart';         // 달력 로케일 데이터 초기화
import 'package:todo_list/views/weatherScreen.dart';       // 날씨 화면

void main() async {
  print("Flutter 초기화");
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화
  print("Flutter 초기화 완료");
  print("Firebase 초기화");
  await Firebase.initializeApp(); // Firebase 초기화
  print("Firebase 초기화 완료");
  print("한국어 로케일 초기화");
  await initializeDateFormatting('ko_KR', null); // 한국어 로케일 초기화
  print("한국어 로케일 초기화 완료");
  print("MyApp 시작");
  runApp(MyApp()); // MyApp 실행
  print("MyApp 실행 완료");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(), // 메인 선택지 화면( main page)
        // '/view': (context) => TodoView(), // 할일 보기 화면
        // '/add': (context) => AddTodoApp(), // 할 일 추가 화면
        // '/clear': (context) => ClearListApp(), // 완료된 할 일 화면
        // '/tCal' : (context) => TableCalendarScreen(), // 달력 패키지 사용
        // '/wSer' : (context) => WeatherScreen(), // 날씨 화면 사용
      },
    );
  }
}
