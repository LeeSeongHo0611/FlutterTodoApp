import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/models/memo.dart';

class MemoController {
  final String _storageKey = 'memo_list';

  // 모든 메모 불러오기
  Future<List<Memo>> getMemos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? memoListString = prefs.getString(_storageKey);
    if (memoListString != null) {
      List<dynamic> memoListJson = jsonDecode(memoListString);
      return memoListJson.map((json) => Memo.fromMap(json)).toList();
    }
    return [];
  }

  // 메모 추가
  Future<void> addMemo(Memo memo) async {
    List<Memo> memos = await getMemos();
    memos.add(memo);
    await _saveMemos(memos);
  }

  // 메모 삭제
  Future<void> deleteMemo(String id) async {
    List<Memo> memos = await getMemos();
    memos.removeWhere((memo) => memo.id == id);
    await _saveMemos(memos);
  }

  // 메모 저장 (내부적으로 사용)
  Future<void> _saveMemos(List<Memo> memos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memoListString = jsonEncode(memos.map((memo) => memo.toMap()).toList());
    await prefs.setString(_storageKey, memoListString);
  }
}
