import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. 앱 진입 시 호출할 익명 로그인 함수
  Future<User?> signInAnonymously() async {
    try {
      // 이미 로그인된 상태인지 확인
      User? user = _auth.currentUser;

      // 로그인 정보가 없다면 익명 로그인 수행
      if (user == null) {
        UserCredential userCredential = await _auth.signInAnonymously();
        user = userCredential.user;
        debugPrint("사부작: 익명 로그인 성공 (UID: ${user?.uid})");
      }
      return user;
    } catch (e) {
      debugPrint("사부작: 익명 로그인 에러 발생 - $e");
      return null;
    }
  }

  // 2. 현재 유저의 UID 가져오기
  String? get currentUserId => _auth.currentUser?.uid;

  // 3. 로그아웃 (초기화 테스트용)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}