// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:todo_list/main.dart';
// import 'utils/firebase_test_utils.dart';  // Firebase Mock 처리 파일 import
//
// void main() {
//   setUpAll(() async {
//     await setupFirebaseMocks();  // Firebase 초기화를 Mock으로 처리
//   });
//
//   testWidgets('Widget smoke test', (WidgetTester tester) async {
//     // MyApp을 Firebase 호출 없이 렌더링
//     await tester.pumpWidget(MyApp());
//
//     // 특정 UI 요소가 화면에 표시되는지 확인
//     expect(find.text('No data'), findsOneWidget);
//
//     // 버튼을 탭하고 동작을 확인
//     await tester.tap(find.byIcon(Icons.add));
//     await tester.pump();
//
//     // 상태 변경 확인
//     expect(find.text('1'), findsOneWidget);
//   });
// }
