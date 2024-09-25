import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo.dart';

class TodoController {
  final CollectionReference todosCollection =
  FirebaseFirestore.instance.collection('todos');

  // Firestore에서 할 일 목록 가져오기 (실시간 스트림)
  Stream<List<Todo>> getTodos() {
    return todosCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Todo.fromFirestore(doc);
      }).toList();
    });
  }

  // Firestore에 새로운 할 일 추가
  Future<void> addTodo(Todo todo) {
    return todosCollection.add(todo.toMap()).then((value) {
      print("Todo 저장 완료: ${value.id}");
    }).catchError((error) {
      print("할 일 저장 실패: $error");
    });
  }

  // Firestore에서 할 일 업데이트
  Future<void> updateTodo(Todo todo) {
    return todosCollection.doc(todo.id).update(todo.toMap()).then((_) {
      print("Todo 업데이트 완료");
    }).catchError((error) {
      print("할 일 업데이트 실패: $error");
    });
  }

  // Firestore에서 할 일 삭제
  Future<void> deleteTodo(String id) {
    return todosCollection.doc(id).delete().then((_) {
      print("Todo 삭제 완료");
    }).catchError((error) {
      print("할 일 삭제 실패: $error");
    });
  }

  // Firestore에서 완료 상태로 모든 할 일 업데이트
  Future<void> allUpdate() {
    return todosCollection.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        if (doc['active'] == 0) {
          todosCollection.doc(doc.id).update({'active': 1});
        }
      }
    });
  }
}
