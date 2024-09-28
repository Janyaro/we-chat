import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:we_chat/models/chatmodel.dart';
import 'package:we_chat/models/messageModel.dart';
import 'package:we_chat/widget/messageCart.dart';

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

  // get user information
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSpecficUserInfo(
      chatmodel user) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .snapshots(); // This listens to re al-time updates
  }

  // update Active status

  static Future<void> updateActiveStatus(bool isonline) async {
    await firestore.collection('users').doc(user!.uid).update({
      'isonline': isonline,
      'last_active': DateTime.now().millisecondsSinceEpoch, // Store timestamp
    });
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

  static String conversion_id(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  /// *************message related Api
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(
      chatmodel user) {
    return firestore
        .collection(
            'chatMessages/${conversion_id(user.id.toString())}/message/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> SendMessage(
      chatmodel chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch;
    final messageModel message = messageModel(
        msg: msg,
        fromId: user.uid,
        told: chatUser.id,
        type: type,
        sent: time.toString(),
        read: '');

    final ref = firestore.collection(
        'chatMessages/${conversion_id(chatUser.id.toString())}/message/');

    try {
      await ref.doc(time.toString()).set(message.toJson());
      print('Message sent successfully');
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  static Future<void> updateRead(messageModel message) async {
    // Performing the update
    firestore
        .collection(
            'chatMessages/${conversion_id(message.fromId.toString())}/message/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      chatmodel user) {
    return firestore
        .collection(
            'chatMessages/ ${conversion_id(user.id.toString())}/message/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> getCameraImage(chatmodel user, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'image/${conversion_id(user.id.toString())}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('data transfer successfully ${p0.bytesTransferred / 1000} kb');
    });
    final imageUrl = await ref.getDownloadURL();
    await Api.SendMessage(user, imageUrl, Type.Image);
  }
}

// create the new user

// ignore: non_constant_identifier_names
