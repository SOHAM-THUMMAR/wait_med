// lib/models/user.dart
// Defines the basic user structure used by AuthController.
class AppUser {
  final String uid;
  final String email;
  final String name;

  AppUser({required this.uid, required this.email, this.name = 'User'});
}
