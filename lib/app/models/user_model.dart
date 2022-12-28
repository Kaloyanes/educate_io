class UserModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final DateTime birthDate;

  int age = 0;

  UserModel(this.name, this.email, this.password, this.role, this.birthDate) {
    age = (DateTime.now().difference(birthDate).inDays / 365).round();
  }
}
