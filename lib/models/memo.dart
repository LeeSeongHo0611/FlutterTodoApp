class Memo {
  String? id;
  String? title;
  String? content;

  Memo({this.id, this.title, this.content});

  // Memo 데이터를 Map 형태로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  // Map 데이터를 Memo 객체로 변환
  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'],
      title: map['title'],
      content: map['content'],
    );
  }
}
