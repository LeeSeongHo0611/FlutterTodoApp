import 'package:flutter/material.dart';
import 'package:todo_list/controllers/memo_controller.dart';
import 'package:todo_list/models/memo.dart';
import 'package:uuid/uuid.dart'; // 고유 ID 생성을 위한 패키지

class MemoView extends StatefulWidget {
  @override
  _MemoViewState createState() => _MemoViewState();
}

class _MemoViewState extends State<MemoView> {
  MemoController memoController = MemoController();
  List<Memo> memoList = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  // 메모 목록 불러오기
  Future<void> _loadMemos() async {
    List<Memo> loadedMemos = await memoController.getMemos();
    setState(() {
      memoList = loadedMemos;
    });
  }

  // 메모 추가
  void _addMemo() {
    Memo newMemo = Memo(
      id: Uuid().v4(),
      title: titleController.text,
      content: contentController.text,
    );
    memoController.addMemo(newMemo);
    titleController.clear();
    contentController.clear();
    _loadMemos();
  }

  // 메모 삭제
  void _deleteMemo(String id) {
    memoController.deleteMemo(id);
    _loadMemos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모장'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: '내용'),
            ),
          ),
          ElevatedButton(
            onPressed: _addMemo,
            child: Text('메모 추가'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: memoList.length,
              itemBuilder: (context, index) {
                Memo memo = memoList[index];
                return ListTile(
                  title: Text(memo.title!),
                  subtitle: Text(memo.content!),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteMemo(memo.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
