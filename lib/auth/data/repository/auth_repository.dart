class AuthRepository {
  final String emailMock = "usuario";
  final String passwordMock = "123456";

  Future<bool> login({required String email, required String password}) async {
    if (email == emailMock && password == passwordMock) {
      return Future.value(true);
    }

    return Future.value(false);
  }
}
