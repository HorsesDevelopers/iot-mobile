import 'package:flutter/foundation.dart';
import '../domain/usecases/sign_in_use_case.dart';
import '../domain/usecases/sign_up_use_case.dart';

enum AuthStatus { initial, authenticating, authenticated, error }

class AuthProvider with ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;

  AuthStatus _status = AuthStatus.initial;
  String? _error;
  String? _token;

  AuthProvider({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
  })  : _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase;

  AuthStatus get status => _status;
  String? get error => _error;
  String? get token => _token;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<bool> signIn(String username, String password) async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();

    final result = await _signInUseCase.execute(username, password);

    return result.fold(
          (failure) {
        _status = AuthStatus.error;
        _error = failure.message;
        notifyListeners();
        return false;
      },
          (authToken) {
        if (authToken.token.isNotEmpty) {
          _status = AuthStatus.authenticated;
          _token = authToken.token;
          notifyListeners();
          return true;
        } else {
          _status = AuthStatus.error;
          _error = "Invalid authentication token";
          notifyListeners();
          return false;
        }
      },
    );
  }
  Future<bool> signUp(String username, String password) async {
    _status = AuthStatus.authenticating;
    _error = null;
    notifyListeners();
    final result = await _signUpUseCase.execute(
        username, password, ['ROLE_FISH_FARMER_TECHNICIAN']);

    return result.fold(
          (failure) {
        _status = AuthStatus.error;
        _error = failure.message;
        notifyListeners();
        return false;
      },
          (user) {
        _status = AuthStatus.initial;
        notifyListeners();
        return true;
      },
    );
  }

  void signOut() {
    _status = AuthStatus.initial;
    _token = null;
    _error = null;
    notifyListeners();
  }
}