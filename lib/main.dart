import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/controllers/todo_controller.dart'; // Todo 컨트롤러 import
import 'package:todo_list/views/addTodo.dart';
import 'package:todo_list/views/clearList.dart';
import 'models/todo.dart'; // Todo 모델 import

void main() async {
  print("Flutter 초기화");
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화
  print("Flutter 초기화 완료");
  print("Firebase 초기화");
  await Firebase.initializeApp(); // Firebase 초기화
  print("Firebase 초기화 완료");
  print("MyApp 시작");  // 앱 실행 시작
  runApp(MyApp()); // MyApp 실행
  print("MyApp 실행 완료");  // MyApp 실행 완료 메시지
}

// MyApp 클래스: 앱의 루트 위젯
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // 앱의 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 기본 테마 색상
        visualDensity: VisualDensity.adaptivePlatformDensity, // 플랫폼에 따라 밀도 설정
      ),
      initialRoute: '/', // 초기 화면 경로
      routes: {
        '/': (context) => DatabaseApp(), // 초기 화면 경로 (할 일 목록)
        '/add': (context) => addTodoApp(), // 할 일 추가 화면 경로
        '/clear': (context) => clearListApp(), // 완료된 할 일 목록 화면 경로
      },
    );
  }
}

// DatabaseApp: 할 일 목록을 보여주는 메인 화면의 StatefulWidget
class DatabaseApp extends StatefulWidget {
  @override
  _DatabaseAppState createState() => _DatabaseAppState();
}

// _DatabaseAppState: 할 일 목록 화면의 상태 관리 클래스
class _DatabaseAppState extends State<DatabaseApp> {
  TodoController todoController = TodoController(); // TodoController 인스턴스 생성
  Stream<List<Todo>>? todoListStream; // 실시간 할 일 목록 스트림

  @override
  void initState() {
    super.initState();
    todoListStream = todoController.getTodos(); // Firestore에서 실시간으로 할 일 목록 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'), // 상단 앱바에 표시될 텍스트
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              // 완료된 할 일 화면으로 이동 후, 목록 새로고침
              Navigator.of(context).pushNamed('/clear').then((value) {
                setState(() {
                  todoListStream = todoController.getTodos(); // 할 일 목록 새로고침
                });
              });
            },
            child: Text('완료한 일', style: TextStyle(color: Colors.white)), // 완료한 일 버튼
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: todoListStream, // 할 일 목록의 스트림을 감시
        builder: (context, snapshot) {
          // 데이터를 기다리는 중일 때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // 로딩 스피너 표시
          }
          // 할 일이 없을 때
          else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data'); // 할 일 목록이 없을 경우 텍스트 표시
          }

          // 할 일 목록이 있을 때
          List<Todo> todoList = snapshot.data!; // 할 일 리스트
          return ListView.builder(
            itemCount: todoList.length, // 할 일의 개수
            itemBuilder: (context, index) {
              Todo todo = todoList[index]; // 각 할 일 데이터
              return ListTile(
                title: Text(todo.title!), // 할 일의 제목 표시
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todo.content!), // 할 일의 내용 표시
                    Text('체크: ${todo.active == 1 ? 'true' : 'false'}'), // 체크 여부 표시
                    Divider(color: Colors.blue), // 구분선
                  ],
                ),
                // 할 일 항목 클릭 시 상태 변경 대화상자 표시
                onTap: () async {
                  bool? result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('${todo.id}: ${todo.title}'), // 제목
                        content: Text('Todo를 체크하시겠습니까?'), // 내용
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                todo.active = todo.active == 1 ? 0 : 1; // 상태 변경
                              });
                              todoController.updateTodo(todo); // Firestore에 업데이트
                              Navigator.of(context).pop(true); // 대화상자 닫기
                            },
                            child: Text('예'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false), // 취소
                            child: Text('아니요'),
                          ),
                        ],
                      );
                    },
                  );
                  if (result == true) {
                    setState(() {
                      todoListStream = todoController.getTodos(); // 할 일 목록 새로고침
                    });
                  }
                },
                // 할 일 항목을 길게 누르면 삭제 대화상자 표시
                onLongPress: () async {
                  bool? result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('${todo.id}: ${todo.title}'),
                        content: Text('${todo.content}를 삭제하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              todoController.deleteTodo(todo.id!); // Firestore에서 할 일 삭제
                              Navigator.of(context).pop(true);
                            },
                            child: Text('예'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('아니요'),
                          ),
                        ],
                      );
                    },
                  );
                  if (result == true) {
                    setState(() {
                      todoListStream = todoController.getTodos(); // 할 일 목록 새로고침
                    });
                  }
                },
              );
            },
          );
        },
      ),
      // 플로팅 액션 버튼 (할 일 추가 및 업데이트)
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              // 할 일 추가 화면으로 이동 후, 추가된 할 일 처리
              final todo = await Navigator.of(context).pushNamed('/add');
              if (todo != null) {
                todoController.addTodo(todo as Todo); // Firestore에 할 일 추가
                setState(() {
                  todoListStream = todoController.getTodos(); // 할 일 목록 새로고침
                });
              }
            },
            child: Icon(Icons.add), // 추가 버튼
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              todoController.allUpdate(); // 모든 할 일 상태 업데이트 (완료로 변경)
              setState(() {
                todoListStream = todoController.getTodos(); // 할 일 목록 새로고침
              });
            },
            child: Icon(Icons.update), // 업데이트 버튼
          ),
        ],
      ),
    );
  }
}
