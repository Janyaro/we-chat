import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:we_chat/models/chatmodel.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  // fatch the current user
  static User get user => auth.currentUser!;
  // for store the current user info
  static late chatmodel me;
// check the user exist or not in the collection
  static Future<bool> ExistedUser() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // get the userInfo
  static Future<void> getUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = chatmodel.fromJson(user.data()!);
      } else {
        await CreateUser();
      }
    });
  }

  // create the user
  static Future<void> CreateUser() async {
    final create_time = DateTime.now();
    final new_user = chatmodel(
        id: user.uid,
        name: user.displayName.toString(),
        eMail: user.email,
        about: 'hey there i am using chat app',
        image: user.photoURL,
        createdAt: create_time.toString(),
        lastActive: create_time.toString(),
        isonline: false,
        pushtoken: '');

    return (await firestore
        .collection('users')
        .doc(user.uid)
        .set(new_user.toJson()));
  }

// fatch all the users form the database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // ignore: non_constant_identifier_names
  static Future<void> ChangeUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  static Future<void> uploadProfilePic(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('user_image/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('data transfer successfully ${p0.bytesTransferred / 1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'image': me.image,
    });
  }

  /// *************message related Api
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage() {
    return firestore.collection('message').snapshots();
  }
}

// create the new user

// ignore: non_constant_identifier_names
