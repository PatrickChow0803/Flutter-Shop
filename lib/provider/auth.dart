import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;

  // Used to hold when the token will expire
  DateTime _expiryDate;

  String _userId;

  bool get isAuth {
    // if token isn't null, then we're authenticated and vice versa.
    return token != null;
  }

  String get token {
    // Token is valid
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDQcvVdjDzYHSYK4nBoSpvR9m1fsZ09uQ8';

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      // these are the values given back from the server
      _token = responseData['idToken'];
      _userId = responseData['localId'];

      // The expiration time of the token is the current time + the time that's given back from the server.
      // The time that's given back from the server is of type String so therefore make it an int.
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'])));

      // Used to trigger the consumer widget inside of main.dart to let the app know if the user is authenticated or not
      notifyListeners();
    } catch (error) {
      throw error;
    }

//    print(json.decode(response.body));
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDQcvVdjDzYHSYK4nBoSpvR9m1fsZ09uQ8';
    final response = await http.post(url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
//    print(json.decode(response.body));
  }
}
