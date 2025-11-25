import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Rx<UserModel?> get rxUser => _currentUser;
  String? get currentUserId => _currentUser.value?.uid;

  Future<void> setUser(UserModel user) async {
    _currentUser.value = user;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", true);
    await prefs.setString("uid", user.uid);
  }

  Future<void> loadUserFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString("uid");

    if (uid == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (doc.exists) {
        final user = UserModel.fromFirestore(doc);
        _currentUser.value = user; // updates UI via rxUser
      }
    } catch (e) {
      print("Error loading user: $e");
    }
  }

  Future<void> updateUserName(String newName) async {
    if (_currentUser.value == null) return;

    final uid = _currentUser.value!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "name": newName,
    });

    _currentUser.value = _currentUser.value!.copyWith(name: newName);
  }

  Future<void> logout() async {
    _currentUser.value = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Get.offAllNamed('/login');
  }
}
