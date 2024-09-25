import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo.dart';

class ClearListController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 완료된 할 일 목록을 가져오는 함수 (active = 1인 항목)
  Future<List<Todo>> getClearList() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('todos')
        .where('active', isEqualTo: 1)
        .get();

    // 가져온 데이터를 Todo 객체 리스트로 변환
    return querySnapshot.docs.map((doc) {
      return Todo(
        title: doc['title'],
        content: doc['content'],
        id: doc.id,
      );
    }).toList();
  }

  // 완료된 모든 할 일을 Firestore에서 삭제하는 함수
  Future<void> removeAllTodos() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('todos')
        .where('active', isEqualTo: 1)
        .get();

    // 가져온 문서들을 삭제
    for (var doc in querySnapshot.docs) {
      await firestore.collection('todos').doc(doc.id).delete();
    }
  }
}
