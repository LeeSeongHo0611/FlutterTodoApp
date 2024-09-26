// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
//
// // Firebase의 플랫폼 채널을 Mock 처리
// class MockFirebaseApp extends Mock implements FirebaseApp {}
//
// // MethodChannel과 BasicMessageChannel도 Mock 처리
// class MockMethodChannel extends Mock implements MethodChannel {}
//
// class MockBasicMessageChannel extends Mock implements BasicMessageChannel<Object?> {}
//
// Future<void> setupFirebaseMocks() async {
//   TestWidgetsFlutterBinding.ensureInitialized(); // 테스트 환경 설정
//
//   // Firebase 초기화 작업을 Mock으로 대체
//   await Firebase.initializeApp();
//
//   // // MethodChannel과 BasicMessageChannel의 Mock 처리
//   // final mockMethodChannel = MethodChannel('mock_channel');  // Mock MethodChannel 선언
//   // final mockBasicMessageChannel = MockBasicMessageChannel();
//   //
//   // // MethodChannel Mock 설정: 네이티브 호출을 가짜로 처리
//   // when(mockMethodChannel.invokeMethod(any<String>(), any<Map<String, dynamic>?>())).thenAnswer((_) async => 'result');
//   //
//   //
//   // // BasicMessageChannel Mock 설정: 기본 응답 처리
//   // when(mockBasicMessageChannel.send(captureAny))
//   //     .thenAnswer((_) async => 'result');  // 빈 문자열 반환으로 처리
// }
