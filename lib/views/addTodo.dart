import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart'; // Todo 모델 클래스
import 'package:todo_list/controllers/todo_controller.dart'; // Controller 가져오기

class addTodoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _addTodoApp();
}

class _addTodoApp extends State<addTodoApp> {
  TextEditingController? titleController;
  TextEditingController? contentController;
  TodoController todoController = TodoController(); // TodoController 인스턴스 생성

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo 추가'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: '제목'),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: '할일'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Firestore에 새로운 Todo를 저장하는 함수 호출
                  _saveTodo();
                  Navigator.of(context).pop(); // 저장 후 이전 화면으로 돌아감
                },
                child: Text('저장하기'),
              )
            ],
          ),
        ),
      ),
    );
  }

  // TodoController를 이용해 Firestore에 새로운 할 일을 저장하는 함수
  void _saveTodo() {
    // 할 일(Todo) 객체 생성
    Todo todo = Todo(
      title: titleController!.text,
      content: contentController!.text,
      active: 0, // 할 일 완료 여부 (0: 미완료, 1: 완료)
    );

    // 비즈니스 로직 분리: 컨트롤러를 통해 Firestore에 저장
    todoController.addTodo(todo);
  }
}
