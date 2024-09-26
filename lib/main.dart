import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/views/mainPage.dart';                 // 메인 화면
import 'package:todo_list/views/todoView.dart';                 // 할일 보기 화면
import 'package:todo_list/views/tableCalendarScreen.dart';      // 달력 화면
import 'package:todo_list/views/weatherScreen.dart';            // 날씨 화면
import 'package:todo_list/views/memoView.dart';                 // 메모 화면
import 'package:todo_list/views/addTodo.dart';                  // 할일 추가 화면
import 'package:todo_list/views/clearList.dart';                // 할일 완료 화면
import 'package:intl/date_symbol_data_local.dart';              // 로케일 초기화용 패키지 - 달력 지역 표시사용

void main() async {
  print("Flutter 초기화");
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화
  print("Flutter 초기화 완료");
  print("Firebase 초기화");
  await Firebase.initializeApp(); // Firebase 초기화
  print("Firebase 초기화 완료");
  print("로케일 데이터 (달력 지역 표시 사용) 초기화 ");
  await initializeDateFormatting('ko_KR', null);  // 로케일 데이터 초기화 (한국어)
  print("로케일 데이터 (달력 지역 표시 사용) 초기화 완료 ");
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
        '/': (context) => MainPage(),                       // 메인 페이지
        '/calendar': (context) => TableCalendarScreen(),    // 달력 페이지
        '/weather': (context) => WeatherScreen(),           // 날씨 페이지
        '/todo': (context) => TodoView(),                   // 할 일 보기 페이지
        '/memo': (context) => MemoView(),                   // 메모 페이지
        '/addtodo': (context) => AddTodoApp(),              // 할일 추가 페이지
        '/cleartodo'  : (context) => ClearListApp(),        // 할일 완료 화면
      },
    );
  }
}
