import 'package:flutter/material.dart';
import 'package:todo_list/controllers/todo_controller.dart'; // TodoController 가져오기
import 'package:todo_list/models/todo.dart'; // Todo 모델

class TodoView extends StatefulWidget { // MainView -> TodoView로 이름 변경
  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  TodoController todoController = TodoController(); // 비즈니스 인스턴스 생성
  Stream<List<Todo>>? todoListStream; // 할 일 목록 스트림

  @override
  void initState() {
    super.initState();
    todoListStream = todoController.getTodos(); // 비즈니스에서 할 일 목록 불러오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              // 완료된 할 일 화면으로 이동 후 목록 새로고침
              Navigator.of(context).pushNamed('/clear').then((value) {
                setState(() {
                  todoListStream = todoController.getTodos(); // 할 일 목록 새로고침
                });
              });
            },
            child: Text('완료한 일', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: todoListStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // 로딩 시 인디케이터 표시
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data'); // 데이터가 없을 경우 표시
          }

          List<Todo> todoList = snapshot.data!;
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              Todo todo = todoList[index];
              return ListTile(
                title: Text(todo.title!),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(todo.content!),
                    Text('체크: ${todo.active == 1 ? 'true' : 'false'}'),
                    Divider(color: Colors.blue),
                  ],
                ),
                onTap: () async {
                  bool? result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('${todo.id}: ${todo.title}'),
                        content: Text('Todo를 체크하시겠습니까?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              setState(() {
                                todo.active = todo.active == 1 ? 0 : 1;
                              });
                              todoController.updateTodo(todo); // 비즈니스에서 업데이트
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
                              todoController.deleteTodo(todo.id!); // 비즈니스에서 삭제
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () async {
              final todo = await Navigator.of(context).pushNamed('/add');
              if (todo != null) {
                todoController.addTodo(todo as Todo); // 비즈니스에서 추가
                setState(() {
                  todoListStream = todoController.getTodos(); // 할 일 목록 새로고침
                });
              }
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              todoController.allUpdate(); // 비즈니스에서 전체 업데이트
              setState(() {
                todoListStream = todoController.getTodos(); // 할 일 목록 새로고침
              });
            },
            child: Icon(Icons.update),
          ),
        ],
      ),
    );
  }
}
