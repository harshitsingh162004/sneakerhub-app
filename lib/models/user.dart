class User {
  final String token;
  final String role;
  final String name;

  User({
    required this.token,
    required this.role,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        token: json['token'],
        role: json['role'],
        name: json['name'],
      );
}
