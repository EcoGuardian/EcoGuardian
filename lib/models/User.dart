import 'package:flutter/material.dart';

class User {
  String id;
  String name;
  String email;
  String? profilePicture;
  String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    required this.role,
  });
}
