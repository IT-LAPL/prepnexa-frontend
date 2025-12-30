class AuthService {
  AuthService._private() {
    // Pre-seed demo credentials for quick testing
    name = 'Demo User';
    email = 'demo@prepnexa.dev';
    _password = 'password123';
    isLoggedIn = false;
  }
  static final AuthService instance = AuthService._private();

  String? name;
  String? email;
  String? _password;
  bool isLoggedIn = false;

  bool signUp({required String name, required String email, required String password}) {
    this.name = name;
    this.email = email;
    _password = password;
    isLoggedIn = true;
    return true;
  }

  bool signIn({required String email, required String password}) {
    if (this.email == null || _password == null) return false;
    if (this.email!.toLowerCase() == email.toLowerCase() && _password == password) {
      isLoggedIn = true;
      return true;
    }
    return false;
  }

  void logout() {
    isLoggedIn = false;
  }
}
