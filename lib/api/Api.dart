import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/ChatModel.dart';
import 'package:we_chat/models/messageModel.dart';

class Api {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  // Fetch the current user
  static User get user => auth.currentUser!;

  // Store the current user info
  static late ChatModel me;

  // Check if the user exists in the collection
  static Future<bool> ExistedUser() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // Get user info
  static Future<void> getUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatModel.fromJson(user.data()!);

        Api.updateActiveStatus(true);
      } else {
        await CreateUser();
      }
    });
  }

  // Create a new user
  static Future<void> CreateUser() async {
    final createTime = DateTime.now().millisecondsSinceEpoch;
    final newUser = ChatModel(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email,
        about: 'Hey there, I am using chat app',
        image: user.photoURL,
        createdAt: createTime.toString(),
        lastActive: createTime.toString(),
        isOnline: false,
        pushToken: '');

    await firestore.collection('users').doc(user.uid).set(newUser.toJson());
  }

  // Fetch all users from the database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // Get specific user information
  static Stream<QuerySnapshot<Map<String, dynamic>>> getSpecficUserInfo(
      ChatModel user) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: user.id)
        .snapshots();
  }

  // Update active status
  static Future<void> updateActiveStatus(bool isonline) async {
    await firestore.collection('users').doc(user.uid).update({
      'isonline': isonline,
      'last_active': DateTime.now().millisecondsSinceEpoch,
      'pushtoken': me.pushToken
    });
  }

  // Change user info
  static Future<void> ChangeUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'name': me.name, 'about': me.about});
  }

  // Upload profile picture
  static Future<void> uploadProfilePic(File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child('user_image/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data transfer successfully: ${p0.bytesTransferred / 1000} kb');
    });
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'image': me.image,
    });
  }

  // Generate conversation ID for communication between the users
  static String conversion_id(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  /// ************* Message-related API *************

  // Fetch all messages of the users 
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(
      ChatModel user) {
    return firestore
        .collection(
            'chatMessages/${conversion_id(user.id.toString())}/message/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // Send a message to the useer 
  static Future<void> SendMessage(
      ChatModel chatUser, String msg, Type type) async {
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

  // Update message read status
  static Future<void> updateRead(messageModel message) async {
    final docRef = firestore
        .collection(
            'chatMessages/${conversion_id(message.fromId.toString())}/message/')
        .doc(message.sent);

    // Check if the message document exists before updating
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      await docRef.update({
        'read': DateTime.now().millisecondsSinceEpoch.toString(),
      });
    } else {
      print('Document not found: ${message.sent}');
    }
  }

  // Get the last message in a conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatModel user) {
    return firestore
        .collection(
            'chatMessages/${conversion_id(user.id.toString())}/message/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  // Upload and send an image message
  static Future<void> getCameraImage(ChatModel user, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'image/${conversion_id(user.id.toString())}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data transfer successfully: ${p0.bytesTransferred / 1000} kb');
    });
    final imageUrl = await ref.getDownloadURL();
    await Api.SendMessage(user, imageUrl, Type.Image);
  }
}
