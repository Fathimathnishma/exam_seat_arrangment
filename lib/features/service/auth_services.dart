import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final firestore = FirebaseFirestore.instance;
  final firebase = FirebaseFirestore.instance.collection("users");
}