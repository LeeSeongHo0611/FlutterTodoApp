import 'package:flutter/material.dart';
import 'package:todo_list/controllers/todo_controller.dart'; // TodoController 가져오기
import 'package:todo_list/models/todo.dart'; // Todo 모델

class TodoView extends StatefulWidget {
  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  TodoController todoController = TodoController();
  Stream<List<Todo>>? todoListStream;

  @override
  void initState() {
    super.initState();
    todoListStream = todoController.getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cleartodo').then((value) {
                setState(() {
                  todoListStream = todoController.getTodos();
                });
              });
            },
            child: Text('완료 목록', style: TextStyle(color: Colors.blueGrey)),
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
        stream: todoListStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                '할 일이 없습니다. 할 일을 추가해주세요!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          List<Todo> todoList = snapshot.data!;
          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              Todo todo = todoList[index];
              return Column(
                children: [
                  ListTile(
                    leading: Checkbox(
                      value: todo.active == 1,
                      onChanged: (value) async {
                        if (value == true) {
                          bool? result = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('${todo.title} 완료'),
                                content: Text('할일을 완료 하시겠습니까?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        todo.active = 1;
                                      });
                                      todoController.updateTodo(todo);
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
                              todoListStream = todoController.getTodos();
                            });
                          }
                        } else {
                          setState(() {
                            todo.active = 0;
                          });
                          todoController.updateTodo(todo);
                        }
                      },
                    ),
                    title: Text(
                      todo.title!,
                      style: TextStyle(
                        decoration: todo.active == 1 ? TextDecoration.lineThrough : null,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(todo.title!),
                          content: Text(todo.content!),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('닫기'),
                            ),
                          ],
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey), // 휴지통 아이콘을 회색으로 변경
                      onPressed: () async {
                        bool? result = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('${todo.title} 삭제'),
                              content: Text('이 할 일을 삭제하시겠습니까?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    todoController.deleteTodo(todo.id!);
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
                            todoListStream = todoController.getTodos();
                          });
                        }
                      },
                    ),
                  ),
                  Divider(thickness: 1), // 각 목록마다 밑줄 추가
                ],
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
              final todo = await Navigator.of(context).pushNamed('/addtodo');
              if (todo != null) {
                todoController.addTodo(todo as Todo);
                setState(() {
                  todoListStream = todoController.getTodos();
                });
              }
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
