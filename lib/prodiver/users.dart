import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_crud/data/dummy_users.dart';
import 'package:flutter_crud/models/User.dart';
import 'package:http/http.dart' as http;

class Users with ChangeNotifier {

  static const _baserUrl = "";

  final Map<String, User> _items = {...DUMMY_USERS};

  List<User> get all { 
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  User byIndex( int i) { 
    return _items.values.elementAt(i);
  }

  Future<void> put(User user)  async{
    if(user == null) {
      return;
    }
    
    // alterar 

    if( user.id != null && 
      user.id.trim().isEmpty && 
      _items.containsKey(user.id)) {
      _items.update(user.id, (_) => User(
        id: user.id,
        name: user.name,
        email: user.email,
        avatarUrl: user.avatarUrl,
        ));
    } else {

      final response = await http.post(
        "$_baserUrl/users.json", 
        body : jsonEncode({
          'name': user.name, 
          'email': user.email, 
          'avatarUrl': user.avatarUrl,
        }),
      );

      final id = jsonDecode(response.body) ['name'];

        _items.putIfAbsent(id, () => User(
          id: id, 
          name: user.name, 
          email: user.email, 
          avatarUrl: user.avatarUrl,
          ),
        );
      }    
    notifyListeners();
  }

  void remove(User user) {
    if( user != null && user.id != null){
      _items.remove(user.id);
      notifyListeners();
    }
  }
}