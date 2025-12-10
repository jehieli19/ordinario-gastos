

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  AuthStatus status = AuthStatus.initial;
  String? errorMessage;

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  Future<bool> register(String email, String password) async {
    status = AuthStatus.loading;
    notifyListeners();
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: null,
      );
      // If session is null, it means email confirmation is required.
      // We return true to indicate "success" in starting the process.
      if (response.user != null) {
        status = AuthStatus.unauthenticated; // Still unauthenticated until verified
        clearError();
        return true;
      } else {
        status = AuthStatus.error;
        errorMessage = response.toString();
        notifyListeners();
        return false;
      }
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String token) async {
    status = AuthStatus.loading;
    notifyListeners();
    try {
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );
      if (response.session != null) {
        status = AuthStatus.authenticated;
        clearError();
        return true;
      } else {
        status = AuthStatus.error;
        errorMessage = 'Verificación fallida';
        notifyListeners();
        return false;
      }
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    status = AuthStatus.loading;
    notifyListeners();
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        status = AuthStatus.authenticated;
        clearError();
        return true;
      } else {
        status = AuthStatus.error;
        errorMessage = response.toString();
        notifyListeners();
        return false;
      }
    } catch (e) {
      status = AuthStatus.error;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    status = AuthStatus.unauthenticated;
    clearError();
  }
}
