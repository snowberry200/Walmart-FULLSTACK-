class AuthRequestDTO {
  final String email;
  final String password;
  final String name;
  final bool isActive;

  AuthRequestDTO(
      {required this.email,
      required this.password,
      required this.name,
      required this.isActive});

  //signin
  factory AuthRequestDTO.forSignIn(
      String email, String password, bool isActive) {
    return AuthRequestDTO(
        email: email, password: password, name: '', isActive: isActive);
  }

  //check email
  factory AuthRequestDTO.checkEmail(String email, bool isActive) {
    return AuthRequestDTO(
        email: email, isActive: isActive, password: '', name: '');
  }

  //signup
  factory AuthRequestDTO.forSignUp(
      String name, String email, String password, bool isActive) {
    return AuthRequestDTO(
        email: email, password: password, name: name, isActive: isActive);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['email'] = email;
    data['password'] = password;
    if (name.isNotEmpty) {
      data['name'] = name;
      // data['isActive'] = isActive;
    }
    return data;
  }
}
