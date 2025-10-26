class AuthRepository {
  final String emailMock = "usuario";
  final String passwordMock = "123456";

  bool login({required String email, required String password}) {
    if (email == emailMock && password == passwordMock) {
      return true;
    }

    return false;
  }
}
