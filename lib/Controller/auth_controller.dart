import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String password;
  final Timestamp? createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    this.createdAt,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? 'N/A',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      createdAt: data['createdAt'],
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? password,
    Timestamp? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AuthController extends GetxController {
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);

  UserModel? get currentUser => _currentUser.value;
  String? get currentUserId => _currentUser.value?.uid;

  void setUser(UserModel user) {
    _currentUser.value = user;
  }

  void updateUserInfo(String name) {
    if (_currentUser.value != null) {
      _currentUser.value = _currentUser.value!.copyWith(name: name);
    }
  }

  void clearUser() {
    _currentUser.value = null;
  }
}
