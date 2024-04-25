import 'package:dalvi/models/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Users _user = Users(
    id: '',
    name: '',
    email: '',
    otp: [],
    phone: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
  );

  Users get user => _user;

  void setUser(String user) {
    _user = Users.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(Users user) {
    _user = user;
    notifyListeners();
  }
}
