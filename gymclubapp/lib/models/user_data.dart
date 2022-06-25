// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymclubapp/models/template_groups.dart';

class UserData {
  final String email;
  final String username;
  final String? firstName;
  final String? lastName;
  final int? dateOfBirth;
  final int? phoneNumber;
  final String? instagram;
  final String? snapchat;
  final String? tiktok;
  Map<String, TemplateGroups>? templateGroups;

  UserData({
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.phoneNumber,
    this.instagram,
    this.snapchat,
    this.tiktok,
  });

  factory UserData.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserData(
      email: data?['email'],
      username: data?['username'],
      firstName: data?['firstName'],
      lastName: data?['lastName'],
      dateOfBirth: data?['DoB'],
      phoneNumber: data?['phoneNumber'],
      instagram: data?['instagram'],
      snapchat: data?['snapchat'],
      tiktok: data?['tiktok'],
    );
  }

  String printData() {
    return "$username has been stored into UserData Class";
  }

  Map<String, dynamic> toFirestore() {
    return {
      "email": email,
      "username": username,
      if (firstName != null) "firstName": firstName,
      if (lastName != null) "lastName": lastName,
      if (dateOfBirth != null) "DoB": dateOfBirth,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      if (instagram != null) "instagram": instagram,
      if (snapchat != null) "snapchat": snapchat,
      if (tiktok != null) "tiktok": tiktok,
    };
  }
}
