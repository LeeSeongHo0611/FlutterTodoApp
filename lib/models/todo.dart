import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String? title;
  String? content;
  int? active;
  String? id; // Firestore 문서 ID

  Todo({this.title, this.content, this.active, this.id});

  // Firestore에 저장할 수 있도록 Map 형태로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'active': active,
    };
  }

  // Firestore에서 가져온 DocumentSnapshot을 Todo 객체로 변환하는 메서드
  factory Todo.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Todo(
      id: doc.id, // Firestore 문서 ID를 객체의 id로 설정
      title: data['title'],
      content: data['content'],
      active: data['active'],
    );
  }
}
