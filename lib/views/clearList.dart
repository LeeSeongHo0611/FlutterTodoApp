import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart'; // Todo 모델 클래스
import 'package:todo_list/controllers/clearlist_controller.dart'; // 컨트롤러 가져오기

class ClearListApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ClearListAppState();
}

class _ClearListAppState extends State<ClearListApp> {
  ClearListController clearListController = ClearListController(); // 컨트롤러 인스턴스 생성
  Future<List<Todo>>? clearList; // 완료된 할 일 목록을 저장하는 변수

  @override
  void initState() {
    super.initState();
    clearList = clearListController.getClearList(); // 완료된 할 일 목록 가져오기
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('완료 목록', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: FutureBuilder(
            future: clearList,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<Todo> todoList = snapshot.data as List<Todo>;
                    if (todoList.isEmpty) {
                      return Text(
                        '완료 항목이 없습니다.',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: todoList.length,
                        itemBuilder: (context, index) {
                          Todo todo = todoList[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                todo.title!,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  todo.content!,
                                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                                ),
                              ),
                              trailing: Icon(Icons.check_circle, color: Colors.green),
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return Text(
                      'Failed to load data.',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    );
                  }
              }
              return Text('No data available');
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('모든 완료 항목 삭제'),
                  content: Text('모든 완료 항목을 정말로 삭제하시겠습니까?'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No')),
                  ],
                );
              });
          if (result == true) {
            await clearListController.removeAllTodos(); // 컨트롤러를 통해 Firestore에서 완료된 할 일 삭제
            setState(() {
              clearList = clearListController.getClearList(); // 삭제 후 목록을 다시 로드
            });
          }
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
