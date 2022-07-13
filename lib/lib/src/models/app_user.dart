class AppUser {

  const AppUser({
    required this.id,
    this.email,
  });

  AppUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        email = json['email'] as String;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'email': email,
  };

  final String? email;

  final String id;


  static const AppUser empty = AppUser(id: '');

  bool get isEmpty => this == AppUser.empty;

  bool get isNotEmpty => this != AppUser.empty;

}
