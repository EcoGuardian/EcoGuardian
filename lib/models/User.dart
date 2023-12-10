import 'package:flutter/material.dart';

class User {
  String name;
  String email;
  String? profilePicture;
  String role;

  User({
    required this.name,
    required this.email,
    this.profilePicture,
    required this.role,
  });
}
