class LoginParm {
  final String email;
  final String password;

  LoginParm({required this.email, required this.password});
}

class UpdateUserParm {
  final String uid;
  final Map<String, dynamic> data;

  UpdateUserParm({required this.uid, required this.data});
}
