import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:myapp/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({required String uid, String? email})
      : super(uid: uid, email: email);

  factory UserModel.fromFirebaseUser(firebase_auth.User user) {
    return UserModel(uid: user.uid, email: user.email);
  }
}
