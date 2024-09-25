import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart'; // Todo 모델 클래스
import 'package:todo_list/controllers/clearlist_controller.dart'; // 컨트롤러 가져오기

class clearListApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _clearListApp();
}

class _clearListApp extends State<clearListApp> {
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
        title: Text('이미 한일'),
      ),
      body: Container(
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
                    return ListView.builder(
                      itemCount: (snapshot.data as List<Todo>).length,
                      itemBuilder: (context, index) {
                        Todo todo = (snapshot.data as List<Todo>)[index];
                        return ListTile(
                          title: Text(
                            todo.title!,
                            style: TextStyle(fontSize: 20),
                          ),
                          subtitle: Container(
                            child: Column(
                              children: <Widget>[
                                Text(todo.content!),
                                Container(
                                  height: 1,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
              }
              return Text('No data');
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
                  title: Text('완료한 일 삭제'),
                  content: Text('완료한 일을 모두 삭제할까요?'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('예')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('아니요')),
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
        child: Icon(Icons.remove),
      ),
    );
  }
}
